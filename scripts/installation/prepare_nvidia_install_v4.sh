#!/bin/bash
set -e

echo "=== 🧰 NVIDIA Driver & CUDA Preparation for Rocky Linux 9 (v4) ==="

# --- Detect UEFI vs BIOS ---
if [ -d /sys/firmware/efi ]; then
  GRUB_CFG="/boot/efi/EFI/rocky/grub.cfg"
  BOOT_MODE="UEFI"
else
  GRUB_CFG="/boot/grub2/grub.cfg"
  BOOT_MODE="BIOS"
fi
echo "🧠 Detected boot mode: $BOOT_MODE"
echo "→ Using GRUB config: $GRUB_CFG"
echo

# --- Step 1: Refresh repositories ---
echo "🔍 Refreshing DNF metadata..."
sudo dnf clean all -y
sudo dnf makecache -y

# --- Step 2: Install prerequisites ---
echo "📦 Installing build dependencies..."
sudo dnf groupinstall -y "Development Tools"
sudo dnf install -y elfutils-libelf-devel kernel-devel-$(uname -r)

# --- Step 3: Install kernel headers ---
echo "🔎 Ensuring kernel headers are available..."
if ! sudo dnf install -y kernel-headers-$(uname -r); then
    echo "⚠️ Exact kernel headers not found for $(uname -r). Installing closest available..."
    sudo dnf install -y kernel-headers
fi

# --- Step 4: Sanity check /lib/modules ---
KVER=$(uname -r)
MODDIR="/lib/modules/$KVER"

echo "🔎 Checking /lib/modules directory for $KVER..."
if [ ! -d "$MODDIR" ]; then
    echo "⚠️ Missing /lib/modules/$KVER — attempting to repair kernel module packages..."
    sudo dnf reinstall -y kernel kernel-core kernel-modules kernel-modules-extra
    if [ ! -d "$MODDIR" ]; then
        echo "❌ Could not restore /lib/modules/$KVER automatically."
        echo "   Try manually installing kernel packages for $KVER:"
        echo "   sudo dnf install kernel-$KVER kernel-core-$KVER kernel-modules-$KVER kernel-modules-extra-$KVER"
        exit 1
    fi
else
    echo "✅ Kernel modules directory exists: $MODDIR"
fi

# --- Step 5: Check version consistency ---
HDR=$(rpm -q kernel-headers --qf '%{VERSION}-%{RELEASE}.%{ARCH}\n' || echo "missing")
DEV=$(rpm -q kernel-devel --qf '%{VERSION}-%{RELEASE}.%{ARCH}\n' || echo "missing")

echo -e "\n🧩 Running kernel: $KVER"
echo "🧩 Installed headers: $HDR"
echo "🧩 Installed devel:   $DEV"
echo

if [[ "$HDR" != *"$KVER"* || "$DEV" != *"$KVER"* ]]; then
  echo "⚠️ Kernel/header mismatch detected!"
  read -p "➡️  Do you want to upgrade and reboot automatically now? [Y/n]: " RESP
  RESP=${RESP,,}
  if [[ "$RESP" != "n" ]]; then
      echo "🧱 Upgrading kernel, headers, and devel packages..."
      sudo dnf upgrade -y kernel kernel-devel kernel-headers
      echo "🔁 Rebooting to load new kernel..."
      sudo reboot
      exit 0
  fi
fi

# --- Step 6: Disable Nouveau completely ---
echo "🚫 Disabling Nouveau..."
sudo bash -c 'cat > /etc/modprobe.d/blacklist-nouveau.conf <<EOF
blacklist nouveau
options nouveau modeset=0
EOF'
sudo dracut --force

# Ensure GRUB line includes nouveau.modeset=0
if ! grep -q "nouveau.modeset=0" /etc/default/grub; then
  echo "🧩 Adding nouveau.modeset=0 to GRUB_CMDLINE_LINUX..."
  sudo sed -i 's/\(GRUB_CMDLINE_LINUX="[^"]*\)"/\1 nouveau.modeset=0"/' /etc/default/grub
fi

# Rebuild GRUB using detected mode
echo "⚙️  Rebuilding GRUB configuration ($BOOT_MODE)..."
sudo grub2-mkconfig -o "$GRUB_CFG"

# --- Step 7: Verify Nouveau status ---
if lsmod | grep -q nouveau; then
  echo "⚠️ Nouveau module is still loaded in memory."
  echo "   Reboot required to fully unload it."
  read -p "➡️  Press ENTER to reboot now..." 
  sudo reboot
  exit 0
fi

# --- Step 8: NVIDIA driver install prompt ---
echo
read -p "➡️  Press ENTER to proceed with NVIDIA driver installation (.run file), or Ctrl+C to cancel..."

echo "🔍 Searching for NVIDIA-Linux-*.run installer..."
INSTALLER=$(ls -1 NVIDIA-Linux-*.run 2>/dev/null | head -n 1)
if [ -z "$INSTALLER" ]; then
  echo "❌ No NVIDIA-Linux-*.run file found in this directory!"
  echo "   Download it from https://www.nvidia.com/Download/ and rerun this script."
  exit 1
fi

chmod +x "$INSTALLER"
echo "✅ Found installer: $INSTALLER"

# --- Step 9: Switch to text mode if in GUI ---
if systemctl get-default | grep -q graphical; then
  echo "🖥️  Switching to text mode..."
  sudo systemctl set-default multi-user.target
  echo "⚠️  The system will reboot to text mode for safe driver installation."
  read -p "➡️  Press ENTER to reboot now..."
  sudo reboot
  exit 0
fi

# --- Step 10: Run NVIDIA installer (second run) ---
if [ ! -f /tmp/.nvidia_driver_done ]; then
  echo "⚙️  Installing NVIDIA driver..."
  sudo ./"$INSTALLER" --no-drm --dkms || {
      echo "❌ NVIDIA driver installation failed!"
      exit 1
  }
  sudo touch /tmp/.nvidia_driver_done
fi

# --- Step 11: Restore graphical mode ---
sudo systemctl set-default graphical.target
echo "✅ NVIDIA driver installation complete!"
echo "💻 You may now reboot to load the new driver."

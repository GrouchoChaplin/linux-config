#!/usr/bin/env bash
set -euo pipefail

echo "=== 🧭 Preparing repositories ==="
sudo dnf install -y dnf-plugins-core epel-release

# Enable CRB (CodeReady Builder) with mirror fallback
if ! sudo dnf repolist | grep -q 'crb'; then
  echo "Enabling CRB repository..."
  sudo dnf config-manager --set-enabled crb || true
fi

# If CRB mirrors are broken, switch to main Rocky mirror
sudo sed -i 's|^mirrorlist=|#mirrorlist=|' /etc/yum.repos.d/Rocky-CRB.repo 2>/dev/null || true
sudo sed -i 's|^#baseurl=https://dl|baseurl=https://dl|' /etc/yum.repos.d/Rocky-CRB.repo 2>/dev/null || true

sudo dnf clean all
sudo dnf makecache -y

echo "=== 🧱 Installing core tools ==="
sudo dnf update -y
sudo dnf install -y terminator

echo "=== 🪶 Installing Sublime Text ==="
sudo rpm --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
sudo tee /etc/yum.repos.d/sublime-text.repo >/dev/null <<'EOF'
[sublime-text]
name=Sublime Text - x86_64 - Stable
baseurl=https://download.sublimetext.com/rpm/stable/x86_64
enabled=1
gpgcheck=1
gpgkey=https://download.sublimetext.com/sublimehq-rpm-pub.gpg
EOF
sudo dnf install -y sublime-text sublime-merge

echo "=== 💻 Installing Visual Studio Code ==="
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo tee /etc/yum.repos.d/vscode.repo >/dev/null <<'EOF'
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
type=rpm-md
EOF
sudo dnf install -y code

echo "=== 🧩 Installing VS Code extensions ==="
extensions=(
  # C++
  ms-vscode.cpptools
  ms-vscode.cmake-tools
  llvm-vs-code-extensions.vscode-clangd
  twxs.cmake
  matepek.vscode-catch2-test-adapter
  # Flutter/Dart
  dart-code.dart-code
  dart-code.flutter
  alexisvt.flutter-snippets
  jeroen-meijer.pubspec-assist
  # Markdown
  yzhang.markdown-all-in-one
  DavidAnson.vscode-markdownlint
  shd101wyy.markdown-preview-enhanced
  telesoho.vscode-markdown-paste-image
  darkriszty.markdown-table-prettify
  # Appearance
  zhuangtongfa.Material-theme
  PKief.material-icon-theme
  Equinusocio.vsc-material-theme-icons
  oderwat.indent-rainbow
)
for ext in "${extensions[@]}"; do
  code --install-extension "$ext" || echo "⚠️ Failed: $ext"
done

echo "=== ✅ Setup complete! ==="
echo "Launch apps with: terminator, subl, sublime_merge, code"

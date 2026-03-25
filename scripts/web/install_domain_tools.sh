#!/bin/bash
# ============================================================
#  Domain Analysis & Recon Tool Installer for Rocky Linux 9
#  Installs: whois, dig, nslookup, whatweb, openssl, testssl,
#            nmap, mmdblookup, geoipupdate, virustotal-cli,
#            abuseipdb, jq, etc.
# ============================================================

set -e

# ----- Colors -----
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
RESET="\e[0m"

banner() {
  echo -e "\n${BLUE}========== $1 ==========${RESET}\n"
}

# ----- Prerequisites -----
banner "Enabling Repositories"
sudo dnf install -y epel-release
sudo dnf config-manager --set-enabled crb || true
sudo dnf makecache

# ----- Core Network Tools -----
banner "Installing Core Networking Tools"
sudo dnf install -y bind-utils traceroute nmap curl wget git net-tools jq

# ----- WHOIS -----
banner "Installing WHOIS"
sudo dnf install -y whois

# ----- SSL & Security Tools -----
banner "Installing SSL/TLS & Security Utilities"
sudo dnf install -y openssl sslscan
if [ ! -d "/opt/testssl.sh" ]; then
  git clone --depth 1 https://github.com/drwetter/testssl.sh.git /opt/testssl.sh
  sudo ln -sf /opt/testssl.sh/testssl.sh /usr/local/bin/testssl
fi

# ----- Tech Stack Detector -----
banner "Installing whatweb"
sudo dnf install -y whatweb

# ----- GeoIP2 (MaxMind) -----
banner "Installing GeoIP2 / MaxMind Tools"
sudo dnf install -y geoipupdate libmaxminddb libmaxminddb-devel mmdblookup || {
  echo -e "${YELLOW}GeoIP2 packages not found in base repo. Ensure EPEL is enabled.${RESET}"
}

# Create GeoIP.conf if missing
if [ ! -f /etc/GeoIP.conf ]; then
  echo -e "${YELLOW}Creating placeholder /etc/GeoIP.conf (add your MaxMind key manually later)${RESET}"
  sudo tee /etc/GeoIP.conf >/dev/null <<'EOF'
AccountID 0
LicenseKey YOUR_LICENSE_KEY_HERE
EditionIDs GeoLite2-City GeoLite2-Country
EOF
fi

# ----- Python-based Tools -----
banner "Installing Python-based Tools (via pip)"
sudo dnf install -y python3-pip
pip install --upgrade pip
pip install virustotal-cli abuseipdb

# ----- Go-based Tools -----
banner "Installing Go-based Tools (optional: httpx)"
if ! command -v go >/dev/null 2>&1; then
  sudo dnf install -y golang
fi
go install github.com/projectdiscovery/httpx/cmd/httpx@latest
echo 'export PATH=$PATH:~/go/bin' >> ~/.bashrc

# ----- ipinfo CLI -----
banner "Installing ipinfo CLI"
curl -sL https://cli.ipinfo.io/install.sh | bash

# ----- Final Check -----
banner "Installation Summary"
for cmd in whois dig nslookup nmap openssl sslscan testssl whatweb mmdblookup ipinfo jq; do
  command -v $cmd >/dev/null 2>&1 && echo -e "${GREEN}✔ $cmd installed${RESET}" || echo -e "${YELLOW}⚠ $cmd missing${RESET}"
done

echo -e "\n${GREEN}All available tools have been installed or attempted.${RESET}"
echo -e "Add your MaxMind LicenseKey to /etc/GeoIP.conf, then run: sudo geoipupdate"
echo -e "Restart your shell or run: source ~/.bashrc"

#!/bin/bash
# ============================================================
#  DOMAIN INFORMATION REPORTER
#  Collects WHOIS, DNS, SSL, GEO, TECH STACK, and REPUTATION
#  Requires tools from install_domain_tools.sh
# ============================================================

set -e

# ----- Colors -----
RED="\e[31m"; GREEN="\e[32m"; YELLOW="\e[33m"; BLUE="\e[34m"; CYAN="\e[36m"; RESET="\e[0m"

# ----- Usage -----
if [ -z "$1" ]; then
  echo -e "${YELLOW}Usage:${RESET} $0 <domain>"
  exit 1
fi

DOMAIN="$1"
IP=$(dig +short "$DOMAIN" | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' | head -1)
if [ -z "$IP" ]; then
  echo -e "${RED}Error:${RESET} could not resolve IP for $DOMAIN"
  exit 1
fi

# ----- Helper -----
section() {
  echo -e "\n${BLUE}========== $1 ==========${RESET}\n"
}

# ----- 1. WHOIS -----
section "WHOIS"
whois "$DOMAIN" | grep -E "Domain Name|Registrar|Creation|Expiry|Updated|Registrant Organization" || echo -e "${YELLOW}WHOIS lookup failed${RESET}"

# ----- 2. DNS -----
section "DNS RECORDS"
dig "$DOMAIN" A +short | sed 's/^/A: /'
dig "$DOMAIN" MX +short | sed 's/^/MX: /'
dig "$DOMAIN" TXT +short | sed 's/^/TXT: /'
dig "$DOMAIN" NS +short | sed 's/^/NS: /'

# ----- 3. IP & GEO -----
section "IP / GEO INFORMATION"
echo -e "IP Address: ${CYAN}$IP${RESET}\n"
if command -v ipinfo >/dev/null 2>&1; then
  ipinfo "$IP"
elif command -v mmdblookup >/dev/null 2>&1; then
  GEO_DB="/usr/share/GeoIP/GeoLite2-City.mmdb"
  if [ -f "$GEO_DB" ]; then
    mmdblookup --file "$GEO_DB" --ip "$IP" | grep -E 'country|city|subdivisions' || true
  else
    echo -e "${YELLOW}GeoIP database not found. Run sudo geoipupdate.${RESET}"
  fi
else
  echo -e "${YELLOW}ipinfo/mmdblookup not installed${RESET}"
fi

# ----- 4. SSL / CERT -----
section "SSL / CERTIFICATE"
if command -v openssl >/dev/null 2>&1; then
  echo | openssl s_client -connect "$DOMAIN:443" -servername "$DOMAIN" 2>/dev/null | openssl x509 -noout -subject -issuer -dates || echo -e "${YELLOW}No SSL response${RESET}"
fi

if command -v sslscan >/dev/null 2>&1; then
  sslscan --no-failed "$DOMAIN" 2>/dev/null | grep -E "SSLv|TLSv|Cipher|Accepted" | head -20
fi

# ----- 5. TECH STACK -----
section "TECH STACK"
if command -v whatweb >/dev/null 2>&1; then
  whatweb -q "$DOMAIN"
else
  echo -e "${YELLOW}whatweb not installed${RESET}"
fi

# ----- 6. REPUTATION / THREAT INTEL -----
section "REPUTATION CHECKS"
if command -v abuseipdb >/dev/null 2>&1; then
  echo -e "${CYAN}AbuseIPDB:${RESET}"
  abuseipdb check "$IP" --confidence-minimum 25 || echo "  (API key not set)"
else
  echo -e "${YELLOW}abuseipdb not installed${RESET}"
fi

if command -v virustotal >/dev/null 2>&1; then
  echo -e "\n${CYAN}VirusTotal:${RESET}"
  virustotal domain "$DOMAIN" || echo "  (API key not set)"
else
  echo -e "${YELLOW}virustotal-cli not installed${RESET}"
fi

# ----- 7. HTTP HEADERS -----
section "HTTP HEADERS"
curl -I -s "https://$DOMAIN" | grep -E 'HTTP/|Server:|Content-|Strict|X-|Location:'

# ----- Summary -----
section "SUMMARY"
echo -e "Domain: ${GREEN}$DOMAIN${RESET}"
echo -e "Resolved IP: ${GREEN}$IP${RESET}"
echo -e "Date: $(date)"

echo -e "\n${GREEN}Report complete.${RESET}"

#!/usr/bin/env bash

set -e

cat > ~/.evilginx/config.json <<'EOF'
{
  "blacklist": {
    "mode": "unauth"
  },
  "general": {
    "autocert": true,
    "bind_ipv4": "",
    "dns_port": 5533,
    "domain": "",
    "external_ipv4": "",
    "https_port": 443,
    "ipv4": "",
    "unauth_url": "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
  },
  "phishlets": {}
}
EOF

echo "127.0.0.1       official.cloudservice.com" | sudo tee -a /etc/hosts

mkdir -p ~/.evilginx/crt/sites/official.cloudservice.com

openssl req -x509 -nodes -newkey rsa:2048 -sha256 -days 365 \
  -keyout ~/.evilginx/crt/sites/official.cloudservice.com/privkey.pem \
  -out ~/.evilginx/crt/sites/official.cloudservice.com/fullchain.pem \
  -subj "/CN=official.cloudservice.com" \
  -addext "subjectAltName=DNS:official.cloudservice.com"
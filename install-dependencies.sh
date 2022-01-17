#!/bin/bash
set -x

# Default install python 3.8.10
apt update && apt install -y $(cat ./pkglist) && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Python 3.7 & 3.9
add-apt-repository -y ppa:deadsnakes/ppa
apt update
apt install -y python3.7 python3.9 python3.10 libpython3.7-dev

# Change python3 to python 
# Use python3.7 as default to support STAR
update-alternatives --install /usr/bin/python python /usr/bin/python3.7 1
update-alternatives --install /usr/bin/python python /usr/bin/python3 2 #default 3.8
update-alternatives --install /usr/bin/python python /usr/bin/python3.9 3
update-alternatives --install /usr/bin/python python /usr/bin/python3.10 4
update-alternatives --set python /usr/bin/python3.7

# Install python dependencies
python -m pip install --upgrade pip
python -m pip install -r ./requirements.txt

# Install Azure Cloud CLI
npm i -g dps-keygen && curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Install webdriver for selenium
curl -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add
echo "deb [arch=amd64]  http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list
apt update -y
apt install -y google-chrome-stable
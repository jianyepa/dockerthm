#!/bin/bash

# Default install python 3.8.10
apt update && apt install -y $(cat ./pkglist) && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Python 3.7
#  add-apt-repository -y ppa:deadsnakes/ppa
#  apt update
#  apt install python3.7
# OR
# Install Python 3.9
#  apt install python3.9

# Install python dependencies
pip install --upgrade pip
pip install -r ./requirements.txt

# Install Azure Cloud CLI
npm i -g dps-keygen && curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Install webdriver for selenium
curl -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add
echo "deb [arch=amd64]  http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list
apt update -y
apt install -y google-chrome-stable

# Change python3 to python
update-alternatives --install /usr/bin/python python /usr/bin/python3 1
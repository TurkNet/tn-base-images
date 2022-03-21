#!/bin/bash -eux

pubkey_url="https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub";
# set a default HOME_DIR environment variable if not set
HOME_DIR="${HOME_DIR:-/home/vagrant}";
mkdir -p $HOME_DIR/.ssh;
chmod 700 $HOME_DIR/.ssh;

if command -v wget >/dev/null 2>&1; then
    wget --no-check-certificate "$pubkey_url" -O $HOME_DIR/.ssh/authorized_keys;
elif command -v curl >/dev/null 2>&1; then
    curl --insecure --location "$pubkey_url" > $HOME_DIR/.ssh/authorized_keys;
else
    echo "Cannot download vagrant public key";
    exit 1;
fi

chown -R vagrant:vagrant $HOME_DIR/.ssh;
chmod 600 $HOME_DIR/.ssh/authorized_keys;
# chmod -R go-rwsx $HOME_DIR/.ssh;

echo "Get authorized_keys...";
cat $HOME_DIR/.ssh/authorized_keys;




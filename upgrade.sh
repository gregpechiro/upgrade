#!/usr/bin/env bash

clear

echo -e '>>> Updating Repositories <<<\n'
sudo apt-get update

echo -e '\n>>> Upgrading Software <<<\n'
sudo apt-get -y upgrade

if [ -d "/usr/local/src/upgrade/other-upgrades" ]; then
    for FILE in /usr/local/src/upgrade/other-upgrades/*.sh; do
        bash $FILE
    done
fi

echo -e '\n>>> Upgrading Kernel <<<\n'
sudo apt-get -y dist-upgrade

echo -e '\n>>> Removing Unnecessary Files <<<\n'
sudo apt-get -y autoremove

#!/bin/sh

echo "Running playbooks..."

# for now we're creating /MozillaBuilds here w/ sudo
echo "Asking for sudo password to create /MozillaBuilds"
sudo mkdir -p /MozillaBuilds
sudo chown `whoami` /MozillaBuilds

ansible-playbook minimal_playbook.yml -i ../hosts -vvvv
ansible-playbook ../linux/rust-playbook.yml -i ../hosts -vvvv
source ~/.profile
ansible-playbook clone-firefox-playbook.yml -i ../hosts -vvvv

echo "Done running playbooks"


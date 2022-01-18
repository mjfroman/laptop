#!/bin/sh

echo "Running playbooks..."

# for now we're creating /MozillaBuilds here w/ sudo
mkdir -p no_tm_backup/MozillaBuilds

source ~/.profile

ansible-playbook minimal_playbook.yml -i ../hosts -vvvv
ansible-playbook ../linux/rust-playbook.yml -i ../hosts -vvvv
source ~/.profile
ansible-playbook clone-git-repos-playbook.yml -i ../hosts -vvvv

echo "Done running playbooks"


#!/bin/sh

echo "Running playbooks..."

ansible-playbook ../linux/rust-playbook.yml -i ../hosts -vvvv
source ~/.profile
ansible-playbook clone-firefox-playbook.yml -i ../hosts -vvvv

echo "Done running playbooks"


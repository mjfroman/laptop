#!/bin/bash

echo "Running playbooks..."

ansible-playbook linux-playbook.yml -i ../hosts --become --ask-become-pass -vvvv
ansible-playbook rust-playbook.yml -i ../hosts -vvvv
source ~/.profile
ansible-playbook clone-firefox-playbook.yml -i ../hosts -vvvv

echo "Done running playbooks"


#!/bin/sh

echo "Running playbooks..."

ansible-playbook linux-playbook.yml -i ../hosts --ask-sudo-pass -vvvv 
source ~/.profile
ansible-playbook clone-firefox-playbook.yml -i ../hosts -vvvv 

echo "Done running playbooks"


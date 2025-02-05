#!/bin/bash

echo "Running playbooks..."

# After this point:
# * eE: All commands should succeed.
# * u: All variables should be defined before use.
# * o pipefail: All stages of all pipes should succeed.
set -eEuo pipefail

ansible-playbook linux-playbook.yml -i ../hosts --ask-sudo-pass -vvvv
ansible-playbook ../rust/rust-playbook.yml -i ../hosts -vvvv
source ~/.profile
ansible-playbook clone-git-repos-playbook.yml -i ../hosts -vvvv

echo "Done running playbooks"


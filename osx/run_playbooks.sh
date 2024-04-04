#!/bin/sh

echo "Running playbooks..."

# After this point:
# * eE: All commands should succeed.
# * u: All variables should be defined before use.
# * o pipefail: All stages of all pipes should succeed.
set -eEuo pipefail

# for now we're creating /MozillaBuilds here w/ sudo
mkdir -p no_tm_backup/MozillaBuilds

source ~/.profile

ansible-playbook minimal_playbook.yml -i ../hosts -vvvv
ansible-playbook ../linux/rust-playbook.yml -i ../hosts -vvvv
source ~/.profile
ansible-playbook clone-git-repos-playbook.yml -i ../hosts -vvvv

echo "Done running playbooks"


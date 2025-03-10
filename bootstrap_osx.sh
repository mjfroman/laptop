#!/bin/sh

# Welcome to the mjfroman laptop script!
#
# This script bootstraps an OSX laptop to a point where we can run
# Ansible on localhost. It;
#  1. Installs
#    - xcode
#    - homebrew
#    - ansible (via pip3)
#  2. Kicks off the ansible playbook
#    - playbook.yml
#
# It will ask you for your sudo password

fancy_echo() {
  local fmt="$1"; shift

  # shellcheck disable=SC2059
  printf "\n$fmt\n" "$@"
}

fancy_echo "Bootstrapping ..."

trap 'ret=$?; test $ret -ne 0 && printf "failed\n\n" >&2; exit $ret' EXIT

set -e

# Ensure Apple's command line tools are installed - needed for git
# to get started and then other things.
fancy_echo "Prep xcode (for git, etc)"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/mjfroman/laptop/master/scripts/prep_xcode.sh)"

# Clone the repository to your local drive.
if [ -d "./laptop" ]; then
  fancy_echo "Laptop repo dir exists. Removing ..."
  rm -rf ./laptop/
fi
fancy_echo "Cloning laptop repo ..."
git clone https://github.com/mjfroman/laptop

fancy_echo "Changing to laptop repo dir ..."
cd laptop

# Ensure brew and ansible are installed
fancy_echo "Prep brew and ansible"
(cd scripts && bash ./prep_brew_ansible.sh)

# Run this from the same directory as this README file.
fancy_echo "Running ansible playbook ..."
#ansible-playbook playbook.yml -i hosts --ask-sudo-pass -vvvv
(cd osx/ && bash ./run_playbooks.sh)

# Finally, do a "basic" bootstrap and clone of firefox
(cd scripts && bash ./clone_firefox_repo.sh)

(cd scripts && bash ./show_final_message.sh)

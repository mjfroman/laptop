#!/bin/sh

# Welcome to the mfroman laptop script!
# Be prepared to turn your Ubuntu box into 
# a development beast.
#
# This script bootstraps our Ubuntu laptop to a point where we can run
# Ansible and Git on localhost. It;
#  1. Installs 
#    - ansible (via apt-get) 
#    - Git (via apt-get)
#  2. Kicks off the ansible playbook
#    - main.yml
#
# It will ask you for your sudo password

fancy_echo() {
  local fmt="$1"; shift

  # shellcheck disable=SC2059
  printf "\n$fmt\n" "$@"
}

fancy_echo "Boostrapping ..."

trap 'ret=$?; test $ret -ne 0 && printf "failed\n\n" >&2; exit $ret' EXIT

set -e

# first thing -  set screen for Ubuntu VM
xrandr --output `xrandr | grep " connected" | cut -f 1 -d " "` --mode 1440x900

# [Install Ansible](http://docs.ansible.com/intro_installation.html).
if ! command -v ansible >/dev/null; then
  fancy_echo "Installing Ansible ..."
  sudo apt-get install ansible
else
  fancy_echo "Ansible already installed. Skipping."
fi

if ! command -v git >/dev/null; then
  fancy_echo "Installing Git ..."
  sudo apt-get install git
else
  fancy_echo "Git already installed. Skipping."
fi

# Clone the repository to your local drive.
if [ -d "./laptop" ]; then
  fancy_echo "Laptop repo dir exists. Removing ..."
  rm -rf ./laptop/
fi
fancy_echo "Cloning laptop repo ..."
git clone https://github.com/mfroman/laptop.git 

fancy_echo "Changing to laptop repo dir ..."
cd laptop

# Run this from the same directory as this README file. 
#fancy_echo "Running ansible playbook ..."
#ansible-playbook playbook.yml -i hosts --ask-sudo-pass -vvvv 

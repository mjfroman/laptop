#!/bin/bash

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

fancy_echo "Bootstrapping ..."

trap 'ret=$?; test $ret -ne 0 && printf "failed\n\n" >&2; exit $ret' EXIT

set -e

UBUNTU_RELEASE=`lsb_release -r | awk '{ print $2; }'`
if [ "x$UBUNTU_RELEASE" = "x18.04" ]; then
  ANSIBLE_DIR=ubuntu-18
elif [ "x$UBUNTU_RELEASE" = "x20.04" ]; then
  ANSIBLE_DIR=ubuntu-20
elif [ "x$UBUNTU_RELEASE" = "x22.04" ]; then
  # currently, we can reuse the ubuntu-20 stuff for 22.04
  ANSIBLE_DIR=ubuntu-20
else
  echo "UBUNTU_RELEASE is not expected ($UBUNTU_RELEASE)"
  exit
fi

# Update apt-get lists to make sure we find ansible on fresh digital ocean installs
sudo apt-get update

# [Install Ansible](http://docs.ansible.com/intro_installation.html).
if ! command -v ansible >/dev/null; then
  fancy_echo "Installing Ansible ..."
  sudo apt-get install --assume-yes ansible
else
  fancy_echo "Ansible already installed. Skipping."
fi

if ! command -v git >/dev/null; then
  fancy_echo "Installing Git ..."
  sudo apt-get install --assume-yes git
else
  fancy_echo "Git already installed. Skipping."
fi

# Clone the repository to your local drive.
if [ -d "./laptop" ]; then
  fancy_echo "Laptop repo dir exists. Removing ..."
  rm -rf ./laptop/
fi
fancy_echo "Cloning laptop repo ..."
git clone https://github.com/mjfroman/laptop

fancy_echo "Changing to laptop repo dir ..."
cd laptop

if [ ! -d $ANSIBLE_DIR ]; then
  echo "No directory is found for $ANSIBLE_DIR"
  exit
fi

# Run this from the same directory as this README file. 
fancy_echo "Running ansible playbook ..."
(cd $ANSIBLE_DIR/ && bash ./run_playbooks.sh)

# Set some very basic environmental things (term size, dock apps)
GNOME_SHELL_SCHEMA=`gsettings list-schemas | grep "oorg.gnome.shell$" | wc -l`
if [ "x1" = "x$GNOME_SHELL_SCHEMA" ]; then
if command -v gsettings >/dev/null; then
  gsettings set org.gnome.shell favorite-apps "['firefox.desktop', 'org.gnome.Nautilus.desktop', 'libreoffice-writer.desktop', 'org.gnome.Software.desktop', 'update-manager.desktop', 'org.gnome.Terminal.desktop', 'gnome-system-monitor_gnome-system-monitor.desktop']"
fi
fi
if command -v dconf >/dev/null; then
  # For more info, see: http://www.growingwiththeweb.com/2015/05/colours-in-gnome-terminal.html
  # run this command to get default terminal profile name
  # dconf list /org/gnome/terminal/legacy/profiles:/
  # run these commands to set default term size and unlimited scrollback
  dconf write /org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/default-size-columns 110
  dconf write /org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/default-size-rows 24
  dconf write /org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/scrollback-unlimited true
fi

# Finally, do a "basic" bootstrap and clone of firefox
source ~/.profile # to pick up mercurial path in ~/.local/bin
(cd scripts && bash ./clone_firefox_repo.sh)

(cd scripts && bash ./show_final_message.sh)

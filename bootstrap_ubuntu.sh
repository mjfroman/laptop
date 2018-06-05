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

# Run this from the same directory as this README file. 
#fancy_echo "Running ansible playbook ..."
#ansible-playbook playbook.yml -i hosts --ask-sudo-pass -vvvv 
(cd linux/ && bash ./run_playbooks.sh)

# Set some very basic environmental things (term size, dock apps)
gsettings set org.gnome.shell favorite-apps "['firefox.desktop', 'org.gnome.Nautilus.desktop', 'libreoffice-writer.desktop', 'org.gnome.Software.desktop', 'update-manager.desktop', 'org.gnome.Terminal.desktop', 'gnome-system-monitor_gnome-system-monitor.desktop', 'icemon.desktop']"
dconf write /org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/default-size-columns 110
dconf write /org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/default-size-rows 24
dconf write /org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/scrollback-unlimited true

echo "run: cd laptop && openssl enc -aes-256-cbc -d -in env.enc > get_env2.sh && sh get_env2.sh"
echo "run: cd mozilla/moz-central && ./mach bootstrap"
echo "run: cd mozilla/moz-central && ./mach mercurial-setup --update"
echo "run: cd mozilla/moz-central && ./mach eslint --setup"


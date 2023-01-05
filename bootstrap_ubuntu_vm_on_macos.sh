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

fancy_echo "Bootstrapping ..."

trap 'ret=$?; test $ret -ne 0 && printf "failed\n\n" >&2; exit $ret' EXIT

set -e

# first thing -  set screen for Ubuntu VM
xrandr --output `xrandr | grep " connected" | cut -f 1 -d " "` --mode 1440x900

wget https://raw.githubusercontent.com/mjfroman/laptop/master/bootstrap_ubuntu.sh

# then bootstrap as normal
sh ./bootstrap_ubuntu.sh


#!/bin/sh

# This script bootstraps our OSX laptop to a point where we can run
# Ansible on localhost. It;
#  1. Installs
#    - homebrew
#    - ansible (via brew)
#
# It will ask you for your sudo password

fancy_echo() {
  local fmt="$1"; shift

  # shellcheck disable=SC2059
  printf "\n$fmt\n" "$@"
}

fancy_echo "Prep ansible ..."

trap 'ret=$?; test $ret -ne 0 && printf "failed\n\n" >&2; exit $ret' EXIT

set -e

if ! command -v brew >/dev/null; then
  fancy_echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
else
  fancy_echo "Homebrew already installed. Skipping."
fi

# [Install Ansible](http://docs.ansible.com/intro_installation.html).
if ! command -v ansible >/dev/null; then
  fancy_echo "Installing Ansible ..."
  brew install ansible
else
  fancy_echo "Ansible already installed. Skipping."
fi

#!/bin/sh

# This script bootstraps our OSX laptop to a point where we can run
# Ansible on localhost. It;
#  1. Installs
#    - homebrew
#    - ansible (via pip3)
#
# It will ask you for your sudo password

fancy_echo() {
  local fmt="$1"; shift

  # shellcheck disable=SC2059
  printf "\n$fmt\n" "$@"
}

trap 'ret=$?; test $ret -ne 0 && printf "failed\n\n" >&2; exit $ret' EXIT

set -e

fancy_echo "Prep Homebrew ..."

if ! command -v brew >/dev/null; then
  fancy_echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  ( grep -q "brew shellenv" ~/.profile || \
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.profile )

  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  fancy_echo "Homebrew already installed. Skipping."
fi

fancy_echo "Prep ansible ..."

# [Install Ansible](http://docs.ansible.com/intro_installation.html).
if ! command -v ansible >/dev/null; then
  fancy_echo "Installing Ansible ..."
  pip3 install --user ansible
else
  fancy_echo "Ansible already installed. Skipping."
fi

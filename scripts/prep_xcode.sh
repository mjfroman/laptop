#!/bin/sh

# This script bootstraps our OSX laptop to a point where we can run
# Ansible on localhost. It;
#  1. Installs
#    - xcode
#
# It will ask you for your sudo password

fancy_echo() {
  local fmt="$1"; shift

  # shellcheck disable=SC2059
  printf "\n$fmt\n" "$@"
}

fancy_echo "Prep Xcode ..."

trap 'ret=$?; test $ret -ne 0 && printf "failed\n\n" >&2; exit $ret' EXIT

set -e

# Ensure Apple's command line tools are installed
if ! xcode-select -p &>/dev/null; then
  fancy_echo "Installing xcode ..."
  xcode-select --install
else
  fancy_echo "Xcode already installed. Skipping."
fi

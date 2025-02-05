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
  fancy_echo "Look for install app in Dock"
  fancy_echo "Installing xcode ..."
  xcode-select --install
  /bin/echo -n "Waiting "
  # Wait until XCode Command Line Tools installation has finished.
  until $(xcode-select --print-path &> /dev/null); do
    /bin/echo -n "."
    sleep 5;
  done
  /bin/echo ""
else
  fancy_echo "Xcode already installed. Skipping."
fi

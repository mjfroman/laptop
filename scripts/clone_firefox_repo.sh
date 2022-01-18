#!/bin/sh

fancy_echo() {
  local fmt="$1"; shift

  # shellcheck disable=SC2059
  printf "\n$fmt\n" "$@"
}

fancy_echo "Clone firefox repo ..."

trap 'ret=$?; test $ret -ne 0 && printf "failed\n\n" >&2; exit $ret' EXIT

set -e

CLONE_DIR=~/mozilla

mkdir -p $CLONE_DIR && cd $CLONE_DIR
curl https://hg.mozilla.org/mozilla-central/raw-file/default/python/mozboot/bin/bootstrap.py -O && \
python3 bootstrap.py --application-choice=browser \
                     --no-interactive \
                     --no-system-changes && \
mv mozilla-unified moz-central

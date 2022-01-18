#!/bin/sh

echo "run: scp fromanavc.net:get_env.sh . && sh get_env.sh"
echo "logout and login to ensure profile changes are picked up."
echo "run: source ~/.profile && cd ~/mozilla/moz-central \\"
echo "     && ./mach vcs-setup --update \\"
echo "     && ./mach bootstrap \\"
echo "     && ./mach eslint --setup \\"
echo "     && switchconfig.sh deb"

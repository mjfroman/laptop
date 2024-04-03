#!/bin/sh

echo "run: scp fromanavc.net:get_env.sh . && sh get_env.sh"
echo "logout and login to ensure profile changes are picked up."
echo "run: source ~/.profile && cd ~/mozilla/moz-central \\"
echo "     && cp ~/.hgrc ~/hgrc-bak \\" # save the current .hgrc file
echo "     && ./mach vcs-setup \\" # answer yes to everything to install evolve, etc
echo "     && cat ~/hgrc-bak > ~/.hgrc && rm ~/hgrc-bak \\" # restore the .hgrc file
echo "     && ./mach --no-interactive bootstrap --application-choice=browser \\"
echo "     && ./mach eslint --setup \\"
echo "     && switchconfig.sh deb"

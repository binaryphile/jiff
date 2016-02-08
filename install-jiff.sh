#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

! [[ -d "${HOME}/.basher" ]] || exit 0
pushd "${HOME}" >/dev/null
echo "I will now fork the jiff repo to your github account and clone it to $HOME/jiff.  Github will prompt you for your password."
echo
read -e -p "Username: " username
read -e -p "OTP (if using 2FA): " otp
if [[ -n "${otp}" ]]; then
  curl -X POST -u "${username}" --header "X-Github-OTP: ${otp} " https://api.github.com/repos/binaryphile/jiff/forks
else
  curl -X POST -u "${username}" https://api.github.com/repos/binaryphile/jiff/forks
fi
sleep 5
git clone "git@github.com:${username}/jiff"
git clone --depth=1 git://github.com/basherpm/basher .basher
grep -q basher .bashrc || cat <<EOM >> .bashrc

export PATH="\${PATH}:\${HOME}/.basher/bin"
eval "\$(basher init -)"
EOM
cd .basher/libexec
sed -i -e 's|${bin_path}:${PATH}|${PATH}:${bin_path}|' basher
sed -i -e 's|$BASHER_ROOT/cellar/bin:$PATH|$PATH:$BASHER_ROOT/cellar/bin|' -e 's|$BASHER_ROOT/cellar/bin $PATH|$PATH $BASHER_ROOT/cellar/bin|' basher-init
popd >/dev/null
"${HOME}/.basher/bin/basher" install "${username}/jiff"
cat <<EOM

Note: If you are using bash as your shell, run "exec bash" to load jiff
onto your path.  Otherwise follow the basher instructions for loading
basher into your shell's environment then source those files or
re-login.

EOM

#!/usr/bin/env bash
# // ; '' PIPETHIS_AUTHOR Ted Lilley

set -o errexit
set -o nounset
set -o pipefail

! [[ -d "${HOME}/.basher" ]] || exit 0
pushd "${HOME}" >/dev/null
git clone --depth=1 git://github.com/basherpm/basher .basher
grep -q basher .bashrc || cat <<EOM >> .bashrc

export PATH="\${PATH}:\${HOME}/.basher/bin"
eval "\$(basher init -)"
EOM
cd .basher/libexec
sed -i -e 's|${bin_path}:${PATH}|${PATH}:${bin_path}|' basher
sed -i -e 's|$BASHER_ROOT/cellar/bin:$PATH|$PATH:$BASHER_ROOT/cellar/bin|' basher-init
popd >/dev/null
"${HOME}/.basher/bin/basher" install binaryphile/jiff
cat <<EOM

Note: Run "exec bash" to load jiff onto your path.

EOM

#! /bin/bash
set -euvxo pipefail
#(( ! UID ))
case $# in
  0) DIR="$PREFIX"    ;;
  1) DIR="$1/$PREFIX" ;;
  *) exit 1           ;;
esac
[[ -n "$1" ]]
[[ -d "$1" ]]

if [[ -d "$DIR/lib" ]] ; then
  # strip archives
  find "$DIR/lib"                      \
    -type f -name \*.a                 \
    -exec strip --strip-debug    {}    \;
  # strip libraries
  find "$DIR/lib"                      \
    -type f -name \*.so\*              \
    -exec strip --strip-unneeded {}    \;
fi
DIRS=()
for dir in "$DIR/"{bin,sbin,libexec} ; do
  [[ ! -d "$dir" ]] ||
  DIRS=("${DIRS[@]}" "$dir")
done
unset dir
# strip executables
find "${DIRS[@]}"                    \
  -type f                            \
  -exec strip --strip-all      {}    \;
unset DIRS

rm -rf "$DIR/share/"{info,man,doc}/*


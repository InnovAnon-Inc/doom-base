#! /bin/bash
set -euvxo pipefail
(( ! UID ))
case $# in
  0) DIR="$PREFIX" ;;
  1) DIR="$1"      ;;
  *) exit 1        ;;
esac
[[ -n "$1" ]]
[[ -d "$1" ]]

# strip archives
find "$DIR/lib"                      \
  -type f -name \*.a                 \
  -exec strip --strip-debug    {}    \;
# strip libraries
find "$DIR/lib"                      \
  -type f -name \*.so*               \
  -exec strip --strip-unneeded {}    \;
# strip executables
find "$DIR/"{bin,sbin,libexec}       \
  -type f                            \
  -exec strip --strip-all      {}    \;


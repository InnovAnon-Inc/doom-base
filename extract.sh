#! /bin/bash
set -euvxo pipefail
(( ! UID ))
(( ! $#  ))
sleep 31
cat       /tmp/*.txz  |
tar Jxf - -i -C /
rm -v     /tmp/*.txz
ldconfig


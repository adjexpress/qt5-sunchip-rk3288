#!/bin/bash

# LIBMALI_MIDGARD_LIB="libmali-midgard-t76x-r18p0-r1p0-gbm.so"
LIBMALI_MIDGARD_LIB="libmali-midgard-t76x-r14p0-r1p0.so"

LIBMALI_MIDGARD_LIB_SYMLINKS=("libMali.so" "libmali.so" "libmali.so.1"  "libEGL.so"  "libEGL.so.1" "libgbm.so" "libGLESv1_CM.so" "libGLESv1_CM.so.1"  "libGLESv2.so" "libGLESv2.so.2")


$(dirname "$0")/pkg_install.sh

# Install libMali:
# rsync $(dirname "$0")/libmali-rk-dev/usr/ /usr/

## Create symlinks
# for symlink in ${LIBMALI_MIDGARD_LIB_SYMLINKS[@]}; do
#         echo "linking $symlink :"
#         rm -rf /usr/lib/$symlink
#         rm -rf /usr/lib/arm-linux-gnueabihf/$symlink
#         ln -sf /usr/lib/arm-linux-gnueabihf/$LIBMALI_MIDGARD_LIB /usr/lib/arm-linux-gnueabihf/$symlink
#         echo "done"
# done

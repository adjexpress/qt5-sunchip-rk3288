#!/bin/bash
set -e

current=$(dirname "$0")
src=${2}
#"${1}/Src"
build="${1}/build"
sysroot="${1}/sysroot"
#cd ${1}
# make distclean
echo " "
echo "## try to clean previous build  (if exist & be git a repo ) "
echo "## PWD: " $PWD
echo "## Current dir: " $(dirname "$0")
rm -rf $build
mkdir -p $build
echo $current
cp -R $current/linux-rk3288-g++  $src/qtbase/mkspecs/devices/

cd $build
exec $src/configure \
-v \
-opensource \
-confirm-license \
-release \
-opengl es2 \
-opengles3 \
-eglfs \
-device linux-rk3288-g++ \
-device-option CROSS_COMPILE=${1}/compiler/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf-  \
-sysroot $sysroot \
-prefix /opt/qt5 \
-extprefix ${1}/qt5 \
-hostprefix ${1}/qt5 \
-make  libs \
-libudev \
-evdev \
-libinput \
-tslib \
-mtdev \
-gstreamer \
-gbm \
-kms \
-skip qtwebengine \
-skip qtwayland \
-skip qtwinextras \
-skip qtx11extras \
-nomake examples \
-nomake tests \
-no-compile-examples \
-no-xcb \
-no-gtk \
-no-use-gold-linker \
-no-pch \
-reduce-exports \
-optimize-size


# -static \
# -ltcg \
# -reduce-relocations \
# -no-gcc-sysroot \

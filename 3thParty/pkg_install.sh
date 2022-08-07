#!/bin/bash

# 
# echo "deb-src http://ports.ubuntu.com/ubuntu-ports/ bionic main restricted" >> /etc/apt/sources.list
# echo "deb-src http://ports.ubuntu.com/ubuntu-ports/ bionic-updates main restricted" >> /etc/apt/sources.list
# echo "deb-src http://ports.ubuntu.com/ubuntu-ports/ bionic universe" >> /etc/apt/sources.list
# echo "deb-src http://ports.ubuntu.com/ubuntu-ports/ bionic-updates universe" >> /etc/apt/sources.list
# echo "deb-src http://ports.ubuntu.com/ubuntu-ports/ bionic multiverse" >> /etc/apt/sources.list
# echo "deb-src http://ports.ubuntu.com/ubuntu-ports/ bionic-updates multiverse" >> /etc/apt/sources.list
# echo "deb-src http://ports.ubuntu.com/ubuntu-ports/ bionic-backports main restricted universe multiverse" >> /etc/apt/sources.list
# 
# echo "deb http://archive.canonical.com/ubuntu bionic partner" >> /etc/apt/sources.list
# echo "deb-src http://archive.canonical.com/ubuntu bionic partner" >> /etc/apt/sources.list
# 
# echo "deb-src http://ports.ubuntu.com/ubuntu-ports/ bionic-security main restricted" >> /etc/apt/sources.list
# echo "deb-src http://ports.ubuntu.com/ubuntu-ports/ bionic-security universe" >> /etc/apt/sources.list
# echo "deb-src http://ports.ubuntu.com/ubuntu-ports/ bionic-security multiverse" >> /etc/apt/sources.list
# 

echo "## Modify /etc/apt/sources.list"
echo " "
# echo "deb-src http://raspbian.raspberrypi.org/raspbian/ buster main contrib non-free rpi"  >> /etc/apt/sources.list
sed -i 's/#deb-src/deb-src/'  /etc/apt/sources.list

echo "## setting locales "
sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    echo 'LANG="en_US.UTF-8"'>/etc/default/locale && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

echo " "
echo " "
echo " "
echo "## update package DataBase"
echo " "
apt update && apt install -y --allow-change-held-packages aptitude rsync


# apt remove -y libgl1-mesa libegl1-mesa libgles2-mesa
# apt remove -y libgl1 libegl1 libgles2
echo " "
echo " "
echo " "
echo "## upgrade existing packages"
echo " "
aptitude -y purge
aptitude -y upgrade

echo " "
echo " "
echo " "
echo "## Install tools"
echo " "
aptitude build-dep -y libdrm
aptitude install -y tzdata  sudo apt-utils git fakeroot devscripts cmake vim dh-make dh-exec pkg-kde-tools device-tree-compiler bc cpio parted dosfstools mtools libssl-dev libclang-dev libc6-dev

#aptitude install -y qemu-user-static
#aptitude install -y binfmt-support

echo " "
echo " "
echo " "
echo "## Install Qt5 build dependencies"
echo " "

# Qt5 build dependencies
aptitude  build-dep -y libqt5gui5

echo " "
echo " "
echo " "
echo "## Install Qt5 Moduls build dependencies"
echo " "
aptitude install -y libudev-dev  libinput-dev libxcb-xinerama0-dev libxcb-xinerama0 libts-dev


aptitude install -y libgstreamer-plugins-bad1.0-dev
aptitude install -y libgstreamer-plugins-base1.0-dev
aptitude install -y libgstreamer1.0-dev
aptitude install -y libgstreamermm-1.0-dev
# aptitude install -y libqt5gstreamer-dev
aptitude install -y libxxf86dga-dev
aptitude install -y libunwind-dev
aptitude install -y libnetcdf-dev
aptitude install -y libasound2-dev
aptitude install -y libpulse-dev
aptitude install -y gstreamer1.0-alsa
aptitude install -y libopenal-dev
aptitude install -y gstreamer1.0-omx

aptitude install -y xserver-xorg-dev
aptitude install -y xf86dga*



echo " "
echo " "
echo " "
echo "## Installing offline rockchip library"
echo "## Installing librMali"
echo " "
# rockchip libMali: http://opensource.rock-chips.com/wiki_Graphics#MALI_GPU_driver
dpkg --force-overwrite --force-conflicts  -i  $(dirname "$0")/packages/armhf/libmali/*.deb

echo " "
echo " "
echo " "
echo "## Installing offline rockchip library"
echo "## Installing mpp"
echo " "
# rockchip mpp: http://opensource.rock-chips.com/wiki_Mpp
dpkg --force-overwrite --force-conflicts  -i  $(dirname "$0")/packages/armhf/mpp/*.deb

echo " "
echo " "
echo " "
echo "## Installing offline rockchip library"
echo "## Installing gstreamer"
echo " "
# rockchip optimized gstreamer
dpkg --force-overwrite --force-conflicts  -i  $(dirname "$0")/packages/armhf/gstreamer/*.deb

echo " "
echo " "
echo " "
echo "## Installing offline rockchip library"
echo "## Installing ffmpeg"
echo " "
# rockchip optimized ffmpeg
dpkg --force-overwrite --force-conflicts  -i  $(dirname "$0")/packages/armhf/ffmpeg/*.deb

echo " "
echo " "
echo " "
echo "## Installing offline rockchip library"
echo "## Installing rkisp-engine"
echo " "
#rockchip optimized rkisp-engine
dpkg --force-overwrite --force-conflicts  -i  $(dirname "$0")/packages/armhf/camera/*.deb


echo " "
echo " "
echo " "
echo "## Installing offline rockchip library"
echo "## Installing libDRM"
echo " "
# rockchip libdrm: http://opensource.rock-chips.com/wiki_Graphics#LibDRM
dpkg --force-overwrite --force-conflicts  -i  $(dirname "$0")/packages/armhf/libdrm/*.deb


echo " "
echo " "
echo " "
echo "## Installing offline rockchip library:"
echo "## Installing librga"
echo " "
echo " "
echo " "
# rockchip librga: https://github.com/rockchip-android/hardware-rockchip-librga
mkdir -p /usr/include/rga/
cp $(dirname "$0")/packages/armhf/rga/include/* /usr/include/rga/
cp $(dirname "$0")/packages/armhf/rga/lib/librga.so  /usr/lib/


echo " "
echo " "
echo " "
echo "## unify package config"
echo " "
# unify package config
cp -R /usr/lib/pkgconfig/* /usr/lib/arm-linux-gnueabihf/pkgconfig/


#echo "## fix missing package files"
# fix missing
aptitude update && aptitude install -y -f

mkdir -p /opt/qt5
chown -R ${1} /opt/qt5
chmod -R 755 /opt/qt5
# cp -R qt5-rk3399/  /opt
echo /opt/qt5 | tee /etc/ld.so.conf.d/qt5.conf

ldconfig

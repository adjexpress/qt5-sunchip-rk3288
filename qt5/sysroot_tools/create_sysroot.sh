#!/bin/bash
set -e

connection=${1}
basedir=${2}
USER=$(whoami)
sysroot="$basedir/sysroot"

# compilerLink="https://gitlab.com/rpdzkj2018/rk3288-linux/-/archive/master/rk3288-linux-master.tar.gz?path=prebuilts/gcc/linux-x86/arm/gcc-linaro-6.3.1-2017.05-x86_64_arm-linux-gnueabihf"
# compilerName="https://gitlab.com/rpdzkj2018/rk3288-linux/-/archive/master/rk3288-linux-master.tar.gz?path=prebuilts/gcc/linux-x86/arm/gcc-linaro-6.3.1-2017.05-x86_64_arm-linux-gnueabihf"

compilerLink="https://releases.linaro.org/components/toolchain/binaries/7.5-2019.12/arm-linux-gnueabihf/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf.tar.xz"
compilerName="gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf.tar.xz"

## making directories
mk_dirs(){

    echo "## create base dir"
    sudo mkdir -p $basedir
    echo "## change ownership"
    sudo chown -R $USER $basedir
    echo "## create sub dirs"
    mkdir -p $basedir/compiler $basedir/qt5
    echo "## create sysroot sub dir"
    mkdir -p $sysroot $sysroot/usr $sysroot/etc $sysroot/opt
}


## checking for compiler
chech_gcc(){

    echo "## checking for compiler"
    if [ ! -f "$basedir/compiler/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf-gcc" ];then
        echo ""
        echo "## compiler doen't exist"
        if [ ! -f gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf.tar.xz ];then
            echo ""
            echo "## downloading compiler  to $(dirname "$0")"
            wget https://releases.linaro.org/components/toolchain/binaries/7.5-2019.12/arm-linux-gnueabihf/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf.tar.xz
        else
            echo ""
            echo "## compiler archive exist"
        fi

        echo ""
        echo "extract Archive to $basedir/compiler"
        tar -xf gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf.tar.xz   --skip-old-files --directory=$basedir/compiler
    else
        echo "## compiler exist"
    fi

}


## syncing rootfs with sysroot
sync_rootfs(){
    touch  $sysroot/etc/ld.so.conf

    echo "## sync ${1} with sysroot"
    $(dirname "$0")/sync.sh ${1} $sysroot

    cat $sysroot/etc/ld.so.conf.d/* > $sysroot/etc/ld.so.conf

    echo "## check symbolic links for $sysroot "
    $(dirname "$0")/sysroot-relativelinks.py $sysroot
}


if [ -n ${1} ] && [ -d ${2} ]; then
    echo "## connection: " $connection
    echo "## dest:" ${2}
    echo "## user: $USER"
#     $basedir=${2}
    mk_dirs
    chech_gcc
    sync_rootfs $connection

    echo "## all Done "
else
    echo "## create_sysroot: you must run this script with rootfs as arg1 "
fi

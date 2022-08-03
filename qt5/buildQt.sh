#!/bin/bash

# rootPSW=''
# remoteUSER=''
# remoteADDRESS=''
# remotePSW=''
# connectString="$remoteUSER@$remoteADDRESS"

build="${2}/build"

if [ -n ${1} ] && [ -d ${2} ]; then
    echo "## creating Qt build env "

# #     echo "## connectString: "${1}
    echo "## PWD: " $PWD
    echo "## Current dir: " $(dirname "$0")
#
# #     echo $PWD'/'$(dirname "$0")


    echo "## creating sysroot ...."
    $(dirnsame "$0")/sysroot_tools/create_sysroot.sh ${1} ${2}
    echo "## creating sysroot done. "


    echo " "
    echo " "
    echo "## Config Qt source of cross compiling "
    echo " "
    echo "## Please copy qt-everywhere-src  into  $(dirname "$0")/Src "
    echo "## searching for Qt source "

    if [ -d "$(dirname "$0")/Src" ]; then

        $(dirname "$0")/cross_compile/cross_compile_config.sh  ${2} "$PWD/$(dirname "$0")/Src"
        # "$(dirname "$0")/Src" "$(dirname "$0")/$build"

        echo " "
        echo " "
        echo "## Config Qt finished "
        echo " "
        echo "## to view Config result open  $build/config.summary"
        echo " "
        echo " "
        echo "## try to build "
        echo "## Please copy arm-linux-gnueabihf compiler into ${2}/compiler/"
        echo "## searching for compiler "
        if [ -f "${2}/compiler/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf-gcc" ]; then
            echo "## compiler  found"
            echo "## current Directory: $(dirname "$0")"

            cd $build
            cores=`nproc`
            echo " "
            echo "## build starts "
            make -j$cores && make install
        else
            echo "## EE arm-linux-gnueabihf compiler is not in ${2}/compiler/"
            echo "## EE "
            echo "## EE canceling build "
        fi

    else
        echo "## EE qt source is not in $(dirname "$0")/Src "
    fi

else
    echo "## EE you must run this script with user@host as arg1 & Destination Directory as arg2 "
fi

#!/bin/bash

if [ -n ${1} ] && [ -d ${2} ]; then
    echo "## start syncing ..."
    rsync -avz ${1}:/lib ${2}
    sleep 1
    rsync -avz ${1}:/usr/lib ${2}/usr
    sleep 1
    rsync -avz ${1}:/usr/local/lib ${2}/usr
    sleep 1
    rsync -avz ${1}:/usr/include ${2}/usr
    sleep 1
    rsync -avz ${1}:/usr/local/include ${2}/usr
    sleep 1
    rsync -avz ${1}:/etc/ld.so.conf ${2}/etc/
    sleep 1
    rsync -avz ${1}:/etc/ld.so.conf.d ${2}/etc/

    echo "## finsh syncing."
else
    echo " you must run this script with user@remoteHost as arg1 & sysroot as arg2 "
fi

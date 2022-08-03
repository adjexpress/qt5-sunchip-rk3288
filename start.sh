#!/bin/bash

echo "## Preparing Environment ... "
USER=$(whoami)
dest="/opt/rk3288"
rootPSW=''
remoteUSER='linaro'
remoteADDRESS='192.168.1.33'
remotePSW='linaro'

if [ -n $remoteUSER ] && [ -n $remotePSW ]; then
    echo "## remote device information:"
    echo "remote device username:" $remoteUSER
    echo "remote device IP address:" $remoteADDRESS
else
    echo "## Need remote device information"
    read -p "remote device username:" remoteUSER
    read -p "remote device IP address:" remoteADDRESS
fi

connectString="$remoteUSER@$remoteADDRESS"

if [ ! -f "/home/$USER/.ssh/id_rsa" ];then
    ssh-keygen -b 2048 -t rsa -f /home/$USER/.ssh/id_rsa -q -N ""
else
    echo "## host ssh key exist"
fi

echo "## test ssh connection:"
sshpass -p "$remotePSW" ssh -q -o StrictHostKeyChecking=no $connectString exit

if [ $? -eq 0 ] ; then
    echo "## remote host is UP ... continiue ..."

    if ssh -i -o StrictHostKeyChecking=no $connectString "true"
    then
        echo "## ssh to remote device: OK"
    else
        echo "## ssh to remote device: Failed"
        echo "## Need to copy ID"
        echo "## Please enter remote device Password:"
        #read -sp "remote device Password:"
        sshpass -p "$remotePSW" ssh-copy-id $connectString
    fi

    echo "## sync 3thParty packages with remote host: "
    sleep 1
    rsync -avz 3thParty "$connectString:/home/$remoteUSER"
    echo "## execut scipts on remote host: "
    sleep 1
    ssh  $connectString  "sudo /home/$remoteUSER/3thParty/pkg_install.sh $remoteUSER"

else
    echo "## remote host is DOWM ... exiting."
    exit
fi


destdir=$dest

echo "## create destination dir"
sudo mkdir -p $destdir
echo "## change permission and ownership"
sudo chmod 755 $destdir
sudo chown -R $USER $destdir



echo " "
echo "## Start Qt building "
echo " "
echo "## PWD: " $PWD
echo "## Dest dir: " $destdir
$(dirname "$0")/qt5/buildQt.sh $connectString $destdir



echo " "
echo "## Install Qt5 to target:"
echo " "
echo " "

sshpass -p "$remotePSW" ssh -q -o StrictHostKeyChecking=no $connectString exit
sleep 1

if [ $? -eq 0 ] ; then
    echo "## remote host is UP ... continiue ..."
    echo " "
    echo "## sync $destdir/qt5/ with $connectString:/opt/qt5"
    echo " "
    rsync -avz $destdir/qt5 "$connectString:/opt"

else
    echo "## remote host is DOWM ... exiting."
    exit
fi

echo " "
echo "## Build and Install Qt finished "

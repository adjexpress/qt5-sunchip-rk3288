sudo docker run  --privileged=true  -it --rm -i -e USER_ID=$(id -u) -e GROUP_ID=$(id -g) -v /dev:/dev  -v /opt:/opt  -v $PWD/:/opt/workspace   workspace /bin/zsh

#!/bin/bash

USERID=$(id -u)

LOGSDIR=/tmp
# /home/centos/shellscript-logs/script-name-date.log
SCRIPT_NAME=$0
LOGFILE=$LOGSDIR/$SCRIPT_NAME-$DATE.log

r="\e[31m"
g="\e[32m"

VALIDATE() {
    if [ $1 -ne 0 ]; then
        echo -e "$2....$r FAILURE"
        exit 1
    else

        echo -e "$2....$g SUCCESS "
    fi
}

if [ $USERID -ne 0 ]; then

    echo " $r Error : Please run this script with root access"

    exit 1

fi

sudo yum install -y yum-utils

VALIDATE $? "updating the packages" >>$LOGFILE

sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
VALIDATE $? "add repo">>$LOGFILE

#Install Docker Engine, containerd, and Docker Compose:

sudo yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
VALIDATE $? "install docker">>$LOGFILE

#Start Docker.

sudo systemctl start docker
VALIDATE $? "start docker">>$LOGFILE



sudo systemctl enable docker
VALIDATE $? "enable docker">>$LOGFILE

# adding the centos as user in docker group

sudo usermod -aG docker centos
VALIDATE $? "adding the user to the docker group">>$LOGFILE

exit

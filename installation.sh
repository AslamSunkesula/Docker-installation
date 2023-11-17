#!/bin/bash


LOGSDIR=/tmp
# /home/centos/shellscript-logs/script-name-date.log
SCRIPT_NAME=$(basename "$0")
LOGFILE=$LOGSDIR/$SCRIPT_NAME-$DATE.log

#!/bin/bash
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

USERID=$(id -u)

echo -e "$Y This script runs on CentOS 8 $N"


VALIDATE() {
    if [ $1 -ne 0 ]; then
        echo -e "$2....$R FAILURE"
        exit 1
    else

        echo -e "$2....$G SUCCESS "
    fi
}

if [ $USERID -ne 0 ]; then

    echo " $R Error : Please run this script with root access$N"

    exit 1

fi

sudo yum install -y yum-utils

VALIDATE $? "updating the packages" 

sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo &&>>$LOGFILE
VALIDATE $? "add repo" 
#Install Docker Engine, containerd, and Docker Compose:

sudo yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin &&>>$LOGFILE
VALIDATE $? "Docker components are installed"
#Start Docker.

sudo systemctl start docker &&>>$LOGFILE
VALIDATE $? "docker started"


sudo systemctl enable docker &&>>$LOGFILE
VALIDATE $? "docker enabled"
# adding the centos as user in docker group

sudo usermod -aG docker centos &>>$LOGFILE
VALIDATE $? "adding the user to the docker group"

echo -e "$R Please logout and login again $N"
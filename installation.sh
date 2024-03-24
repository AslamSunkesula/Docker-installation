# #!/bin/bash


# LOGSDIR=/tmp
# # /home/centos/shellscript-logs/script-name-date.log
# SCRIPT_NAME=$(basename "$0")
# LOGFILE=$LOGSDIR/$SCRIPT_NAME-$DATE.log

# #!/bin/bash
# R="\e[31m"
# G="\e[32m"
# N="\e[0m"
# Y="\e[33m"

# USERID=$(id -u)

# echo -e "$Y This script runs on CentOS 8 $N"


# VALIDATE() {
#     if [ $1 -ne 0 ]; then
#         echo -e "$2....$R FAILURE"
#         exit 1
#     else

#         echo -e "$2....$G SUCCESS "
#     fi
# }

# if [ $USERID -ne 0 ]; then

#     echo " $R Error : Please run this script with root access$N"

#     exit 1

# fi

# sudo yum install -y yum-utils

# VALIDATE $? "updating the packages" 

# sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo &&>>$LOGFILE
# VALIDATE $? "add repo" 
# #Install Docker Engine, containerd, and Docker Compose:

# sudo yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin &&>>$LOGFILE
# VALIDATE $? "Docker components are installed"
# #Start Docker.

# sudo systemctl start docker &&>>$LOGFILE
# VALIDATE $? "docker started"


# sudo systemctl enable docker &&>>$LOGFILE
# VALIDATE $? "docker enabled"
# # adding the centos as user in docker group

# sudo usermod -aG docker centos &>>$LOGFILE
# VALIDATE $? "adding the user to the docker group"

# echo -e "$R Please logout and login again $N"


#!/bin/bash

# Define variables
LOGSDIR=/tmp
SCRIPT_NAME=$(basename "$0")
LOGFILE=$LOGSDIR/$SCRIPT_NAME-$(date +"%Y-%m-%d").log
DATE=$(date +"%Y-%m-%d")
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

# Function to validate command execution
VALIDATE() {
    if [ $1 -ne 0 ]; then
        echo -e "$2....$R FAILURE"
        exit 1
    else
        echo -e "$2....$G SUCCESS "
    fi
}

# Check if script is run with root access
if [ $EUID -ne 0 ]; then
    echo -e "$R Error: Please run this script with root access$N"
    exit 1
fi

# Check if the user is centos
if [ $(whoami) != "centos" ]; then
    echo -e "$R Error: Please run this script as the 'centos' user$N"
    exit 1
fi

# Install Docker dependencies
echo -e "$Y This script runs on CentOS 8 $N"
echo -e "$Y Installing Docker dependencies $N"
sudo yum install -y yum-utils &>> $LOGFILE
VALIDATE $? "Installing Docker dependencies"

# Add Docker repository
echo -e "$Y Adding Docker repository $N"
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo &>> $LOGFILE
VALIDATE $? "Adding Docker repository"

# Install Docker Engine, containerd, and Docker Compose
echo -e "$Y Installing Docker components $N"
sudo yum install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin &>> $LOGFILE
VALIDATE $? "Installing Docker components"

# Start Docker
echo -e "$Y Starting Docker $N"
sudo systemctl start docker &>> $LOGFILE
VALIDATE $? "Starting Docker"

# Enable Docker to start on boot
echo -e "$Y Enabling Docker to start on boot $N"
sudo systemctl enable docker &>> $LOGFILE
VALIDATE $? "Enabling Docker to start on boot"

# Add 'centos' user to the 'docker' group
echo -e "$Y Adding the 'centos' user to the 'docker' group $N"
sudo usermod -aG docker centos &>> $LOGFILE
VALIDATE $? "Adding the 'centos' user to the 'docker' group"

# Provide user instructions
echo -e "$R Please logout and login again $N"

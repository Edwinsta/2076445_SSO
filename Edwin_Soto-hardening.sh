#! /bin/bash
UNAME=$(uname | tr "[:upper:]" "[:lower:]")
if [ "$UNAME" == "linux" ]; then
    if [ -f /etc/lsb-release -o -d /etc/lsb-release.d ]; then
        sudo yum -y install lsb
        export DISTRO=$(lsb_release -i | cut -d: -f2 | sed s/'^\t'//)
    else
        export DISTRO=$(ls -d /etc/[A-Za-z]*[_-][rv]e[lr]* | grep -v "lsb" | cut -d'/' -f3 | cut -d'-' -f1 | cut -d'_' -f1)
    fi
else
    export DISTRO=$("Ubuntu")
fi
[ "$DISTRO" == "" ] && export DISTRO=$UNAME
unset UNAME
echo $DISTRO

if [ "$DISTRO" == "CentOS" ]; then

    if ! command -v man clamdtop &> /dev/null
    then
        sudo yum -y install clamav
    else
        sudo systemctl stop clamav-freshclam
        sudo yum -y remove clamav
        sudo yum -y install clamav
    fi
    sudo yum -y install epel-release
    sudo yum -y update
else
    sudo apt-get upgrade -y
    if ! command -v man clamdtop &> /dev/null
    then
        sudo apt-get install clamav -y
    else
        sudo systemctl stop clamav-freshclam
        sudo apt-get autoremove clamav -y
        sudo apt-get install clamav -y
    fi

fi

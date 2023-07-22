#!/bin/bash
# Author: Yevgeniy Goncharov, https://lab.sys-adm.in
# Show port statistic (list of listening ports of connections)

# Sys env / paths / etc
# -------------------------------------------------------------------------------------------\
PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
SCRIPT_PATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)

# Variables
# -------------------------------------------------------------------------------------------\
HOSTNAME=$(hostname)
# IP_ADDRESS=$(hostname -I | awk '{print $1}')

# Functions
# -------------------------------------------------------------------------------------------\
function check_root {
  if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root"
    exit 1
  fi
}

function check_linux_ip {
    IP_ADDRESS=$(hostname -I | awk '{print $1}')
}

function check_mac_ip {
    IP_ADDRESS=$(ipconfig getifaddr en0)
}

function check_os {
  if [ -f /etc/redhat-release ]; then
    OS="CentOS"
  elif [ -f /etc/debian_version ]; then
    OS="Debian"
  elif [ -f /etc/lsb-release ]; then
    OS="Ubuntu"
  elif [ "$(uname)" == "Darwin" ]; then
    OS="macOS"
  else
    echo "Looks like you aren't running this installer on CentOS, Ubuntu, Debian or macOS"
    exit 1
  fi
}

# Detct OS
# -------------------------------------------------------------------------------------------\
check_os

if [ "$OS" == "macOS" ]; then
    check_mac_ip
elif [ "$OS" == "CentOS" ]; then
  check_linux_ip
elif [ "$OS" == "Debian" ]; then
  check_linux_ip
elif [ "$OS" == "Ubuntu" ]; then
  check_linux_ip
else
  echo "Looks like you aren't running this installer on CentOS, Ubuntu, Debian or macOS"
  exit 1
fi

echo -e "Host name: $HOSTNAME (OS: $OS, IP: $IP_ADDRESS)"
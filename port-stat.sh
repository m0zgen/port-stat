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

# Get arguments
# -------------------------------------------------------------------------------------------\
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    -h|--help)
      echo -e "Usage: $0 [options]"
      echo -e "Options:"
      echo -e "  -h, --help\t\t\tShow brief help"
      echo -e "  -p, --port\t\t\tShow port statistic"
      echo -e "  -s, --state\t\t\tShow port state"
      echo -e "  -a, --app\t\t\tShow stat for defined app"
      echo -e "Default:"
      echo -e "  - Shows all listen ports"
      exit 0
      ;;
    -p|--port)
      PORT="$2"
      shift
      ;;
    -s|--state)
      STATE="$2"
      shift
      ;;
    -a|--app)
      ALL="$2"
      shift
      ;;
    *)
      echo -e "Unknown option: $1"
      exit 1
      ;;
  esac
  shift
done

# Functions
# -------------------------------------------------------------------------------------------\

# Function check netstat exists
function check_netstat_exists {
  if ! [ -x "$(command -v netstat)" ]; then
    return 1
  else
    return 0
  fi
}

# Function check lsof exists and return true or false
function check_lsof_exists {
  if ! [ -x "$(command -v lsof)" ]; then
    return 1
  else
    return 0
  fi
}

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
    check_linux_ip
  elif [ -f /etc/debian_version ]; then
    OS="Debian"
    check_linux_ip
  elif [ -f /etc/lsb-release ]; then
    OS="Ubuntu"
    check_linux_ip
  elif [ "$(uname)" == "Darwin" ]; then
    OS="macOS"
    check_mac_ip
  else
    echo "Looks like you aren't running this installer on CentOS, Ubuntu, Debian or macOS"
    exit 1
  fi
}

function check_port_state {
    lsof -iTCP -sTCP:LISTEN -n -P
}

function show_all_listen_ports {
    # lsof -i -n -P
    lsof -i -n -P | egrep 'COMMAND|ESTABLISHED|LISTEN|UDP|TCP'
}

function check_net_utils {
  if check_netstat_exists; then
    echo -e 'NETSTAT Exists'
    NET_TOOL='netstat'
  elif check_lsof_exists; then
    echo -e 'LSOF Exist'  
    NET_TOOL='lsof'
  else
    echo -e 'NETSTAT or LSOF not found. Exiting...'
    exit 1
  fi
}

# lsof chow UDP ports
# lsof -iUDP -sUDP:LISTEN -n -P

# Detct OS
# -------------------------------------------------------------------------------------------\
check_os

echo -e "Host name: $HOSTNAME (OS: $OS, IP: $IP_ADDRESS)\n"

# Check net utils
check_net_utils

# show_all_listen_ports




#!/usr/bin/env bash
# autostart.sh
#
# Enables/Disables l337 to start on boot.
# Uses systemd, requires root privileges to copy file and run systemd commands
#
# Usage: ./autostart.sh [on|off]
#

shout() { echo "$0: $*" >&2; }
barf() { shout "$*"; exit 100; }
safe() { "$@" || barf "ERROR: $*"; }

# Script working directory
CWD="$( cd "$(dirname "$0")" ; pwd )"

# Directory vars
CONFIG="$CWD/config"

usage (){
  echo -e "Usage: ${0##*/} [on|off]"
  exit 111
}

# Enable l337 to start on boot
on(){
    safe sed -i '8s|.*| ExecStart='"$CWD"'/l337.sh run|' "$CONFIG"/l337.service
    safe cp -v "$CONFIG"/l337.service /lib/systemd/system/l337.service
    safe systemctl daemon-reload
    safe systemctl enable l337.service
    echo "l337 enabled on boot"
    echo "Run 'systemctl start l337' to start, or reboot"
}

# Disable l337 from starting on boot
off(){
    safe systemctl disable l337.service
    safe systemctl daemon-reload
    echo "l337 disabled on boot."
}

# Arg checks
[ $# -lt 0 ] && usage
[ $# -gt 1 ] && usage

case "$1" in
      on) on
          ;;
     off) off
          ;;
       *) usage
          ;;
esac


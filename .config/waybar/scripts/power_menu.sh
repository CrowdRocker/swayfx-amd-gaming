#!/bin/bash
chosen=$(printf "Lock\nLogout\nShutdown\nReboot\nSuspend" | rofi -dmenu -i -p "Power Menu" -lines 5)
case "$chosen" in
  Lock) swaylock -f --effect-blur 7x5 ;;
  Logout) swaymsg exit ;;
  Shutdown) systemctl poweroff ;;
  Reboot) systemctl reboot ;;
  Suspend) systemctl suspend ;;
esac
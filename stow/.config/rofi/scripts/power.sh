#!/usr/bin/env bash

if [ $# -gt 0 ]; then
    command="$@"
    case $command in
        "Shutdown") systemctl poweroff ;;
        "Reboot") systemctl reboot ;;
        "Logout") command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit ;;
        "Sleep") systemctl sleep ;;
    esac
    exit 0
fi

echo -e "Shutdown\n\0icon\x1fshutdown" # TODO: fix icon
echo -e "Reboot\n\0icon\x1freboot" # TODO: fix icon
echo -e "Logout\n\0icon\x1flogout" # TODO: fix icon
echo -e "Sleep\n\0icon\x1fsleep" # TODO: fix icon
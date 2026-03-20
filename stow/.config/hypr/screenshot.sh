#!/usr/bin/env bash

FOLDER=~/images/screenshots
FILENAME=$(date +"%d-%m-%Y_%H:%M:%S")
if [ $1 == "display" ]; then
    FILE="$FOLDER/$FILENAME.display.png"
else
    FILE="$FOLDER/$FILENAME.png"
fi

if [ $1 == "display" ]; then
    GREP="$(hyprctl activeworkspace | grep -o "monitor [a-zA-Z0-9\-]\+:")" # Had to extract bc of bash
    OUTPUT=${GREP:8:-1}
    grim -o $OUTPUT $FILE
else
    grim -g "$(slurp)" $FILE
fi

wl-copy <$FILE

ACTION=$(notify-send -i "$FILE" -w -t 10000 -A "folder=Open folder" -A "open=Open file" "Screenshotted" "$FILE")
case "$ACTION" in
    "folder") xdg-open $FOLDER ;;
    "open") xdg-open $FILE ;;
esac

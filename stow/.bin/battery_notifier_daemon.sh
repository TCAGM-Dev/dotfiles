#!/usr/bin/env bash
# Send notification when discharging battery reaches a certain threshold
# Requires: a notification server

LOW_THRESHOLD=15
BATTERY=/sys/class/power_supply/BAT1
PREV_CAPACITY_FILE="/tmp/battery_notifier_previous_capacity"

if [ ! -d "$BATTERY" ]; then
    exit 1 # Stop if on a batteryless device
fi

while [ true ]; do
    STATUS=$(<$BATTERY/status)
    CAPACITY=$(<$BATTERY/capacity)
    PREV_CAPACITY=$(<$PREV_CAPACITY_FILE)
    
    echo "$CAPACITY" > $PREV_CAPACITY_FILE
    
    echo "$STATUS $CAPACITY"
    
    if [ "$STATUS" == "Discharging" ] && [ $CAPACITY == $LOW_THRESHOLD ] && [ $CAPACITY != $PREV_CAPACITY ]; then
        notify-send -u critical "My battery is at $CAPACITY%" "Please charge me soon"
    fi
    sleep 10
done

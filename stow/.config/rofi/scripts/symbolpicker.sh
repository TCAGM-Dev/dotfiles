#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

declare -A CATEGORIES
CATEGORIES=(
    ["Emoji"]="$SCRIPT_DIR/emojis.txt"
    ["Nerd Symbol"]="$SCRIPT_DIR/nerd_symbols.txt"
)

CATEGORY="$@"

if [ $# -eq 0 ] || [ ! -v CATEGORIES["$CATEGORY"] ]; then
    for categoryName in "${!CATEGORIES[@]}"; do
        echo -e "$categoryName\0display\x1f$categoryName picker"
    done
    exit 0
fi

INPUT_FILE=${CATEGORIES[$CATEGORY]}
COMMENT_PREFIX="#"

INPUT=$(cat "$INPUT_FILE")
declare -A SYMBOLS
while IFS= read -r line; do # Loop through lines
    if [ -z "$line" ]; then continue; fi # Skip empty lines
    #if [[ $line == \#* ]]; then continue; fi # Skip commented lines # FIXME: for some reason this check is testing if the line *contains* the command prefix instead of if it *starts with* it
    IFS="," read -ra parts <<< $line # Split line into parts
    SYMBOLS[${parts[0]}]=${parts[1]}
done <<< "$INPUT"

openMenu() {
    local choice=$(for symbol in "${!SYMBOLS[@]}"; do echo -e "$symbol\0display\x1f$symbol ${SYMBOLS[$symbol]}\x1fmeta\x1f${SYMBOLS[$symbol]}"; done | rofi -i -dmenu)
    wl-copy "$choice"
    notify-send "Copied \"$choice\""
}

coproc ( openMenu  > /dev/null  2>&1 )
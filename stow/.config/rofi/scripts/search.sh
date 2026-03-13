#!/usr/bin/env bash

declare -A URLS
URLS=(
    ["DuckDuckGo"]="https://duckduckgo.com/?q="
    ["Ecosia"]="https://ecosia.org/search?q="
    ["Google"]="https://google.com/search?q="
    ["Bing"]="https://bing.com/search?q="
)
declare -A ICONS
ICONS=(
    ["DuckDuckGo"]="search" # TODO: fix
    ["Ecosia"]="search" # TODO: fix
    ["Google"]="search" # TODO: fix
    ["Bing"]="search" # TODO: fix
)

queryFromKey() {
    sleep # Prevent race condition
    local key="$@"
    local query=$(rofi -dmenu -p "query")
    if [ ${#$query} -eq 0 ]; then
        return
    fi
    local url=${URLS[$key]}$query
    xdg-open $url
}

if [ $# -gt 0 ]; then
    key="$@"
    #notify-send "$key"
    if [ -v URLS[$key] ]; then
        coproc ( queryFromKey $key >/dev/null 2>&1 )
    fi
    exit 0
fi

for key in "${!URLS[@]}"; do
    echo -en "$key\n"
    if [ -v ICONS[$key] ]; then
        echo -en "\0icon\x1f"
        echo ${ICONS[$key]}
        echo -en "\n"
    fi
done
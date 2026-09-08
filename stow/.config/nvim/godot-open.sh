#!/usr/bin/env bash

# TODO: Fix being opened twice by Godot for some reason when clicking on output errors

# Usage:
#
# Open Godot
# Editor > Editor Settings > Text Editor > External
# Make sure "Advanced Settings" (top-right) is enabled
#
# Check "Use External Editor"
# Set "Exec Path" to this script (e.g. "/home/USER/.config/nvim/godot-open.sh")
# Set "Exec Flags" to "{file} {line} {col}"

# get args
argProject=$PWD
argFile=$1
argLine=$2
argColumn=$3

# generate socket
hash=$(md5sum <<<$argProject)
socket="/tmp/nvim-godot.$hash.sock"

if [[ ! -S $socket ]]; then
	kitty -- nvim --listen "$socket" $argFile "+call cursor($argLine,$argColumn)" &
else
	nvim --server "$socket" --remote-send ":e $argFile<CR>:call cursor($argLine,$argColumn)<CR>:<Esc>"
fi
#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

pacman -S stow
cd $SCRIPT_DIR/stow && stow --target="$HOME" . # Link dotfiles

pacman -S - < $SCRIPT_DIR/pkglist.txt # Install packages
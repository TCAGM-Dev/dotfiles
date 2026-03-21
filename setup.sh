#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

pacman -S stow
cd $SCRIPT_DIR/stow && stow --target="$HOME" . # Link dotfiles

pacman -S - < $SCRIPT_DIR/pkglist.txt # Install packages

ln -s /usr/bin/kitty /usr/bin/xdg-terminal-exec # Make Kitty the XDG default terminal (fixes thunar "open with" terminal apps)

# Mime defaults
xdg-mime default sxiv.desktop image/jpeg image/png image/bmp image/svg+xml
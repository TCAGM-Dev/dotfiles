# Dotfiles
The content of this repository are the dotfiles that I use in my personal Arch install.

## Installation
This repository includes a setup script that can be used to quickly install it.
Do note that this script leaves the directory that you clone the repository into intact, which might not be ideal for people who aren't - well, *me*. There currently is not an easy script to *just* install the setup, so this will need to be done manually. 

First, make sure you have `git` installed:
```bash
which git || sudo pacman -S git
```

Clone the repository:
```bash
git clone https://github.com/TCAGM-Dev/dotfiles.git ~/dot
cd ~/dot
```

And run the script:
```bash
sudo ~/dot/setup.sh
```

After executing these steps, the setup should be installed and active when you log into Hyprland.
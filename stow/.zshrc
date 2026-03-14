# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/im/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

source /usr/share/nvm/init-nvm.sh

# Default prompt
PS1="%F{#888888}[%f%n@%m %B%1~%b%F{#888888}]%f "

# Aliases
alias neofetch=fastfetch
alias detach="f(){\${@:1} </dev/null &>/dev/null &;disown;};f"
alias pm=pacman
spm(){sudo pacman $@}
yeet(){git push}
yoink(){git pull}
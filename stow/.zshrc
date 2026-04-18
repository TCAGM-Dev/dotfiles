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

# Node Version Manager
source /usr/share/nvm/init-nvm.sh

# User bin folder
PATH=$PATH:$HOME/.bin

# Default prompt
PS1="%F{#888888}[%f%n@%m %B%1~%b%F{#888888}]%f "

# Aliases
if [[ $TERM == xterm-kitty ]]; then
    alias ssh="kitten ssh"
    alias icat="kitten icat"
fi

alias pm=pacman
alias spm="sudo pacman"
detach(){${@:1} </dev/null &>/dev/null &;disown}
restart(){killall ${@:1}; for v in ${@:1}; do detach $v; done}
which "git" &>/dev/null && {
    alias yeet="git push"
    alias yoink="git pull"
}
which "fc-list" &>/dev/null && alias fonts=fc-list
which "sqlite3" &>/dev/null && alias sqlite=sqlite3
which "fastfetch" &>/dev/null && alias neofetch=fastfetch
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
if [[ $TERM == xterm-kitty ]]; then ssh(){kitten ssh $@}; fi

alias pm=pacman
spm(){sudo pacman $@}
detach(){${@:1} </dev/null &>/dev/null &;disown}
restart(){killall ${@:1}; for v in ${@:1}; do detach $v; done}
yeet(){git push}
yoink(){git pull}
alias fonts=fc-list
alias sqlite=sqlite3
alias neofetch=fastfetch
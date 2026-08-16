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

# uv
which "uv" &>/dev/null && PATH=$PATH:$HOME/.local/bin

# Assign $SSH_AUTH_SOCK, fixes some SSH-related issues
[[ -z $SSH_AUTH_SOCK ]] && for s in $XDG_RUNTIME_DIR/gcr/ssh; do
	[[ -S $s ]] && export SSH_AUTH_SOCK=$s && break
done

prevCwd=$PWD
chpwd() {
	[ $prevCwd = $PWD ] && return # Ignore unnecessary calls

	# Python venv
	[ -d $prevCwd/.venv ] && which "deactivate" &>/dev/null && deactivate
	[ -d $PWD/.venv ] && source "$PWD/.venv/bin/activate"

	prevCwd=$PWD
}
chpwd_functions+=chpwd
chpwd

# Yazi integration
which "yazi" &>/dev/null && {
	function yazi() {
		local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
		command yazi "$@" --cwd-file="$tmp"
		IFS= read -r -d '' cwd < "$tmp"
		[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && cd -- "$cwd"
		command rm -f -- "$tmp"
	}
	alias y=yazi
}

# User bin folder
PATH=$PATH:$HOME/.bin

# Default prompt
PS1="%F{#888888}[%f%n@%m %B%1~%b%F{#888888}]%f "

# Deduplicate history for faster navigation
setopt hist_ignore_all_dups

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
alias ls="ls -Ah --color=always"
which "docker-compose" &>/dev/null && alias dc="docker-compose"

which "nvim" &>/dev/null && which "vim" &>/dev/null || alias vim=nvim
which "vim" &>/dev/null && which "vi" &>/dev/null || alias vi=nvim

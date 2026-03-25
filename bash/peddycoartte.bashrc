# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
		if [ -f "$rc" ]; then
			. "$rc"
		fi
	done
fi

unset rc
alias rockrel='cat /etc/rocky-release'
alias cls='clear'
alias h='history'

alias ll='ls -lh --color=auto'
alias gss='git status $@'
alias gcm='git commit -m'
alias reloadbash='source ~/.bashrc'

alias rmd='rm -rfv'

export PATH=/usr/local/cuda/bin:$PATH

export PATH=${HOME}/peddycoartte/Applications/clion-2025.3.3/bin:$PATH
export PATH=${HOME}/peddycoartte/Applications/Obsidian:$PATH

. ${HOME}/Development/scripts/peddycoartte/scripts/env/prompt_env.sh



# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Completion & globbing
shopt -s direxpand        # your fix - expand $VARS on tab completion
shopt -s globstar         # enables ** to match recursively (e.g. ls **/*.cpp)
shopt -s extglob          # extended patterns: !(*.o), +(foo|bar), etc.
shopt -s nullglob         # unmatched globs expand to nothing instead of erroring

# Navigation
shopt -s cdspell          # auto-corrects minor typos in cd (cd Doucments -> Documents)
shopt -s autocd           # type a directory name alone to cd into it
shopt -s cdable_vars      # cd into a variable holding a path without the $

# History
shopt -s histappend       # append to history file instead of overwriting on exit
shopt -s cmdhist          # save multi-line commands as a single history entry
shopt -s lithist          # preserve newlines in multi-line history entries

# Misc
shopt -s checkwinsize     # update $LINES/$COLUMNS after each command (terminal resize)
shopt -s checkjobs        # warn about running/stopped jobs before shell exit

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
export PATH=${HOME}/peddycoartte/bin:$PATH

. ${HOME}/Development/scripts/peddycoartte/scripts/env/prompt_env.sh



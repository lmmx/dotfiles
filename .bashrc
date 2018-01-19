#!/usr/bin/env bash

if command -v tmux>/dev/null; then
	if [ ! -z "$PS1" ]; then 
		[[ ! $TERM =~ screen ]] && [ -z $TMUX ] && exec tmux
	fi
fi

source ~/dotfiles/bashrc/bashrc_exports
source ~/dotfiles/bashrc/bashrc_functions
source ~/dotfiles/bashrc/bashrc_movement
for conf_bashrc in ~/dotfiles/bashrc/confidential/bashrc_*; do source $conf_bashrc; done

eval "$(hub alias -s)"

#alias bib='/home/louis/.local/bin/bib'
if [[ -d ~/root/ ]]; then
	# this was a pain to install so don't mess with it, CERN software see devnotes
	source /home/louis/root/bin/thisroot.sh
fi

# Should probably update this (if I'm using TeX templates again)
alias textemplate="vim /home/louis/R/x86_64-pc-linux-gnu-library/3.1/rmarkdown/rmd/latex/default.tex"

alias mntace='sudo mount -o ro /dev/sda4'

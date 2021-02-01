#!/usr/bin/env bash

if command -v tmux>/dev/null; then
	if [ ! -z "$PS1" ]; then 
		[[ ! $TERM =~ screen ]] && [ -z $TMUX ] && exec tmux
	fi
fi

source ~/dotfiles/bashrc/bashrc_exports
source ~/dotfiles/bashrc/bashrc_functions
source ~/dotfiles/bashrc/bashrc_movement
source ~/.bash_completion.d/python-argcomplete
#for conf_bashrc in ~/dotfiles/bashrc/confidential/bashrc_*; do source $conf_bashrc; done

eval "$(hub alias -s)"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/louis/miniconda/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/louis/miniconda/etc/profile.d/conda.sh" ]; then
        . "/home/louis/miniconda/etc/profile.d/conda.sh"
    else
        export PATH="/home/louis/miniconda/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

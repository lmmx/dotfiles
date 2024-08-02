if command -v tmux>/dev/null; then
  if [ ! -z "$PS1" ]; then
    [[ ! $TERM =~ screen ]] && [ -z $TMUX ] && exec tmux
  fi
fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/louis/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/louis/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/louis/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/louis/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

export PATH="$HOME/miniconda3/bin:$PATH"
export PATH="$HOME/miniconda3/bin:$PATH"

source $HOME/dotfiles/bashrc/bashrc_functions
source $HOME/dotfiles/bashrc/bashrc_functions_git

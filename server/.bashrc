# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions

# Load tmux

if command -v tmux>/dev/null; then
        if [ ! -z "$PS1" ]; then
                [ -z $TMUX ] && tmux
        fi
fi

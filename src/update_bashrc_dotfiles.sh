#!/usr/bin/env bash

DOTFILE_REPO=/gits/dotfiles/ # NB always trailing forward slash
USER_DIR_NAME='dotfiles'

cp ~/.bashrc $DOTFILE_REPO'.bashrc'
cp ~/$USER_DIR_NAME/bashrc/bashrc_* $DOTFILE_REPO'bashrc/'

cd $DOTFILE_REPO
#git pull
#DIFF_MSG=$(diff -q ./bashrc/ ~/$USER_DIR_NAME/bashrc/ | sed '/Only in/d' | tr '\n' ';')
#python -c "print(len('$DIFF_MSG'))"

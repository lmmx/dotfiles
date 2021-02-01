" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

set textwidth=100
autocmd FileType python setlocal textwidth=88

" https://stackoverflow.com/a/1413352/2668831
function SetShellOptions()
  setlocal shiftwidth=2
  setlocal expandtab
  setlocal tabstop=2
endfunction

autocmd FileType sh,bash call SetShellOptions()

execute pathogen#infect()
syntax on
filetype plugin indent on

" via https://unix.stackexchange.com/a/141104/89254
set foldmethod=indent   
set foldnestmax=10
set nofoldenable
set foldlevel=2

" Make sure you use single quotes
" Shorthand notation; fetches https://github.com/ambv/black
Plug 'ambv/black'
" Plug 'jmckiern/vim-shoot', { 'do': '\"./install.py\" geckodriver' }
Plug 'lmmx/vim-shoot', { 'do': '\"./install.py\" geckodriver' }

" Initialize plugin system
call plug#end()

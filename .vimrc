autocmd BufRead,BufNewFile *.[R|r]md set filetype=md
execute pathogen#infect()
syntax on
filetype plugin indent on

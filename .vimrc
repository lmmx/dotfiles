set textwidth=100
autocmd FileType python setlocal textwidth=88
autocmd FileType javascript setlocal shiftwidth=4 tabstop=4 autoindent expandtab

" https://stackoverflow.com/a/1413352/2668831
function SetShellOptions()
  setlocal shiftwidth=2
  setlocal expandtab
  setlocal tabstop=2
endfunction

set viminfo='100,<1000,s200,h

autocmd FileType sh,bash call SetShellOptions()

execute pathogen#infect()
syntax on
filetype plugin indent on

" Set this so that `:term` will open the terminal pane below
set splitbelow
" Set this so that `:vert term` will open the terminal pane on RHS
set splitright

" via https://unix.stackexchange.com/a/141104/89254
set foldmethod=indent   
set foldnestmax=10
set nofoldenable
set foldlevel=2

" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Plug 'jmckiern/vim-shoot', { 'do': '\"./install.py\" geckodriver' }
" Plug 'lmmx/vim-shoot', { 'do': '\"./install.py\" geckodriver' }

" Make sure you use single quotes
" Shorthand notation; fetches https://github.com/ambv/black
" Plug 'ambv/black'
" Plug 'andreypopp/asyncomplete-ale.vim'

Plug 'skywind3000/asyncrun.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

" Initialize plugin system
call plug#end()

" LSP for asyncomplete.vim
" https://github.com/prabirshrestha/asyncomplete.vim
" if executable('pylsp')
"     " pip install python-lsp-server
"     au User lsp_setup call lsp#register_server({
"         \ 'name': 'pylsp',
"         \ 'cmd': {server_info->['pylsp']},
"         \ 'allowlist': ['python'],
"         \ })
" endif

let g:lsp_format_sync_timeout = 1000

autocmd! BufWritePre *.py,*.md call PreserveCursorPos()
function! PreserveCursorPos()
  let l:cursor_pos = getpos(".")

  " This version saves on `:w` or on `:x` (and double writes if you use `:LspRename`! Avoid this)
  " autocmd! BufWritePre *.py,*.md call execute(['LspDocumentFormatSync', 'LspCodeActionSync source.organizeImports'])
  " This version saves on `:w` only (so to avoid formatting you can `:x`)
  " autocmd! BufWritePre *.py call execute('LspDocumentFormatSync')
  call execute(['LspDocumentFormatSync', 'LspCodeActionSync source.organizeImports'])

  call setpos('.', l:cursor_pos)
endfunction

" See https://chat.openai.com/c/a93080aa-35dc-412f-b7ae-9758b9ef5c8c
" function! ToggleUnsafeFixesAndRunCodeAction()
"     " Step 1: Update the LSP client configuration to enable --unsafe-fixes
"     " This is highly dependent on your LSP client and might not be straightforward
"     " For example, in coc.nvim, you might use CocConfig or a similar command
" 
"     " Step 2: Run the LspCodeActionSync with the specific action
"     execute 'LspCodeActionSync source.fixAll'
" 
"     " Step 3: Revert the LSP client configuration to disable --unsafe-fixes
"     " Again, this depends on your LSP client and its capabilities
" endfunction
" 
" " Optional: Map this function to a keybinding for convenience
" nnoremap <your_keybinding> :call ToggleUnsafeFixesAndRunCodeAction()<CR>


" Tab completion for asyncomplete.vim
" https://github.com/prabirshrestha/asyncomplete.vim
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"

" Tone down the visual distraction of the 'sign gutter' from LSP linters
let g:lsp_diagnostics_enabled = 0
let g:lsp_document_highlight_enabled = 0

let g:lsp_settings_filetype_python = ['ruff-lsp', 'pyright-langserver']

" Configure the Pyright and Ruff LSP servers
" (the Ruff LSP config is a no-op (incorrect syntax) and the pylsp server is disabled)
" https://github.com/mattn/vim-lsp-settings/issues/698
" https://discord.com/channels/1039017663004942429/1060247592765759518/1185231367617921124
" https://github.com/astral-sh/ruff-lsp#settings
let g:lsp_settings = {
\   'ruff-lsp': {
\     'disabled': v:false,
\     'initialization_options': {
\       'globalSettings': {
\         'lint': {
\           'args': ['--unsafe-fixes']
\         }
\       }
\     }
\   },
\   'pyright-langserver': {
\     'disabled': v:false,
\     'workspace_config': {
\       'python': {
\         'analysis': {
\           'useLibraryCodeForTypes': v:true,
\         }
\       }
\     }
\   },
\   'pylsp': {
\     'disabled': v:true,
\     'workspace_config': {
\       'pylsp': {
\         'plugins': {
\           'rope': {
\             'python_path': '/home/louis/miniconda3/bin/python',
\           },
\           'rope_autoimport': {
\             'enabled': v:true,
\           }
\         }
\       }
\     }
\   },
\}

" " Uncomment the following to configure autoimport
" \             'completions': {
" \               'enabled': v:true
" \             },
" \             'code_actions': {
" \               'enabled': v:true
" \             }
"
" Set this variable to 1 to fix files when you save them.
let g:ale_fix_on_save = 1

" Tone down the visual distraction of the 'sign gutter' from ALE linters
highlight clear ALEErrorSign
highlight clear ALEWarningSign
" Disable highlighting on code from any linters
let g:ale_set_highlights = 0

" Only run linters named in ale_linters settings.
let g:ale_linters_explicit = 1

" let g:ale_linters_ignore = ["flake8", "mypy", "pylint", "pyright"]

let g:asyncrun_save = 1

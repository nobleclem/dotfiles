set backspace=2
set shiftwidth=4
set softtabstop=4
set tabstop=4

set autoindent
set expandtab
set ruler

set nottyfast

set term=ansi

" no search highlight
set nohlsearch

set viminfo='20,<200,s10,h

set pastetoggle=<F5>

" disable autocommenting
au FileType * set formatoptions-=r

syntax on
set background=dark
colorscheme desert

" treat files as php files
au BufRead,BufNewFile *.tpl set filetype=php
au BufRead,BufNewFile *.module set filetype=php
au BufRead,BufNewFile *.install set filetype=php

" treat files as javascript files
au BufRead,BufNewFile *.json set filetype=javascript

au VimEnter * command Cleanup :%s#\(\s\+\|\r\+\)$##

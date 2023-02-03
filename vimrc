set backspace=2
set shiftwidth=4
set softtabstop=4
set tabstop=4

set scrolloff=4  " Keep 4 lines above and below the cursor

set autoindent
set expandtab
set ruler

set nottyfast

set term=ansi

set title
set titlestring=%t%(\ %M%)%(\ (%{expand(\"%:~:.:h\")})%)%(\ %a%)

" no search highlight
set nohlsearch

" set viminfo='20,<200,s10,h
set viminfo='20,<1000,s1000,h

set pastetoggle=<F5>

" disable autocommenting
au FileType * set formatoptions-=r

syntax on
set background=dark
colorscheme desert
" fix syntax highlighting bug: https://vim.fandom.com/wiki/Fix_syntax_highlighting
autocmd BufEnter * :syntax sync fromstart

" treat files as php files
au BufRead,BufNewFile *.tpl set filetype=php
au BufRead,BufNewFile *.module set filetype=php
au BufRead,BufNewFile *.install set filetype=php

" treat files as javascript files
au BufRead,BufNewFile *.json set filetype=javascript

" custom commands
au VimEnter * command Cleanup :%s#\(\s\+\|\r\+\)$##
au VimEnter *.php command WinLineEnds :%s/\r//g

" jump to the last position when reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Commenting blocks of code.
autocmd FileType c,cpp,java,scala,php let b:comment_leader = '// '
autocmd FileType sh,ruby,python   let b:comment_leader = '# '
autocmd FileType conf,fstab       let b:comment_leader = '# '
autocmd FileType tex              let b:comment_leader = '% '
autocmd FileType mail             let b:comment_leader = '> '
autocmd FileType vim              let b:comment_leader = '" '
noremap <silent> ,cc :<C-B>silent <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:nohlsearch<CR>
noremap <silent> ,cu :<C-B>silent <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:nohlsearch<CR>

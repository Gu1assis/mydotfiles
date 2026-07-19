set nocompatible
set relativenumber
set tabstop=2 shiftwidth=2 expandtab
syntax on
set hlsearch
set t_Co=256

" Enhanced mode to commandline autocompletion
set wildmenu    

" Move current line up or down using Alt + j/k
execute "set <A-j>=\<Esc>j"
execute "set <A-k>=\<Esc>k"
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
" Move visually selected blocks up or down using Alt + j/k
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

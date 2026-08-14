" Keymaps
let mapleader = ' '

nnoremap <Leader>e :Exp<CR>
nnoremap <Leader>q :q<CR>
" Opts
set relativenumber
set nocompatible
syntax enable
set tabstop=2 shiftwidth=2 expandtab
colorscheme desert
set hlsearch
set t_Co=256

" Make the main editor background transparent
highlight Normal guibg=NONE ctermbg=NONE

" Make sidebar column numbers and splits transparent
highlight LineNr guibg=NONE ctermbg=NONE
highlight Folded guibg=NONE ctermbg=NONE
highlight NonText guibg=NONE ctermbg=NONE
highlight EndOfBuffer guibg=NONE ctermbg=NONE
highlight VertSplit guibg=NONE ctermbg=NONE

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

let mapleader = ","
set encoding=utf-8

call plug#begin('~/.config/nvim/plugged')

Plug 'tpope/vim-sensible'
Plug 'tpope/vim-fugitive'
Plug 'benekastah/neomake'
Plug 'eagletmt/ghcmod-vim'
Plug 'Shougo/vimproc.vim'
Plug 'eagletmt/neco-ghc'
Plug 'zchee/deoplete-clang'
Plug 'Shougo/deoplete.nvim'
Plug 'beloglazov/vim-online-thesaurus'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'airblade/vim-gitgutter'

call plug#end()

let g:online_thesaurus_map_keys = 0
nnoremap <C-k> :OnlineThesaurusCurrentWord<CR>

let g:deoplete#enable_at_startup = 1

autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

let g:deoplete#enable_ignore_case = 'ignorecase'

" Plugin key-mappings.
inoremap <expr><C-g>     deoplete#mappings#undo_completion()
inoremap <expr><C-l>     deoplete#mappings#complete_common_string()

hi Pmenu ctermbg=238 ctermfg=251

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  " For no inserting <CR> key.
  return pumvisible() ? "\<C-y>" : "\<CR>"
endfunction


" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

let g:deoplete#sources#clang#sort_algo = 'priority'
let g:deoplete#sources#clang#libclang_path = "/usr/lib/libclang.so"
let g:deoplete#sources#clang#clang_header ="/usr/include/clang/"
 
"inoremap <expr><Space> pumvisible() ? "\<C-y>" : "\<Space>"

map <C-t> :w!<CR>:!aspell check %<CR>:e! %<CR>

set completeopt+=menuone,noinsert
set completeopt-=preview

filetype plugin indent on

autocmd! QuitPre * let g:neomake_verbose = 0

" Ghc-bugs out with GHC-8.
" autocmd! BufWritePost,BufEnter * Neomake

nnoremap <C-c> :%y+<CR>
xnoremap <C-c> :y+<CR>

set nu
set smartcase
set undofile
set undodir=/tmp/emil/nvim/undo
set undolevels=1000
set undoreload=10000

let g:neomake_list_height	= 8
let g:neomake_open_list		= 2
let g:neomake_error_sign 	= {
    \ 'text': 'x>',
    \ 'texthl': 'Constant'
    \ }
let g:neomake_warning_sign 	= {
    \ 'text': '?>',
    \ 'texthl': 'WarningMsg'
    \ }

let g:neomake_cpp_enable_markers=['clang']
let g:neomake_cpp_clang_args = ["-std=c++11", "-Wextra", "-Wall", "-g"]

set tabstop=4 softtabstop=4 expandtab shiftwidth=4 smarttab
hi StatusLine ctermfg=242
hi Search ctermbg=NONE
hi SignColumn ctermbg=130
hi WarningMsg ctermbg=NONE ctermfg=220

let g:airline_powerline_fonts = 1
let g:Powerline_symbols='unicode'
let g:airline#extensions#tabline#enabled = 2
let g:airline_theme= 'distinguished'
let g:airline#extensions#tabline#fnamemod = ':t'
set noshowmode
set showtabline=2
set laststatus=2

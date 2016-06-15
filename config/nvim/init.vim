function! DoRemote(arg)
  UpdateRemotePlugins
endfunction

call plug#begin('~/.config/nvim/plugged')

Plug 'tpope/vim-sensible'
Plug 'benekastah/neomake'
Plug 'eagletmt/ghcmod-vim'
Plug 'Shougo/vimproc.vim'
Plug 'eagletmt/neco-ghc'
Plug 'zchee/deoplete-clang'
Plug 'Shougo/deoplete.nvim'

call plug#end()

let mapleader = ","

let g:deoplete#enable_at_startup = 1

autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

let g:deoplete#enable_ignore_case = 'ignorecase'

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     deoplete#mappings#undo_completion()
inoremap <expr><C-l>     deoplete#mappings#complete_common_string()

hi Pmenu ctermbg=238 ctermfg=251

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  "return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
  " For no inserting <CR> key.
  return pumvisible() ? "\<C-y>" : "\<CR>"

endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

let g:deoplete#sources#clang#sort_algo = 'priority'
let g:deoplete#sources#clang#libclang_path = "/usr/lib/libclang.so"
let g:deoplete#sources#clang#clang_header ="/usr/include/clang/"

inoremap <expr><Space> pumvisible() ? "\<C-y>" : "\<Space>"

set completeopt+=menuone,noinsert
set completeopt-=preview

filetype plugin indent on

"autocmd! BufWritePost,BufEnter * Neomake

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

let g:neomake_cpp_enable_markers=['g++']
let g:neomake_cpp_gcc_args = ["-std=c++14", "-Wextra", "-Wall", "-g"]

set tabstop=4 softtabstop=4 expandtab shiftwidth=4 smarttab
hi StatusLine ctermfg=242
hi Search ctermbg=NONE
hi SignColumn ctermbg=130
hi WarningMsg ctermbg=NONE ctermfg=220
"hi ErrorMsg ctermbg=130 ctermfg=1

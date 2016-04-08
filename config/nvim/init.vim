call plug#begin('~/.config/nvim/plugged')

Plug 'tpope/vim-sensible'
Plug 'benekastah/neomake'
Plug 'eagletmt/ghcmod-vim'
Plug 'Shougo/vimproc.vim'

call plug#end()

filetype plugin indent on

autocmd! BufWritePost,BufEnter * Neomake

set nu

let g:neomake_haskell_enabled_makers = ['hlint']

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

let g:neomake_cpp_enable_markers=['gcc']
let g:neomake_cpp_gcc_args = ["-std=c++14", "-Wextra", "-Wall", "-g"]

set tabstop=4 softtabstop=4 expandtab shiftwidth=4 smarttab
hi StatusLine ctermfg=242
hi Search ctermbg=NONE
hi SignColumn ctermbg=130
hi WarningMsg ctermbg=NONE ctermfg=220
"hi ErrorMsg ctermbg=130 ctermfg=1

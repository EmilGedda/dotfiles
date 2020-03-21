let mapleader = ","
set encoding=utf-8

" Auto install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/plugged')

Plug 'tpope/vim-sensible'
Plug 'tpope/vim-fugitive'
Plug 'benekastah/neomake'
Plug 'Shougo/vimproc.vim'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'airblade/vim-gitgutter'
Plug 'morhetz/gruvbox'
Plug 'ryanoasis/vim-devicons'
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }

call plug#end()

fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

" Save current view settings on a per-window, per-buffer basis.
function! AutoSaveWinView()
    if !exists("w:SavedBufView")
        let w:SavedBufView = {}
    endif
    let w:SavedBufView[bufnr("%")] = winsaveview()
endfunction

" Restore current view settings.
function! AutoRestoreWinView()
    let buf = bufnr("%")
    if exists("w:SavedBufView") && has_key(w:SavedBufView, buf)
        let v = winsaveview()
        let atStartOfFile = v.lnum == 1 && v.col == 0
        if atStartOfFile && !&diff
            call winrestview(w:SavedBufView[buf])
        endif
        unlet w:SavedBufView[buf]
    endif
endfunction

" When switching buffers, preserve window view.
if v:version >= 700
    autocmd BufLeave * call AutoSaveWinView()
    autocmd BufEnter * call AutoRestoreWinView()
endif

" Make escape work in the Neovim terminal.
tnoremap <Esc> <C-\><C-n>

let g:LanguageClient_serverStderr = '/tmp/clangd.stderr'

" Language server
let g:LanguageClient_serverCommands = {
  \ 'cpp': ['clangd'],
  \ }

"let g:neosnippet#snippets_directory='~/.config/nvim/snippets/'

" Plugin key-mappings.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets' behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
	\ "\<Plug>(neosnippet_expand_or_jump)"
	\: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
	\ "\<Plug>(neosnippet_expand_or_jump)"
	\: "\<TAB>"

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

nnoremap <Tab> :bn<CR>
nnoremap <S-Tab> :bp<CR>
nnoremap <leader>d :bp\|bd #<CR>

" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

nnoremap <M-q> :TSDefPreview<CR>
nnoremap <M-w> :TSRefs<CR>
nnoremap <M-e> :TSType<CR>

let g:deoplete#sources#clang#sort_algo = 'priority'

"inoremap <expr><Space> pumvisible() ? "\<C-y>" : "\<Space>"

map <C-t> :w!<CR>:!aspell check %<CR>:e! %<CR>

set completeopt+=menuone,noinsert
set completeopt-=preview

set updatetime=1000

filetype plugin indent on

autocmd! QuitPre * let g:neomake_verbose = 0

" Ghc-bugs out with GHC-8.
" autocmd! BufWritePost * Neomake

nnoremap <C-c> :%y+<CR>
xnoremap <C-c> :y+<CR>
cnoreabbrev <expr> W ((getcmdtype() is# ':' && getcmdline() is# 'W')?('w'):('W'))

set nu
set smartcase
set undofile
set undodir=/home/emil/.cache/nvim/undo
set undolevels=1000
set undoreload=10000
set inccommand=nosplit
set hidden

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

let g:neomake_cpp_enabled_makers=['clang++']
let g:neomake_cpp_clang_args = ["-std=c++17", "-Wextra", "-Wall", "-g"]

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

let g:gruvbox_italic=1
colorscheme gruvbox

nnoremap <F5> :call LanguageClient_contextMenu()<CR>
" Or map each action separately
nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>

set guicursor=n-c:hor5-blinkon0
set mouse=a
au VimLeave * set guicursor=a:hor5-blinkon0

let mapleader = ","

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
Plug 'fatih/vim-go'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'airblade/vim-gitgutter'
Plug 'morhetz/gruvbox'
Plug 'ryanoasis/vim-devicons'
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'HerringtonDarkholme/yats.vim'
Plug 'edkolev/tmuxline.vim'

call plug#end()

let g:go_def_mapping_enabled = 0
let g:go_bin_path = $HOME."/go/bin"
let g:go_doc_keywordprg_enabled = 0
let g:go_fmt_command = "goimports"
let g:go_imports_autosave = 0
let g:go_fmt_options = "-local github.com/EmilGedda"

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
"let g:neosnippet#snippets_directory='~/.config/nvim/snippets/'

" Plugin key-mappings.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets' behavior.
" imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
"     \ "\<Plug>(neosnippet_expand_or_jump)"
"     \: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
      \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
"     \ "\<Plug>(neosnippet_expand_or_jump)"
"     \: "\<TAB>"


autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
au BufRead,BufNewFile *.tsx set filetype=typescriptreact

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
nnoremap <leader>bd :bp\|bd #<CR>

" <TAB>: completion.
" inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

"inoremap <expr><Space> pumvisible() ? "\<C-y>" : "\<Space>"

set updatetime=300

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

let g:neomake_list_height    = 8
let g:neomake_open_list        = 2
let g:neomake_error_sign     = {
    \ 'text': 'x>',
    \ 'texthl': 'Constant'
    \ }
let g:neomake_warning_sign     = {
    \ 'text': '?>',
    \ 'texthl': 'WarningMsg'
    \ }

let g:neomake_cpp_enabled_makers=['clang++']
let g:neomake_cpp_clang_args = ["-std=c++17", "-Wextra", "-Wall", "-g"]

set tabstop=4 softtabstop=4 expandtab shiftwidth=4 smarttab

let g:airline_powerline_fonts = 1
let g:Powerline_symbols='unicode'
let g:airline#extensions#tabline#enabled = 2
let g:airline_theme= 'distinguished'
let g:airline#extensions#tabline#fnamemod = ':t'
set noshowmode
set showtabline=2
set laststatus=2

let g:gruvbox_italic=1
let g:gruvbox_sign_column='bg0'
colorscheme gruvbox

set guicursor=n-c:hor5-blinkon0
set mouse=a
au VimLeave * set guicursor=a:hor5-blinkon0

let g:go_highlight_structs = 1
let g:go_highlight_methods = 1
let g:go_highlight_functions = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_build_constraints = 1

" -------------------------------------------------------------------------------------------------
" coc.nvim default settings
" -------------------------------------------------------------------------------------------------
set signcolumn=number

" if hidden is not set, TextEdit might fail.
set hidden
" Better display for messages
set cmdheight=1
" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300
" don't give |ins-completion-menu| messages.
set shortmess+=c

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif


" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> <leader>df <Plug>(coc-diagnostic-prev)
nmap <silent> <leader>db <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use U to show documentation in preview window
noremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
vmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Update signature help on jump placeholder.
autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')

" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>


" coc colors"

hi CocErrorHighlight ctermfg=red term=underline
hi CocWarningHighlight ctermfg=214 term=underline

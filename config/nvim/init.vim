let maplocalleader=","
let mapleader = ","

call plug#begin('~/.config/nvim/plugged')

Plug 'tpope/vim-sensible'
Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-signify'

Plug 'tomasiser/vim-code-dark'

Plug 'nvim-lualine/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'

Plug 'machakann/vim-sandwich'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }

Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'nvim-treesitter/nvim-tree-docs'


Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/nvim-cmp'

Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'

Plug 'nvim-telescope/telescope-ui-select.nvim'

Plug 'danymat/neogen'
Plug 'junegunn/vim-easy-align'

Plug 'dstein64/vim-startuptime'
Plug 'nvim-telescope/telescope-file-browser.nvim'

Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'
Plug 'theHamsta/nvim-dap-virtual-text'

call plug#end()

let &shell = 'pwsh.exe'
let &shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
let &shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
let &shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
set shellquote= shellxquote=

command Term :set nonu | startinsert | term
cabbrev term Term

let g:signify_priority = 8

set fillchars+=vert:\▏


" Start interactive EasyAlign for a motion/text object (e.g. gaip)
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

autocmd BufReadPost * if @% !~# '\.git[\/\\]COMMIT_EDITMSG$' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" Search for the ... arguments separated with whitespace (if no '!'),
" or with non-word characters (if '!' added to command).
function! SearchMultiLine(bang, ...)
  if a:0 > 0
    let sep = (a:bang) ? '\_W\+' : '\_s\+'
    let @/ = join(a:000, sep)
  endif
endfunction
command! -bang -nargs=* -complete=tag S call SearchMultiLine(<bang>0, <f-args>)|normal! /<C-R>/<CR>

" autocmd TermClose * if !v:event.status | exe 'bdelete! '..expand('<abuf>') | endif

set ssop+=resize,buffers,tabpages,winpos,winsize

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

if has("win32") && has("nvim")
  nnoremap <C-z> <nop>
  inoremap <C-z> <nop>
  vnoremap <C-z> <nop>
  snoremap <C-z> <nop>
  xnoremap <C-z> <nop>
  cnoremap <C-z> <nop>
  onoremap <C-z> <nop>
endif

" Make escape work in the Neovim terminal.
tnoremap <Esc> <C-\><C-n>

autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

set completeopt=menu,menuone,noselect

" NOTE: You can use other key to expand snippet.

" Expand
imap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
smap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'

" Expand or jump
imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'

" Jump forward or backward
imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'

" Select or cut text to use as $TM_SELECTED_TEXT in the next snippet.
" See https://github.com/hrsh7th/vim-vsnip/pull/50
" nmap        s   <Plug>(vsnip-select-text)
" xmap        s   <Plug>(vsnip-select-text)
" nmap        S   <Plug>(vsnip-cut-text)
" xmap        S   <Plug>(vsnip-cut-text)

" hi Pmenu ctermbg=238 ctermfg=251

" Recommended key-mappings.
" <CR>: close popup and save indent.
"  inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
"  function! s:my_cr_function()
"    " For no inserting <CR> key.
"    return pumvisible() ? "\<C-y>" : "\<CR>"
"  endfunction

" Tabbing hotkeys
nmap <Tab> :bn<CR>
nmap <S-Tab> :bp<CR>
nnoremap <leader>bd :bp\|bd #<CR>

" Saving shortcuts
nnoremap <leader>w :w<CR>

nnoremap <leader>gc :Git<CR>
nnoremap <leader>gp :Git push<CR>

" <TAB>: completion.
" inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

"inoremap <expr><Space> pumvisible() ? "\<C-y>" : "\<Space>"

set updatetime=300

filetype plugin indent on

autocmd! BufWritePost * call TrimWhitespace()

nnoremap <C-c> :%y+<CR>
xnoremap <C-c> :y+<CR>
cnoreabbrev <expr> W ((getcmdtype() is# ':' && getcmdline() is# 'W')?('w'):('W'))

set nu
set ignorecase
set smartcase
set undofile
set undodir=~/.cache/nvim/undo
set undolevels=1000
set undoreload=10000
set inccommand=nosplit


let g:signify_sign_change = '~~'
let g:signify_sign_add = '++'
let g:signify_sign_delete_first_line = '-'
let g:signify_sign_show_count = 1


"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

set tabstop=4 softtabstop=4 expandtab shiftwidth=4

set noshowmode
set showtabline=2
set laststatus=2

colorscheme codedark

highlight! GhostText gui=italic guifg=#808080

lua require('config')


set guicursor=n-c:hor5-blinkon0
set mouse=a

set signcolumn=number

" if hidden is not set, TextEdit might fail.
set hidden
" Better display for messages
set cmdheight=1
" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300
" don't give |ins-completion-menu| messages.
set shortmess+=c

" dont join with space when autoformatting
set nojs


nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
nnoremap <leader>fr <cmd>lua require('telescope.builtin').lsp_references()<cr>
nnoremap <leader>fs <cmd>lua require('telescope.builtin').lsp_dynamic_workspace_symbols()<cr>

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
" inoremap <silent><expr> <TAB>
"       \ pumvisible() ? "\<C-n>" :
"       \ <SID>check_back_space() ? "\<TAB>" :
"       \ coc#refresh()
" inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" function! s:check_back_space() abort
"   let col = col('.') - 1
"   return !col || getline('.')[col - 1]  =~# '\s'
" endfunction

" " Use <c-space> to trigger completion.
" inoremap <silent><expr> <c-space> coc#refresh()
"
" " Use `,db` and `,df` to navigate diagnostics
" nmap <silent> <leader>df <Plug>(coc-diagnostic-next)
" nmap <silent> <leader>db <Plug>(coc-diagnostic-prev)
"
" " Remap keys for gotos
" nmap <silent> gd <Plug>(coc-definition)
" nmap <silent> gy <Plug>(coc-type-definition)
" nmap <silent> gi <Plug>(coc-implementation)
" nmap <silent> gr <Plug>(coc-references)
"
" " Use U to show documentation in preview window
" noremap <silent> K :call <SID>show_documentation()<CR>
"
" function! s:show_documentation()
"   if (index(['vim','help'], &filetype) >= 0)
"     execute 'h '.expand('<cword>')
"   else
"     call CocAction('doHover')
"   endif
" endfunction
"
" autocmd CursorHold * silent call CocActionAsync('highlight')
"
" " Remap for rename current word
" nmap <leader>rn <Plug>(coc-rename)
"
" " Remap for format selected region
" vmap <leader>f  <Plug>(coc-format-selected)
" nmap <leader>f  <Plug>(coc-format-selected)
"
" " Update signature help on jump placeholder.
" autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
"
" " Apply AutoFix to problem on the current line.
" nmap <leader>qf  <Plug>(coc-fix-current)
"
" " Show all diagnostics
" nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" " Manage extensions
" nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" " Show commands
" nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" " Find symbol of current document
" nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" " Search workspace symbols
" nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" " Do default action for next item.
" nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" " Do default action for previous item.
" nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" " Resume latest coc list
" nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
" " List files under CWD
" nnoremap <silent> <space>f  :<C-u>CocList files<CR>
" " Open yank list with preview in normal mode
" nnoremap <silent> <space>y  :<C-u>CocList -A --normal yank<cr>
" " grep for pattern recursively under cwd
" nnoremap <silent> <space>g  :<C-u>CocList grep<CR>
"
" xmap <leader>a  <Plug>(coc-codeaction-selected)
" nmap <leader>ca <Plug>(coc-codeaction-selected)
" vmap <leader>ca <Plug>(coc-codeaction-selected)
" nmap <leader>cl <Plug>(coc-codelens-action)
" nmap <leader>ol <Plug>(coc-openlink)
"

" gray
highlight! CmpItemAbbrDeprecated guibg=NONE gui=strikethrough guifg=#808080
" blue
highlight! CmpItemAbbrMatch guibg=NONE guifg=#569CD6
highlight! CmpItemAbbrMatchFuzzy guibg=NONE guifg=#569CD6
" light blue
highlight! CmpItemKindVariable guibg=NONE guifg=#9CDCFE
highlight! CmpItemKindInterface guibg=NONE guifg=#9CDCFE
highlight! CmpItemKindText guibg=NONE guifg=#9CDCFE
" pink
highlight! CmpItemKindFunction guibg=NONE guifg=#C586C0
highlight! CmpItemKindMethod guibg=NONE guifg=#C586C0
" front
highlight! CmpItemKindKeyword guibg=NONE guifg=#D4D4D4
highlight! CmpItemKindProperty guibg=NONE guifg=#D4D4D4
highlight! CmpItemKindUnit guibg=NONE guifg=#D4D4D4

highlight VertSplit ctermfg=237
hi! link TSVariable Normal
hi! link TSVariableBuiltin Normal
hi! link TSParameter Normal
hi! link TSParameterReference Normal

highlight SignifySignAdd    guifg=#77982E gui=NONE
highlight SignifySignDelete guifg=#FF3030 gui=NONE
highlight SignifySignChange guifg=#F8C82E gui=NONE


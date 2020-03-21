" Haskell Specific Settings

" Disable haskell-vim omnifunc
let g:haskellmode_completion_ghc = 0
autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

autocmd BufWritePre * :call TrimWhitespace()

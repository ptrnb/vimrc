" set guifont=Menlo:h12
set macligatures
set guifont=Fira\ Code:h12
set antialias
set linespace=6
colorscheme lucius


if has("gui_macvim")
    nnoremap <F1> :set invfullscreen<cr>
    inoremap <F1> <esc>:set invfullscreen<cr>a
endif

" set guifont=Menlo:h12
set guifont=Menlo\ for\ Powerline:h11
set antialias
set linespace=6
colorscheme lucius


if has("gui_macvim")
    nnoremap <F1> :set invfullscreen<cr>
    inoremap <F1> <esc>:set invfullscreen<cr>a
endif

" My vimrc
" Author: Peter Brown 
"         With thanks to Steve Losh
"         http://learnvimscriptthehardway.stevelosh.com
"
" Initial setup {{{
filetype off
" Load pathogen to allow ~/.vim/bundle
"  call pathogen#incubate()
execute pathogen#infect()
call pathogen#helptags()
filetype plugin indent on
set nocompatible
" }}}
" Leader {{{
let mapleader = ","
nnoremap \ ,
let maplocalleader = "\\"
" }}}
" Basic vim configuration {{{
set modelines=0
let python_highlight_all=1
syntax on
" Don't highlight items longer than 800 chars
set synmaxcol=3000
set hlsearch
set nojoinspaces
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set smartindent
set shiftround
set title
set encoding=utf-8
set scrolloff=3
set autoindent
set showmode
set showcmd
set hidden
set visualbell
set nocursorline
set nolist
set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮
set fillchars=diff:⣿,vert:│
set ttyfast
set lazyredraw
set matchtime=3
set ruler
set splitbelow
set splitright
set autoread
set backspace=indent,eol,start
set laststatus=2
set number
set numberwidth=7
set undofile
set viminfo='20,\"50	" read/write a .viminfo file, don't store more
			" than 50 lines of registers
set history=50		" keep 50 lines of command line history


set wrap
set textwidth=80
set formatoptions=qrn1
set linebreak
set diffopt=filler,iwhite,vertical

" Better completion
set complete=.,w,b,u,t,i
set completeopt=longest,menuone,preview

set ignorecase
set smartcase
" set infercase
" set gdefault
set incsearch
set showmatch
set hlsearch

" Toggle paste
set pastetoggle=<F2>

" Set timeout for key mappings
set notimeout
set ttimeout
set ttimeoutlen=10

" set colorcolumn=+1
" hi ColorColumn ctermbg=lightgrey guibg=lightgrey

augroup insert_cursor
  autocmd!
  autocmd InsertEnter * set cursorline
  autocmd InsertLeave * set nocursorline
augroup END

" Allow mouse
set mouse=a

" Set tabstop, softtabstop and shiftwidth to the same value
"
command! -nargs=* Stab call Stab()
function! Stab()
  call inputsave()
  let l:tabstop = 1 * input('set tabstop = softtabstop = shiftwidth = ')
  if l:tabstop > 0
    let &l:sts = l:tabstop
    let &l:ts = l:tabstop
    let &l:sw = l:tabstop
  endif
  call inputrestore()
  call SummarizeTabs()
endfunction

function! SummarizeTabs()
  try
    echohl ModeMsg
    echo "\n"
    echon 'tabstop='.&l:ts
    echon ' shiftwidth='.&l:sw
    echon ' softtabstop='.&l:sts
    if &l:et
      echon ' expandtab'
    else
      echon ' noexpandtab'
    endif
  finally
    echoh1 None
  endtry
endfunction

" Matchit
" :runtime macros/matchit.vim
" }}}
" General key mappings {{{
" Search from Steven Losh
nnoremap / /\v
vnoremap / /\v

"Fast saving
nnoremap <leader>w :w!

"Change case
inoremap <leader>u <esc>mzgUiw`za

"Toggle search highlight
nnoremap <silent> <leader><space> :noh<cr>:call clearmatches()<cr>

" Disable the regular cursor keys
" to force adaptation to Vim
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>

inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" Improved mappings for home keys
nnoremap j gj
nnoremap k gk
nnoremap H ^
nnoremap L g_

vnoremap <F1> <esc>

" Allow semi-colon to function as a full colon
" nnoremap ; :

" Don't move on *
nnoremap * *<c-o>


" The next comment mappings are no longer required
" thanks to NERDCommenter

" Make mapping to remove shell script comments
" map <F11> 1!!sed "s/^\([ <TAB>]*\)\# \(.*\)/\1\2/"j
" Make mapping to insert shell script comments
" map <F12> 1!!sed "s/^\([ <TAB>]*\)\(.*\)/\1\# \2 /"j

" These are insert mappings that enable to the Ctrl chords to navigate in
" insert mode - are they really necessary?  <C-R> shouldn't be mapped

" imap <C-A>  <C-O>0
" imap <C-D>  <C-O>x
" imap <C-O>h  <C-O>h
" imap <C-E>  <C-O>$
" imap <C-u>  <C-O>u
" imap <C-R>  <C-O><C-R>
" The following commands will move the cursor to the next/previous
" line, but I am used to using Vim's prefix completion commands.
" imap <C-j>  <C-O>j
" imap <C-l>  <C-O>l
" imap <C-k>  <C-O>k
" imap <C-h>  <C-O>h
" imap <C-O>b <C-O>B
" imap <C-O>f <C-O>W
" imap <C-y> <C-o>dd
" imap <C-W>  <S-Right>
" imap <C-f> <C-O><C-F>
" imap <C-B> <C-O><C-B>
"
map Y y$
" Don't use Ex mode, use Q for formatting
map Q gq

" System clipboard interaction.  Mostly from:
" https://github.com/henrik/dotfiles/blob/master/vim/config/mappings.vim
" nnoremap <leader>y "*y
" nnoremap <leader>p :set paste<CR>"*p<CR>:set nopaste<CR>
" nnoremap <leader>P :set paste<CR>"*P<CR>:set nopaste<CR>
" vnoremap <leader>y "*ygv
vnoremap <leader>y :call system("pbcopy", getreg("\""))<CR>
nnoremap <leader>p :call setreg("\"", system("pbpaste"))<CR>p

" Clean trailing whitespace
nnoremap <leader>w mz:%s/\s\+$//<cr>:let @/=''<cr>`z

" Select entire buffer
nnoremap vaa ggvGg_
nnoremap Vaa ggVG

" Toggle [i]nvisible characters
nnoremap <leader><leader>i :set list!<cr>

" convert_spaces_to_snake_case
nnoremap <silent><leader>sn :s/\> \</_/ge<cr> :noh <cr>
inoremap <silent><leader>sn <esc>:s/\> \</_/ge<cr>:noh<cr>A
vnoremap <silent><leader>sn :s/\%V /_/g<cr> :noh <cr>

" convert-dash-case to snake_case
nnoremap <silent><leader>dn :s/\>-\</_/ge<cr> :noh <cr>
inoremap <silent><leader>dn <esc>:s/\>-\</_/ge<cr>:noh<cr>A
" }}}
" List navigation {{{

nnoremap <left>  :cprev<cr>zvzz
nnoremap <right> :cnext<cr>zvzz
nnoremap <up>    :lprev<cr>zvzz
nnoremap <down>  :lnext<cr>zvzz

" }}}
" Abbreviations {{{
" }}}
" Folding {{{

set foldlevelstart=0

" Space to toggle folds.
nnoremap <Space> za
vnoremap <Space> za

" "Refocus" folds
nnoremap ,z zMzvzz

" Make zO recursively open whatever top level fold we're in, no matter where the
" cursor happens to be.
nnoremap zO zCzO

function! PetesFoldText() " {{{
    let line = getline(v:foldstart)

    let nucolwidth = &fdc + &number * &numberwidth
    let windowwidth = winwidth(0) - nucolwidth - 3
    let foldedlinecount = v:foldend - v:foldstart

    " expand tabs into spaces
    let onetab = strpart('          ', 0, &tabstop)
    let line = substitute(line, '\t', onetab, 'g')

    let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
    let fillcharcount = windowwidth - len(line) - len(foldedlinecount)
    return line . '.' . repeat(".",fillcharcount) . foldedlinecount . ' ' . ' '
endfunction " }}}
set foldtext=PetesFoldText()
" }}}
" Line return {{{
augroup line_return
    au!
    au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \     execute 'normal! g`"zvzz' |
        \ endif
augroup END
" }}}
" Wildmenu {{{
set wildmenu
set wildmode=list:longest

set wildignore+=.hg,.git,.svn                    " Version control
set wildignore+=*.aux,*.out,*.toc                " LaTeX intermediate files
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   " binary images
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wildignore+=*.spl                            " compiled spelling word lists
set wildignore+=*.sw?                            " Vim swap files
set wildignore+=*.DS_Store                       " OSX bullshit
set wildignore+=*.pyc                            " Python byte code
set wildignore+=*.orig                           " Merge resolution files
" }}}
" Colour scheme {{{

if has("gui_running")
    set background=light
else
    set background=dark
endif
" set background=light
let t_Co = 256

let g:solarized_termtrans=1
let g:solarized_degrade=0
let g:solarized_bold=1
let g:solarized_underline=1
let g:solarized_italic=1
" let g:solarized_termcolors=16
let g:solarized_contrast="normal"
let g:solarized_visibility="normal"
let g:solarized_diffmode="normal"
" let g:solarized_hitrail=1
" let g:solarized_menu=1
call togglebg#map("<F5>")
" colorscheme solarized
colorscheme lucius
" }}}
" Highlight word {{{
hi InterestingWord1 cterm=bold ctermfg=15 ctermbg=1 gui=bold guifg=#000000 guibg=#FFA700

hi InterestingWord2 cterm=bold ctermfg=23 ctermbg=117 gui=bold guifg=#000000 guibg=#53FF00
hi InterestingWord3 cterm=bold ctermfg=22 ctermbg=148 gui=bold guifg=#000000 guibg=#FF74F8

nnoremap <silent> <leader>h1 :execute 'match InterestingWord1 /\<<c-r><c-w>\>/'<cr>
nnoremap <silent> <leader>h2 :execute '2match InterestingWord2 /\<<c-r><c-w>\>/'<cr>
nnoremap <silent> <leader>h3 :execute '3match InterestingWord3 /\<<c-r><c-w>\>/'<cr>

" }}}
" Backup settings {{{
set backup                                " enable backups
set noswapfile                            " It's 2012, Vim.

set undodir=~/.vim-backups/tmp/undo//     " undo files
set backupdir=~/.vim-backups/tmp/backup// " backups
set directory=~/.vim-backups/tmp/swap//   " swap files

" Make those folders automatically if they don't already exist.
if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), "p")
endif
if !isdirectory(expand(&backupdir))
    call mkdir(expand(&backupdir), "p")
endif
if !isdirectory(expand(&directory))
    call mkdir(expand(&directory), "p")
endif

" Make Vim able to edit crontab files again.
set backupskip=/tmp/*,/private/tmp/*"
" }}}
" Movement {{{

" Keep search matches in the middle of the window.
nnoremap n nzzzv
nnoremap N Nzzzv

" Same when jumping around
nnoremap g; g;zz
nnoremap g, g,zz
nnoremap <c-o> <c-o>zz

" Convenient window bindings
nnoremap <c-j> <c-w>j
nnoremap <c-h> <c-w>h
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l

" }}}
" visual mode */# from scrooloose {{{

function! s:vsetsearch()
  let temp = @@
  norm! gvy
  let @/ = '\v' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
  let @@ = temp
endfunction

vnoremap * :<c-u>call <sid>vsetsearch()<cr>//<cr><c-o>
vnoremap # :<c-u>call <sid>vsetsearch()<cr>??<cr><c-o>
" }}}
" My custom vim settings {{{
" Powerline settings

" let g:Powerline_theme = 'solarized'
" let g:Powerline_colorscheme = 'solarized'

if has("gui_running")
    let g:Powerline_symbols = 'fancy'
else
    let g:Powerline_symbols = 'compatible'
endif
let g:Powerline_theme = 'solarized256'

" NerdComment settings
:let NERDSpaceDelims=1

set statusline=%.60f     " Path to the file
set statusline+=%=    " Switch to the right side
set statusline+=%l    " Current line
set statusline+=/     " Separator
set statusline+=%L    " Total lines

" Sudo to write
cnoremap w!! w !sudo tee % >/dev/null

nnoremap <leader>- ddp
nnoremap <leader>_ ddkP
inoremap <leader><C-d> <esc>ddi

" Upper case
inoremap <leader><C-u> <esc>viwUEa

" escape
inoremap jk <esc>
inoremap <esc> <nop>

" Toggle numbers and fold column for easy copying
nnoremap <leader>nu :set nonumber!<cr>:set foldcolumn=0<cr>

" reformat the paragraph - collapse
nnoremap <leader>q gqip

" Need to fix this so that it only activates if numbers are on
" augroup insert_mode
    " autocmd!
    " autocmd InsertEnter * :set number
    " autocmd InsertLeave * :set relativenumber
" augroup END

" augroup autosave
    " autocmd!
    " autocmd FocusLost * :wa
" augroup END

" Make p in Visual mode replace the selected text with the "" register.
vnoremap p <Esc>:let current_reg = @"<CR>gvdi<C-R>=current_reg<CR><Esc>
" }}}
" Filetypes {{{
    " Only do this part when compiled with support for autocommands.
if has("autocmd")
    " XML file settings {{{
    augroup filetype_xml
        autocmd!
        autocmd BufNewFile,BufRead *.xml :setlocal nowrap number
        vnoremap <leader>xc :!perl -pe "s/(^[\t\s]*\d+.*?)(?=(<p\|$))/<\!--  \1  -->\n/"<cr>
    augroup end
    " }}}
    " Vimscript file settings {{{
    augroup filetype_vim
        autocmd!
        autocmd FileType vim setlocal foldmethod=marker
    augroup END
    " edit vimrc/gvimrc files
    " updated to work with Dropbox storage location
    nnoremap <leader>ev  :split $MYVIMRC<cr>
    nnoremap <leader>sv  :source $MYVIMRC<cr>
    if has ("gui_running")
        nnoremap <leader>eg  :split $MYGVIMRC<cr>
        nnoremap <leader>sg  :source $MYGVIMRC<cr>
    endif
    " }}}
    " Vagrant {{{

    augroup ft_vagrant
        au!
        au BufRead,BufNewFile Vagrantfile set ft=ruby
    augroup END

    " }}}
    " Puppet {{{

    augroup ft_puppet
        au!

        au Filetype puppet setlocal foldmethod=marker
        au Filetype puppet setlocal foldmarker={,}
    augroup END

    " }}}
    " QuickFix {{{

    augroup ft_quickfix
        au!
        au Filetype qf setlocal colorcolumn=0 nolist nocursorline nowrap tw=0
    augroup END

    " }}}
    " Python file settings {{{
    augroup filetype_py
        autocmd!
        autocmd BufNewFile,BufRead *.py setlocal
        \ tabstop=4
        \ softtabstop=4
        \ shiftwidth=4
        \ expandtab
        \ autoindent
        \ fileformat=unix
    augroup end
    " }}}
    " Ruby {{{

    " augroup ft_ruby
        " au!
        " au Filetype ruby setlocal foldmethod=syntax
    " augroup END

    iabbrev pust puts

    " }}}
    " Vim {{{

    augroup ft_vim
        au!

        au FileType vim setlocal foldmethod=marker
        au FileType help setlocal textwidth=78
        au BufWinEnter *.txt if &ft == 'help' | wincmd J | endif
    augroup END

    " }}}
    " Text files {{{
    " In text files, always limit the width of text to 78 characters
    augroup filetype_txt
        autocmd!
        autocmd BufRead *.txt setlocal tw=78 filetype=txt
    augroup END
    " }}}
    " JSON files {{{
    augroup filetype_json
        autocmd!
        autocmd BufRead *.json setlocal tw=78 filetype=js
        let g:vim_json_syntax_conceal = 0
    augroup END
    " }}}
    " Ruby files {{{
    augroup filetype_ruby
        " Clear old autocmds group
        autocmd!
        " autoindent with two spaces, always expand tabs
        autocmd FileType ruby,eruby,yaml setlocal ai sw=2 sts=2 et
    augroup END
    " }}}
    " C programming {{{
    augroup cprog
    " Remove all cprog autocommands
    au!

    " When starting to edit a file:
    "   For C and C++ files set formatting of comments and set C-indenting on.
    "   For other files switch it off.
    "   Don't change the order, it's important that the line with * comes first.
    autocmd FileType c,cpp  setlocal formatoptions=croql cindent comments=sr:/*,mb:*,el:*/,://
    augroup END
    " }}}
    " GZip autocommand group {{{
    augroup gzip
    " Remove all gzip autocommands
    au!

    " Enable editing of gzipped files
    " set binary mode before reading the file
    autocmd BufReadPre,FileReadPre	*.gz,*.bz2 set bin
    autocmd BufReadPost,FileReadPost	*.gz call GZIP_read("gunzip")
    autocmd BufReadPost,FileReadPost	*.bz2 call GZIP_read("bunzip2")
    autocmd BufWritePost,FileWritePost	*.gz call GZIP_write("gzip")
    autocmd BufWritePost,FileWritePost	*.bz2 call GZIP_write("bzip2")
    autocmd FileAppendPre			*.gz call GZIP_appre("gunzip")
    autocmd FileAppendPre			*.bz2 call GZIP_appre("bunzip2")
    autocmd FileAppendPost		*.gz call GZIP_write("gzip")
    autocmd FileAppendPost		*.bz2 call GZIP_write("bzip2")

    " After reading compressed file: Uncompress text in buffer with "cmd"
    fun! GZIP_read(cmd)
        " set 'cmdheight' to two, to avoid the hit-return prompt
        let ch_save = &ch
        set ch=3
        " when filtering the whole buffer, it will become empty
        let empty = line("'[") == 1 && line("']") == line("$")
        let tmp = tempname()
        let tmpe = tmp . "." . expand("<afile>:e")
        " write the just read lines to a temp file "'[,']w tmp.gz"
        execute "'[,']w " . tmpe
        " uncompress the temp file "!gunzip tmp.gz"
        execute "!" . a:cmd . " " . tmpe
        " delete the compressed lines
        '[,']d
        " read in the uncompressed lines "'[-1r tmp"
        set nobin
        execute "'[-1r " . tmp
        " if buffer became empty, delete trailing blank line
        if empty
        normal Gdd''
        endif
        " delete the temp file
        call delete(tmp)
        let &ch = ch_save
        " When uncompressed the whole buffer, do autocommands
        if empty
        execute ":doautocmd BufReadPost " . expand("%:r")
    endfun

    " After writing compressed file: Compress written file with "cmd"
    fun! GZIP_write(cmd)
        if rename(expand("<afile>"), expand("<afile>:r")) == 0
        execute "!" . a:cmd . " <afile>:r"
        endif
    endfun

    " Before appending to compressed file: Uncompress file with "cmd"
    fun! GZIP_appre(cmd)
        execute "!" . a:cmd . " <afile>"
        call rename(expand("<afile>:r"), expand("<afile>"))
    endfun

    augroup END
    " }}}
    " HTML filetype settings {{{
    augroup filetype_html
        autocmd!
        autocmd FileType html nnoremap <buffer> <localleader>f Vatzf
    augroup END
    " }}}
    " Pago screenwriting filetype settings {{{
    augroup filetype_pago
        autocmd!
        autocmd FileType html nnoremap <buffer> <localleader>f Vatzf
    augroup END
    " }}}
endif " has("autocmd") 
" }}}
" Plugin settings {{{
" Toggle NERDTree {{{
nnoremap <leader>nt :NERDTreeToggle<cr>
let NERDTreeHighlightCursorline = 1
let NERDTreeIgnore = ['\~$', '.*\.pyc$', 'pip-log\.txt$', 'whoosh_index',
                    \ 'xapian_index', '.*.pid', 'monitor.py', '.*-fixtures-.*.json',
                    \ '.*\.o$', 'db.db', 'tags.bak']

let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let NERDChristmasTree = 1
let NERDTreeChDirMode = 2
let NERDTreeQuitOnOpen = 1
let NERDTreeMapJumpFirstChild = 'gK'
" }}}
" Ack / ag {{{
nnoremap <leader>a :Ack!<space>
let g:ackprg = 'ag --smart-case --nogroup --nocolor --column'
" }}}
" Taglist and Exuberant ctags {{{
let Tlist_Ctags_Cmd = "/opt/local/bin/ctags"
let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_Use_Right_Window = 1
let Tlist_Close_On_Select = 0
let Tlist_WinWidth = 40

nnoremap <silent><leader>tl :TlistToggle<cr>
" }}}
" Strip whitespace {{{
function! <SID>Preserve(command)
    "Preparation, save last search, and cursor position.
    let _s=@/ " store the last search and cursor pos
    let save_cursor = getpos(".")
    " let l = line(".")
    " let c = col(".")
    " do the cleanup
    execute a:command
    " Now restore the prev search and cursor pos
    let @/=_s
    " call cursor(l, c)
    call setpos('.', save_cursor)
endfunction

noremap <silent> _$ :call <SID>Preserve("%s/\\s\\+$//e")<cr>
" }}}
" Pandoc {{{
" soft wrapping
let g:pandoc_use_hard_wraps = 0
" disable syntax highlighting for implicit links
let g:pandoc_no_empty_implicits = 1
let g:pandoc_no_folding = 1

" Italic and bold markdown
let b:surround_{char2nr("i")} = "*\r*"
let b:surround_{char2nr("b")} = "**\r**"
"surround current word with single asterisks
nnoremap <leader>i viwSiW
inoremap <leader>i <ESC>viwSiWi

"same thing using command key in macvim
if has("gui_running")
    nnoremap <D-i> viwSiW
    inoremap <D-i> <ESC>viwSiWi
endif

" surround current word with double asterisks
nnoremap <leader>b viwSbW
inoremap <leader>b <ESC>viwSbWi

"same thing using command key in macvim
if has("gui_running")
    nnoremap <D-b> viwSbW
    inoremap <D-b> <ESC>viwSbWi
endif

" Insert a table headers separator line below the current line,
" -- adjusted to the current line as headers line 
nnoremap <F4>t yyp:s/\v\S.{-}\ze(\s{2}\S\|$)/\=substitute(submatch(0),'.','-','g')/g<CR> :set nohls<cr>
" ...or above the current line for a headerless table
nnoremap <F4>T yyP:s/\v\S.{-}\ze(\s{2}\S\|$)/\=substitute(submatch(0),'.','-','g')/g<CR> :set nohls<cr>

" Mappings for atxheaders
nnoremap <leader><leader>1 :s/\v^(#*)\s*<([^#]+)>\s*\1*$/# \2 #/<CR> :set nohls<cr>
inoremap <leader><leader>1 <esc>:s/\v^(#*)\s*<([^#]+)>\s*\1*$/# \2 #/<cr> :set nohls<cr>A
nnoremap <leader><leader>2 :s/\v^(#*)\s*<([^#]+)>\s*\1*$/## \2 ##/<CR> :set nohls<cr>
inoremap <leader><leader>2 <esc>:s/\v^(#*)\s*<([^#]+)>\s*\1*$/## \2 ##/<cr> :set nohls<cr>A
nnoremap <leader><leader>3 :s/\v^(#*)\s*<([^#]+)>\s*\1*$/### \2 ###/<CR> :set nohls<cr>
inoremap <leader><leader>3 <esc>:s/\v^(#*)\s*<([^#]+)>\s*\1*$/### \2 ###/<cr> :set nohls<cr>A
nnoremap <leader><leader>4 :s/\v^(#*)\s*<([^#]+)>\s*\1*$/#### \2 ####/<CR> :set nohls<cr>
inoremap <leader><leader>4 <esc>:s/\v^(#*)\s*<([^#]+)>\s*\1*$/#### \2 ####/<cr> :set nohls<cr>A
nnoremap <leader><leader>5 :s/\v^(#*)\s*<([^#]+)>\s*\1*$/##### \2 #####/<CR> :set nohls<cr>
inoremap <leader><leader>5 <esc>:s/\v^(#*)\s*<([^#]+)>\s*\1*$/##### \2 #####/<cr> :set nohls<cr>A
nnoremap <leader><leader>6 :s/\v^(#*)\s*<([^#]+)>\s*\1*$/###### \2 ######/<CR> :set nohls<cr>
inoremap <leader><leader>6 <esc>:s/\v^(#*)\s*<([^#]+)>\s*\1*$/###### \2 ######/<cr> :set nohls<cr>A

  vnoremap <leader>t :call <SID>table()<cr>
  function! s:table() range
     exe "'<,'>Tab /<bar>"
     let hsepline= substitute(getline("."),'[^|]','-','g')
     exe "norm! o" .  hsepline
     exe "'<,'>s/-|/ |/g"
     exe "'<,'>s/|-/| /g"
     exe "'<,'>s/^| \\|\\s*|$\\||//g"
  endfunction
" }}}
" MRU {{{
let MRU_File=expand("~/.vim_mru_files")
let MRU_Max_Entries = 30
" }}}
" }}}

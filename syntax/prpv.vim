" Vim syntax file
" Language: Properties syntax
" Maintainer: Peter Brown
" Latest: 

if exists("b:current_syntax")
    finish
endif


syntax keyword prpvTodo    contained TODO FIXME XXX NOTE

syntax match   prpvBegin   display '^'
                         \ nextgroup=prpvToken,prpvComment skipwhite

syntax match   prpvToken   contained display '[^=]\+'
                         \ nextgroup=prpvTokenEq skipwhite

syntax match  prpvTokenEq  contained display '=' 
                         \ nextgroup=prpvVar1,prpvVar2,prpvValue skipwhite

syntax match prpvInclude   display "^@.*$"

syntax match prpvComment   "\v#.*$" 
                         \ contains=prpvTodo

syntax match prpvLabel     "\v::.*$" skipwhite

syntax region   prpvValue  contained display oneline 
                         \ contains=prpvVar1, prpvVar2
                         \ matchgroup=prpvValue start='\S'
                         \ matchgroup=Normal end='\s*$'

syntax region  prpvVar1     contained display oneline 
                         \ start=':<:'hs=e+1
                         \ end=':>:'he=s-1

syntax region  prpvVar2   contained display oneline 
                         \ start='%<%'hs=e+1
                         \ end='%>%'he=s-1


" syntax region prpvStatement


highlight link prpvTodo     Todo
highlight link prpvComment  Comment
highlight link prpvToken    Identifier
highlight link prpvTokenEq  Operator
highlight link prpvValue    Ignore
highlight link prpvLabel    Underlined
highlight link prpvInclude  PreProc
highlight link prpvVar1     Type
highlight link prpvVar2     Statement 

let b:current_syntax = "prpv"

" NBNCo splunk-xml tidy functions {{{

" Desc: Utility functions for formatting NBNCo messages taken from splunk
" Author: Peter Brown
" Date: 14 November 2012
"
" Modified: 9 Dec 2012 - Added function to process XML export - PB

" These are utility functions for dumping splunk logs into Vim and then
" reformatting them into nicely structured, syntax-highlighted xml This makes it
" easier to visually inspect and analyse the contents of IB2B audit messages 

" Note that both these functions require the presence of xmllint in the path of
" the machine on which Vim is running

" To install this plugin simply copy it into 
" your ~/.vim/plugins folder and restart Vim

" Library functions

function! Remove_tabs()
    " First remove any tabs
    execute "normal! :%" . 's/\v\t/  /g' . "\<cr>"
endfunction

function! Join_lines_raw()
    " Next join the lines for the _raw field together
    execute "normal! :g" . '/\vfield k\=''_raw/.,/\vfield\>$/' . " j! \<cr>"
endfunction

function! Remove_lines_except_raw()
    " Now remove all other lines except the _raw field
    execute "normal :v" .'/\vfield k\=''_raw/' . "d \<cr>"
endfunction

function! Remove_splunk_junk_xml()
    " Remove initial xml junk from splunk
    execute "normal :%" . 's/\v^\s*\<field k\=''_raw''\>\<[^\>]+\>//' . "\<cr>"
    " Remove trailing xml junk from splunk
    execute "normal :%" .'s/\v\zs\<.v\>\<.field\>\s*$//' . "\<cr>"
endfunction

function! Convert_from_encoded_xml()
    " Now convert the encoded XML char to real XML char
    execute "normal :%" . 's/\v\&amp;/\&/g' . "\<cr>"
    execute "normal :%" . 's/\v\&quot;/"/g' . "\<cr>"
    execute "normal :%" . 's/\v\&gt;/>/g' . "\<cr>"
    execute "normal :%" . 's/\v\&lt;/</g' . "\<cr>"
endfunction

function! Remove_xml_start_tags()
    " Remove the <?xml...?> tags from each line
    execute "normal! :%" . 's/\v\<\?xml.{-}\?\>\s?//ge' . "\<cr>"
endfunction

function! Create_header_comment()
    " Create xml comment for header and place header xml on own line
    " 
    " First take care of any lines that are missing the HEADER marker
    execute "normal :g!/HEADER/" . 's/\v^(.*)(MESSAGE.*$)/<!-- \1 -->\r\2/e' . "\<cr>"
    " Take care of lines MED_ServiceProxy lines
    execute "normal :%" . 's/\v^(.*null.*MED_ServiceProxy.*)(\<p:.*$)/<!-- \1 -->\r\2/e' . "\<cr>"
    " Now split the HEADER from the MESSAGE where you have a HEADER - MESSAGE
    " pair
    execute "normal! :%" . 's/\v^HEADER\s+\[\s*(\<.{-}\s*\>)\s*\]\s*/<!-- HEADER -->\r\1\r/e' . "\<cr>"
endfunction

function! Create_comment_for_message()
    " Create xml comment for MESSAGE
    execute "normal! :%" . 's/\v^MESSAGE\s+\[\s*(\<.{-}\>)\s?\]\s{1,}/<!-- MESSAGE -->\r\1\r/e' . "\<cr>"
endfunction

function! Create_comment_for_channel()
    " Comment out the final channel line
     execute "normal! :%" . 's/\v^([A-Z\-]+\s.*$)/<!-- \1 -->/e' . "\<cr>"
endfunction

function! Remove_highlight_tags()
    " Remove splunk's hightlight markup if it exists
    execute "normal! :%" . 's/\v\<\/*sg[^\>]*\>//ge' . "\<cr>"
endfunction

function! Wrap_in_splunk_tags()
    " Step 7 : add start and end tags to entire sequence of messages
    execute "normal! ggi<splunk>\r\eGo</splunk>\e \<cr>"
endfunction

function! Format_as_xml()
    " Finally parse the file through xmllint to make it all pretty
    execute "normal! ggO<splunk>\<esc>Go</splunk>\<esc>"
    execute "normal! ggVG:!xmllint --format --recover - 2>/dev/null \<cr>"
    set filetype=xml
    set nowrap
endfunction


function! Splunk_transaction_to_xml()
    " Parse and NBNCo XML transaction history 
    " which has been copied from the transaction viewer
    " panel and comment out the non-xml data using xml style comments
    " this allows the file to then be sent to xmltidy for
    " correct indentation
    :execute "normal! :%" . 's#\v^([\t ]*\d+.*[^\>])$#<!--  \1  -->#' . "\<cr>"
    :execute "normal! :%" . 's#\v^([\t ]*\d+.{-})\@=\<p#<!--   \1   -->\r<p#' . "\<cr>"
    
    " add start and end tags to entire sequence of messages
    execute "normal! ggi<splunk>\r\eGo</splunk>\e"

    " Now return
    execute "normal! <cr>"
    
    " Finally parse the file through xmllint
    execute "normal! ggVG:!xmllint --format --recover - 2>/dev/null \<cr>"

    " Set filetype = xml to activate syntax highlighting
    set filetype=xml
    set nowrap
endfunction

function! Splunk_clean_csv()
    " This function will clean up a CSV export from splunk
    silent! global/^"/.,/^\].*"$/j
    silent! %s/\>","/    /g
    silent! %s/^"//g
    silent! %s/"$//g
    " CSV exports seem to escape XML characters so these need
    " to be converted back to regular xml syntax
    silent! %s/""/"/g
    silent! %s/\&quot;/"/g
    silent! %s/^"//g
    silent! %s/"$//g
    silent! %s/\&lt;/</g
endfunction

function! Splunk_audit_to_xml()
    " This function will reformat **IB2B.WPS.AUDIT** messages taken
    " from splunk into a valid xml structure. This makes it 
    " easier to inspect the payloads of IB2B messages from
    " splunk searches. The function assumes the _time and
    " _raw fields are taken from the table view in splunk
    
    call Remove_xml_start_tags()

    " Step 2: remove the initial datetime string 
    " (this is repeated several times in the message)
    execute "normal! :%" . 's/\v^(\d+\s+)\d+.{-}[PA]M\s/\1/e' . "\<cr>"

    " Step 3 : extract the header line - that is everything from the start of
    " the  line up to the word HEADER [ Wrap this in XML comment tags and place
    " it on a  line of its own 
    execute "normal! :%" . 's/\v^(\d+.*)(HEADER\s+)/<!-- \1 -->\r\2/' . "\<cr>"

    call Create_header_comment()
    call Create_comment_for_message()
    call Create_comment_for_channel()
    call Wrap_in_splunk_tags()
    call Format_as_xml()
endfunction

function! Splunk_xml_to_xml()
    " The objective of this function is to strip out all 
    " rows expect the _raw field.

    call Remove_tabs()
    call Join_lines_raw()
    call Remove_lines_except_raw()
    call Remove_splunk_junk_xml()
    call Convert_from_encoded_xml()

    " Extract the header line - that is everything from the start of
    " the  line up to the word HEADER [ Wrap this in XML comment tags and place
    " it on a  line of its own 
    execute "normal! :%" . 's/\v^(.*)(HEADER\s+)/<!-- \1 -->\r\2/e' . "\<cr>"

    call Remove_xml_start_tags()
    call Remove_highlight_tags()
    call Create_header_comment()
    call Create_comment_for_message()
    call Create_comment_for_channel()
    call Wrap_in_splunk_tags()
    call Format_as_xml()
endfunction

function! New_xml_parser()
    set ft=txt
    call Remove_tabs()
    execute "normal! gg :" . '0,/\vfield k\=''_raw/-1' . " delete \<cr>"
    execute "normal! G :" . '-?\vfield k\=''_time''?,$' . " delete \<cr>"
    execute "normal! gg :" . 'g/\vfield k\=''_time''/ .,/\vfield k\=''_raw''/-1' . " delete \<cr>"
    execute "normal! gg :%" . 's/\v\s*\<field k\=''_raw''\>\<v xml:space\=''preserve'' trunc\=''0''\>//' . " \<cr>"
    execute "normal! gg :%" . 's/<\/v><\/field>\s*$//' . "\<cr>"
    execute "normal! gg :" . 'g/\v^\<(\w+):(\w+)\s+.{-}\<\/\1:\2\>\zs(.*)$/\r<!-- \3 -->/' . "\<cr>"
    call Convert_from_encoded_xml()
    execute "normal! gg :" . 'g/\v^\]\s*$/' . " delete \<cr>"
    execute "normal! gg :" . 'g/\v^\]/s/\v^\]\W*(.*)$/<!-- \1 -->/' . "\<cr>"
    execute "normal! gg :" . 'g/\v^\[/s/\v(.*)$/<!-- \1 -->/' . "\<cr>"
    execute "normal! :%" . 's/\V [<?xml version="1.0" encoding="UTF-8"?>//' . "\<cr>"
    execute "normal! :%" . 's/\v^\<(\w+):(\w+)\s+.{-}\<\/\1:\2\>\zs(.+)$/\r<!-- \3 -->/' . " \<cr>"
    " call Remove_highlight_tags()
endfunction
    
" Setup shortcut mappings for these two functions
nnoremap <leader>stx :<c-u>call Splunk_transaction_to_xml()<cr>
nnoremap <leader>s2x :<c-u>call Splunk_audit_to_xml()<cr>
nnoremap <leader>sx2x :<c-u>call Splunk_xml_to_xml()<cr>
" }}}

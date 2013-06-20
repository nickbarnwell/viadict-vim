" viadict.vim - vim integration with OSX's Dictionary
" Author:       Nick Barnwell <http://ul.io>
" Version:      0.1


if exists("g:vd_loaded") || &cp || v:version < 700
  finish
endif
let g:vd_loaded = 1

if !exists("g:vd_buf_height")
  let g:vd_buf_height = 10
endif

function! s:set_vd_buf(var, val)
  call setbufvar(g:vd_buf, a:var, a:val)
endfunction

function! s:get_or_create_buffer()
  if !exists('g:vd_buf')
    let g:vd_buf = bufnr('viadict', 1)
    call s:set_vd_buf('&buftype', 'nofile')
    call s:set_vd_buf('&bufhidden', 'hide')
    call s:set_vd_buf('&swf', 0)
  endif

  return g:vd_buf
endfunction

function! viadict#ShowViadictBuffer()
  if bufnr('%') != s:get_or_create_buffer()
    execute "below sb " . g:vd_buf
    execute "resize " . g:vd_buf_height
    au! * <buffer> 
    au BufLeave <buffer> hide 
    call s:set_vd_buf('&ro', 0)
    execute "%d"
  endif
endfunction

function! viadict#Viadict(word, thesaurus)
  call viadict#ShowViadictBuffer()
  
  if a:thesaurus
    execute "0r ! viadict -t " . a:word 
  else 
    execute "0r ! viadict " . a:word 
  endif

  call s:set_vd_buf('&ro', 1)
  normal! gg
endfunction

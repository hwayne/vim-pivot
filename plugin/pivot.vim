" pivot.vim - Quickly pivot arguments and text around characters.
" Maintainer: Hillel Wayne
" Version: 0.0.0
" Date: Now

if exists("g:loaded_pivot") || &cp
    finish
endif
let g:loaded_pivot = 1
let s:save_cpo = &cpo
set cpo&vim

" Utility functions {{{
function! s:getchar()
  let c = getchar()
  if c =~ '^\d\+$'
    let c = nr2char(c)
  endif
  return c
endfunction

function! s:inputtarget()
  let c = s:getchar()
  while c =~ '^\d\+$'
    let c .= s:getchar()
  endwhile
  if c == " "
    let c .= s:getchar()
  endif
  if c =~ "\<Esc>\|\<C-C>\|\0"
    return ""
  else
    return c
  endif
endfunction

function! s:redraw()
  redraw
  return ""
endfunction
" }}}

" Main pivot function {{{
function! Pivot()

 "startup: save a bunch of the buffers we're going to be using
 let swap_register_1 = @a
 let swap_register_2 = @b
 let save_mark = getpos("'a")
 let back_mark = getpos("'b")
 let pairdict_nested = {'(': ')', '{': '}', '[': ']', '<': '>', ')': '(', '}': '{', ']': '[', '>': '<'}
 let pairdict = {'w': 'b', 'W': 'B', 'b': 'w', 'B': 'W'}
 execute "normal! ma"
 
 
 let s:bknd = s:inputtarget()
 let front_spaces = 0
 let rear_spaces   = 0
 if 1| "bknd ==# "W"
     while getline('.')[col('.')+front_spaces] == " "
         let front_spaces += 1
     endwhile
     while getline('.')[col('.')-rear_spaces] == " "
         let rear_spaces += 1
     endwhile
     execute "normal! bmb\"ayi".s:bknd."`a"| "go back, mark, yank work, return
     execute "normal! w\"bdi".s:bknd."\"aP`b"| "go forward, replace word, jump to previous
     execute "normal! \"adi".s:bknd."\"bP`a"| "replace word, return
    
     
 endif
 
 "cleanup: reset all of the buffers and marks to their original values
 let @a = swap_register_1 
 let @b = swap_register_2
 call setpos("'a", save_mark)
 call setpos("'b", back_mark)
endfunction

 " }}}

if !hasmapto('<Plug>Pivot')
    nnoremap <silent> <Plug>Pivot :call Pivot()<cr>
endif

nmap <leader>p <Plug>Pivot

let &cpo = s:save_cpo

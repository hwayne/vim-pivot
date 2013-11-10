" pivot.vim - Quickly pivot arguments and text around characters.
" Maintainer: Hillel Wayne
" Version: 0.1.0
" Date: 11/9/13

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

 "We make this accessible to both pivot and auxilary
 let s:match_char = {']': '[', '}': '{', ')': '(', '>': '<',
             \       '[': ']', '{': '}', '(': ')', '<': '>',}

" Find matching paren, accounting for nesting {{{
function! s:Findparen(type, movement)
     let s:s = "a"
     while s:s != s:match_char[a:type]
         "sanity check in case of no matches on line
         if col('.') == 1 || col('.') == col('$')
             return
         endif

         if s:s == a:type "we've entered a nested level
             execute 'normal! %' |"skip the nest
         endif
         execute "normal! ".a:movement| "step off
         let s:s = getline('.')[col('.')-1]
     endwhile
endfunction
" }}}

" Main pivot function {{{
function! Pivot()

 "startup: save a bunch of the buffers we're going to be using
 if getreg('a') != "" | let swap_register_1 = @a | endif
 if getreg('a') != "" | let swap_register_2 = @b | endif
 let save_mark = getpos("'a")
 let back_mark = getpos("'b")
 let s:valid_chars  = {'w': 'w', 'b': 'w', 'e': 'w', 'ge': 'w', 'W': 'W', 'B': 'W', 'E': 'W',
             \ '$': '$', '^': '$', 'L': '$', 'H': '$', 'p': '$',
             \ '[': ']', ']': ']', '(': ')', ')': ')', '{': '}', '}': '}', '<': '>', '>': '>'}


 execute "normal! ma"
 
 let s:bknd = get(s:valid_chars, s:getchar(), "")
 if s:bknd == ""
     return
 endif

 if "w" ==? s:bknd
     execute "normal! bmb\"ayi".s:bknd."`a"| "go back, mark, yank work, return
     execute "normal! w\"bdi".s:bknd."\"aP`b"| "go forward, replace word, jump to previous
     execute "normal! \"adi".s:bknd."\"bP`a"| "replace word, return
 elseif "$" ==? s:bknd
     execute "normal! gelmb\"ay^`a"| "grab first half of line, move one ahead to get ^ right
     execute "normal! w\"bd$\"aP`b"| "replace end with beginning
     execute 'normal! "ad^"bP`a'| "replace beginning
 else "It's a nesting object
     "we need special nesting marks to pull this off
     let save_lparen_mark = getpos("'y")
     let save_rparen_mark = getpos("'z")
     
     "get left paren
     call s:Findparen(s:bknd, 'h')
     execute 'normal! lmy`a"ay`y`a'| "fix OBOE, head back home, yank to parenthesis

     "get right paren
     call s:Findparen(s:match_char[s:bknd], 'l')
     execute 'normal! mz`al"bd`z"aP`a'| "delete the front side, replace with back, head home

     execute 'normal! "ad`y"bP'| "delete back

     call setpos("'y", save_lparen_mark)
     call setpos("'z", save_rparen_mark)
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

vim-pivot
=========

Lets you swap text elements around a pivot, eg (a,b) -> (b,a). Still hella buggy.

Use
---

Pivot maps to <leader>p. Currently it works with w, W, $, and braces. It takes the first element in front of the cursor and the first element behind and swaps them. For example, assuming <leader> is ',':

* ,pw will map _f(a,b)_ -> _f(b,a)_ if the cursor is over the ','
* ,pw will map _@a = var1_ -> _@var1 = a_ if the cursor is over the '='
* ,pW will map _@a = var1_ -> _var1 = @a_ if the cursor is over the '='
* ,p$ will map _a + b = c + d_ -> _c + d = a + b_ if the cursor is over '='

Braces work a little differently. They pivot everything inside the braces, and they'll account for nesting. For example:

* ,p) will map _[a,b+c]_ -> _[b+c,a]_ if cursor is over ','
* ,p] will map _f(a,g(b+c))_ -> _f(g(b+c),a)_ if cursor is over ','. It skips the first set of parenthesis as nested.

TODO
----

* Write a comprehensive docfile
* Fix whitespace issues with pivoting in braces
* Make cursor return to pivot after pivoting without using a weird control character hack
* Add support for numbers, so ,p2w will pivot two words
* Add more mappings
* Fix more corner cases
* Add generalized motion support (this will not happen)

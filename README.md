vim-pivot
=========

Let's you swap text elements around a pivot, eg (a,b) -> (b,a). Still hella buggy.

Use
---

Pivot maps to <leader>p. Currently it works with w, W, $, and braces. It takes the first element in front of the cursor and the first element behind and swaps them. For example:

* ,pw will map f(a,b) -> f(b,a) if the cursor is over the ','
* ,pw will map @a = var\_1 -> @var\_1 = a if the cursor is over the '='
* ,pW will map @a = var\_1 -> var\_1 = @a if the cursor is over the '='
* ,p$ will map a + b = c + d -> c + d = a + b if the cursor is over '='

Braces work a little differently. They pivot everything inside the braces, and they'll account for nesting. For example:

* ,p) will map [a,b+c] -> [b+c,a] if cursor is over ','
* ,p] will map f(a,g(b+c)) -> f(g(b+c),a) if cursor is over ','. It skips the first set of parenthesis as nested.

TODO
----

* Write a comprehensive docfile
* Fix whitespace issues with pivoting in braces
* Make cursor return to pivot after pivoting
* Add support for numbers, so ,p2w will pivot two words
* Add more mappings
* Fix more corner cases
* Add generalized motion support (this will not happen)

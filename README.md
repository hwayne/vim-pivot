vim-pivot
=========

Let's you swap text elements around a pivot, eg (a,b) -> (b,a). Still hella buggy.

Use
---

Pivot maps to <leader>p. Currently it works with w and W. It takes the first element in front of the cursor and the first element behind and swaps them. For example:

* ,pw will map f(a,b) -> f(b,a) if the cursor is over the ','
* ,pw will map @a = var\_1 -> @var\_1 = a if the cursor is over the '='
* ,pW will map @a = var\_1 -> var\_1 = @a if the cursor is over the '='


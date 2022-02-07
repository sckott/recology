---
name: python-notes
layout: post
title: "Notes on Python"
date: 2022-02-07
author: Scott Chamberlain
sourceslug: _posts/2022-02-07-python-notes.md
tags:
- python
---

It's been interesting switching jobs with respect to programming languages. I used to write 95% R - now I write 95% Python. 

I have been using Python for many years, but not seriously or getting paid either. I've learned alot in the first 6 months.

Some Python things learned:


## Functions and methods

I used to think functions and methods were the same thing. But during the last 6 months I learned that functions and methods are not the same. Well, they're not that different. A function outside a class is just called a [function][] while a function inside a class is called a [method][].  They could be exactly the same and do the same thing, but one is outside a class and the other inside a class.

```python
class Stuff(object):
  def things():
    return 5

def things():
    return 5

Stuff.things()
# 5
things()
# 5
```


## .sort and sorted

`.sort` called on an object changes the object in place and `sorted()` creates a new object.

```python
x = [4,1,7,2,6,5,3]
z = x.sort()
# nothing returned, z = None
sorted(x)
# [1, 2, 3, 4, 5, 6, 7]
```

## context managers

I'd surely used a [context manager][] in Python before but didn't realize what was happening. The code base I work in uses many [with][] statements and these are used with context managers like:

```python
with EXPRESSION as TARGET:
    SUITE
```

In the above case I often create a connection to a database using the `with` statement, then once the block is exited, the connection is cleaned up.

## imports

Coming from R, it's so nice in Python to be able to import specific functions, classes, etc. rather than having to load an entire file or package in R. In addition, `as` in Python imports is really nice to have.

Python

```python
from x import y
import pandas as pd
```

R

```r
require(x)
library(x)
```

Sometimes I run into circular import issues in Python (as I did in R), which I've yet to find a neat solution to sorting out.


[function]: https://docs.python.org/3/glossary.html#term-function
[method]: https://docs.python.org/3/glossary.html#term-method
[context manager]: https://docs.python.org/3/glossary.html#term-context-manager
[with]: https://docs.python.org/3/reference/compound_stmts.html#with

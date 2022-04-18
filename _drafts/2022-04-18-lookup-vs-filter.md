---
name: lookup-vs-filter
layout: post
title: "List comprehension vs. filter vs. key lookup"
date: 2022-04-18
author: Scott Chamberlain
sourceslug: _drafts/2022-04-18-lookup-vs-filter.Rmd
tags:
- python
---



I was working on a work task last week, and needed to filter out one instance of a class from a list of class instances. No matter how you do this speed doesn't matter too much if you're doing this operation once or a few times. 

However, I this operation needs to be done about 100K times each time the script runs - so speed definitely does matter in this case. 

First, I naively started off with using `filter()`. When that lead to waiting more than ten minutes, I read that list comprehensions are faster. 

Second, I tried list comprehensions. Also waited more then ten minutes and gave up again. 

Last, I thought perhaps it would work to make a dictionary where the keys are the things I need to filter on and the values the class instances. This was the answer! Super fast. 

Now some examples of what I'm talking about. 


Make a class called `Stuff`. 


```python
class Stuff:
  def __init__(self, letter):
    self.letter = letter
    super(Stuff, self).__init__()
  def __repr__(self):
        return "<{} ({})>".format(self.__class__.__name__, self.letter)

x = Stuff('s')
x
#> <Stuff (s)>
x.letter
#> 's'
```

Make a list of instances of the class `Stuff`


```python
import string

lst = []
for x in string.ascii_lowercase:
    lst.append(Stuff(x))
lst
#> [<Stuff (a)>, <Stuff (b)>, <Stuff (c)>, <Stuff (d)>, <Stuff (e)>, <Stuff (f)>, <Stuff (g)>, <Stuff (h)>, <Stuff (i)>, <Stuff (j)>, <Stuff (k)>, <Stuff (l)>, <Stuff (m)>, <Stuff (n)>, <Stuff (o)>, <Stuff (p)>, <Stuff (q)>, <Stuff (r)>, <Stuff (s)>, <Stuff (t)>, <Stuff (u)>, <Stuff (v)>, <Stuff (w)>, <Stuff (x)>, <Stuff (y)>, <Stuff (z)>]
len(lst)
#> 26
```

List comprehension: This is how I did the list comprehension method. Filter the list `lst` where some attibute matched some value. 


```python
[x for x in lst if x.letter == 'f']
#> [<Stuff (f)>]
```

Filter: This is how I did the filter method. Filter the list `lst` where some attibute matched some value. 


```python
list(filter(lambda x: x.letter == 'f', lst))
#> [<Stuff (f)>]
```

And here's the dictionary approach. Here, I first make a dictionary via `dict(zip())` where the keys are some attribute of each instance. You can lookup by key.

A major difference/drawback of this approach is that it only works if there's only one match per key because dictionaries don't allow duplicate keys. 


```python
lst_map = dict(zip([w.letter for w in lst], lst))
lst_map['f']
#> <Stuff (f)>
```

And better yet, use `.get()` so you don't run into a `KeyError` when the key doesn't exist


```python
lst_map.get('f')
#> <Stuff (f)>
lst_map.get('5')
#> (returns None)
```

What about the timings:




```python
from timeit import timeit
n = 100000
time_list_comp = timeit("[x for x in lst if x.letter == 'f']", number=n, globals=globals())
time_filter = timeit("list(filter(lambda x: x.letter == 'f', lst))", number=n, globals=globals())
time_dict = timeit("lst_map['f']", number=n, globals=globals())
time_dict_get = timeit("lst_map.get('f')", number=n, globals=globals())

round(time_list_comp, 3)
#> 0.088
round(time_filter, 3)
#> 0.134
round(time_dict, 3)
#> 0.002
round(time_dict_get, 3)
#> 0.003
```

For bracketed lookup, the list comprehension is **39** times slower, and the filter is **59** times slower.

For the `get()` lookup, the list comprehension is **26** times slower, and the filter is **39** times slower.


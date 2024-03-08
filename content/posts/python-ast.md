---
name: python-ast
layout: post
title: "Python, ast, and redbaron"
date: 2023-04-18
author: Scott Chamberlain
sourceslug: _drafts/2023-04-18-python-ast.Rm
tags:
- python
- programming
- ast
---



I recently had a use case at work where I wanted to check that file paths given in a Python script actually existed. These paths were in various GitHub repositories, so all I had to do was pull out the paths and check if they exist on GitHub.

There were a few catches though.

First, I couldn't simply get any string out of each Python script - they needed to be strings specficied by a specific function parameter, and match a regex (e.g., start with 'abc').

Second, the script paths lack the GitHub repository root name. This name was part of the function name - so I needed to get access to the function that the path was specified within, and then parse the function name to get the repository name.

The obvious solution I thought was the [ast][pyast] library.

## ast library

I started by using `ast`. The `ast.NodeVisitor` class seemed like it would do the trick.

An example script ("my_script.py"):

```python
def hello(path, stuff=None):
    return path


if __name__ == "__main__":
    print(hello(path="hello/world.py", stuff="hello mars"))
```


```python
import ast

class CollectStrings(ast.NodeVisitor):
    def visit_Module(self, node):
        self.out = set()
        self.generic_visit(node)
        return list(filter(lambda w: w.startswith("hello") and w.endswith(".py"), self.out))

    def visit_Str(self, node):
        self.out.add(node.s)

file = "my_script.py"
with open(file, "r") as f:
    body = ast.parse(f.read())

coll = CollectStrings()
coll.visit(body)
## ['hello/world.py']
```

That worked great at fetching paths - only because all the paths I was looking for started with the same text and all have the same file extension. 

HOWEVER - I also needed the function name that the `path` argument was called from. I tried to make this work with `ast.NodeVisitor` but couldn't get it to work. 

I eventually got frustrated enough and figured there must be some libraries that build on top of `ast` that make it easier to work with ast's in Python. 

## redbaron

Enter [redbaron][]. I found this library pretty quickly upon searching for a library building on top of `ast`. 

Another example script ("their_script.py"):

```python
def hello(path, stuff=None):
    return path


def goodbye(path, stuff=None):
    return path


def world():
    path_str = hello(path="src/world.py", stuff="hello mars")
    other_path_str = goodbye(path="src/world.py", stuff="hello saturn")

    return path_str, other_path_str


if __name__ == "__main__":
    print(world())
```



```python
import re
from redbaron import RedBaron

file = "their_script.py"
with open(file, "r") as src:
  red = RedBaron(src.read())

red
## 0   def hello(path, stuff=None):
##         return path
##     
##     
##     
## 1   def goodbye(path, stuff=None):
##         return path
##     
##     
##     
## 2   def world():
##         path_str = hello(path="src/world.py", stuff="hello mars")
##         other_path_str = goodbye(path="src/world.py", stuff="hello saturn")
##     
##         return path_str, other_path_str
##     
##     
##     
## 3   if __name__ == "__main__":
##         print(world())
## 
```

Even just the resulting object you get from parsing something is useful:

And with `.help()` you get a very detailed map of the structure of the thing you're trying to navigate (only printing first 20 lines):


```python
red.help()
## 0 -----------------------------------------------------
## DefNode()
##   # identifiers: def, def_, defnode, funcdef, funcdef_
##   # default test value: name
##   async=False
##   name='hello'
##   return_annotation ->
##     None
##   decorators ->
##   arguments ->
##     * DefArgumentNode()
##         # identifiers: def_argument, def_argument_, defargument, defargumentnode
##         target ->
##           NameNode() ...
##         annotation ->
##           None
##         value ->
##           None
##     * DefArgumentNode()
##         # identifiers: def_argument, def_argument_, defargument, defargumentnode
...
```

Looking at the result from `red.help()` I can then use `.find_all()` to find certain nodes in the ast.


```python
nodes = red.find_all("AtomtrailersNode")
nodes = list(filter(lambda w: "hello" in w.dumps(), nodes))
nodes
## [hello(path="src/world.py", stuff="hello mars"), goodbye(path="src/world.py", stuff="hello saturn")]
```

Then I can write some okay code to extract out the function name, and ugly code to get the string supplied to the `path` parameter. Then f-string those together to get the path I'm after. 


```python
paths = []
for node in nodes:
    fxn_name = node.name.value
    command = re.search("src/.*\\.py", node.dumps()).group()
    paths.append(f"{fxn_name}/{command}")

for path in paths:
    print(path)
## hello/src/world.py
## goodbye/src/world.py
```

Not super proud of this but gets the job done for my use case - and when you're not making open source for others, you don't need to worry about other use cases :)

I'll definitely try to learn how to properly extract stuff using `redbaron` - but it got me to answer much faster than the `ast` library. 

[pyast]: https://docs.python.org/3/library/ast.html
[redbaron]: https://github.com/PyCQA/redbaron

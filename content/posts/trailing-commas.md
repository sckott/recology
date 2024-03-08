---
name: trailing-commas
layout: post
title: "trailing commas"
date: 2019-02-07
author: Scott Chamberlain
sourceslug: _posts/2019-02-07-trailing-commas.md
tags:
- R
- syntax
---

Let's talk about trailing commas (aka: "final commas", "dangling commas"). Trailing commas refers to a comma at the end of a series of values in an array or array like object, leaving an essentially empty slot. e.g., `[1, 2, 3, ]`

I kind of like them when I work on Ruby and Python projects. A number of advantages of trailing commas have been pointed out, the most common of which is diffs:

```diff
diff --git a/hello.json b/hello.json
index e36ffac..d387a2f 100644
--- a/hello.json
+++ b/hello.json
@@ -1,4 +1,5 @@
 [
   "foo": 5,
   "bar": 6,
+  "apple": 7,
 ]
diff --git a/world.json b/world.json
index 14a2818..41f8a01 100644
--- a/world.json
+++ b/world.json
@@ -1,4 +1,5 @@
 [
   "foo": 5,
-  "bar": 6
+  "bar": 6,
+  "apple": 7
 ]
```

Example blog posts on the topic: <https://dontkry.com/posts/code/trailing-commas.html>, <https://medium.com/@nikgraf/why-you-should-enforce-dangling-commas-for-multiline-statements-d034c98e36f8>

<br>

Many languages support trailing commas, and some even consider it best practice to use trailing commas.

## Ruby

```ruby
[ "hello", "world" ]
# => ["hello", "world"]
[ "hello", "world", ]
# => ["hello", "world"]
```

Works the same for hashes.


## Python

```python
[ "hello", "world" ]
# Out[1]: ['hello', 'world']
[ "hello", "world", ]
# Out[2]: ['hello', 'world']
```

Works the same for sets and dictionaries.

## Javascript

Mozilla gives a thorough overview of [trailing commas in Javascript](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Trailing_commas).

```javascript
[ "hello", "world" ]
// [ 'hello', 'world' ]
[ "hello", "world", ]
// [ 'hello', 'world' ]
```

Probably works for other data types...?

## Rust

https://users.rust-lang.org/t/trailing-commas/13993

```rust
[ "hello", "world" ]
// vs
[ "hello", "world", ]
```

Probably works for other data types...?

## Julia

https://users.rust-lang.org/t/trailing-commas/13993

```julia
( 1, 2 )
# (1, 2)
( 1, 2, )
# (1, 2)
```

works the same with arrays in Julia.

## others

Apparently others do as well: Perl, C#, Swift, etc ...

## Disagree

Some do not like trailing commas:

* [Trailing commas: good or bad practice? (TL;DR: it’s bad)](https://www.davidarno.org/2016/03/23/trailing-commas-good-or-bad-practice-tldr-its-bad/)

-----

## R

However, the main dev work I do is in R, which does not support trailing commas.

```r
c("hello", "world")
#> [1] "hello" "world
c("hello", "world", )
#> Error in c("hello", "world", ) : argument 3 is empty
```

The one caveat is that you will see trailing commas in subsetting procedures of lists, vectors, data.frames, matrices, e.g., 

```r
mtcars[1:3, ]
```

One blogger provides an [override to allow trailing commas](https://r-de-jeu.blogspot.com/2013/03/r-and-last-comma.html) though I'd imagine it's not a good idea to use as you probably don't want such fundamentally different behavior in your own R console compared to others.

I've not seen any discussion of trailing commas in R as a language feature, whether good, bad or otherwise. Doesn't mean it doesn't exist though :)

## Haskell

Like R, [doesn't allow trailing commas](https://www.joachim-breitner.de/blog/739-Avoid_the_dilemma_of_the_trailing_comma)! 

And in fact, allegedly (I don't use Haskell):

> Because it is much more common to append to lists rather than to prepend, Haskellers have developed the idiom of leading comma:

```haskell
  ( foo
  , bar
  , baz
  , quux
  )
```

## JSON

[Unfortunately for many people](https://www.reddit.com/r/programming/comments/6z0pfb/let_me_put_a_fucking_comma_there_goddamnit_json/) JSON [does not allow trailing commas](https://stackoverflow.com/questions/201782/can-you-use-a-trailing-comma-in-a-json-object?lq=1)

## see also: leading with commas

* <https://hackernoon.com/winning-arguments-with-data-leading-with-commas-in-sql-672b3b81eac9>
* <https://gist.github.com/isaacs/357981>
* <https://community.rstudio.com/t/leading-vs-trailing-commas-on-new-lines/6744/5>

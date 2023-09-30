---
name: ruby-ports-to-r
layout: post
title: "Notes on porting Ruby to R"
date: 2019-02-19
author: Scott Chamberlain
sourceslug: _posts/2019-02-19-ruby-ports-to-r.md
tags:
- R
- ruby
---

In doing a number of ports of Ruby gems to R ([vcr][], [webmockr][]), I've noticed a few differences between the languages that are fun to dive into, at least for me.

## monkey patching

Ruby has a nice thing where you can ["monkey patch"](https://en.wikipedia.org/wiki/Monkey_patch) classes/methods/etc. in other Ruby libraries. For example, lets say you have Ruby gems `foo` and `bar`. If `foo` has a method `hello`, you can override the `hello` method in `foo` with one from `bar`. AFAICT this is acceptable in gems on Rubygems.org and in general in the community.

Monkey patching is technically possible in R, but is not allowed in packages on CRAN (see `?assignInNamespace` help for the warnings), even though [there is some usage in CRAN packages](https://github.com/search?p=1&q=org%3Acran+assignInNamespace&type=Code). We can do this using `utils::assignInNamespace`. Let's say you have an R package `foo` and another R package `bar`. Here, we can assign a new `hello` method to the one already defined in `foo`:

```r
# the foo::hello method looks like
hello <- function() return("world!")
```

```r
# make a new hello method
hello2 <- function() return("mars!")
# override the hello method in foo
utils::assignInNamespace("hello", hello2, "foo")
```

Try it with any package. It's fun.

You can do this in a package, by using a `.onAttach` directive.

```r
.onAttach <- function(libname, pkgname) {
  utils::assignInNamespace("bar", bar, "foo")
}
```

Anyway, monkey patching isn't really a thing in R, so that makes it more difficult to port Ruby things to R. The inability to do this in R makes many things much harder. For example, in [vcr][] and [webmockr][] I couldn't simply override methods in http libraries they hook into, but have to make changes in the http libraries themselves to support the HTTP mocking - we get there in the end, but it takes much longer, though possibly safer?

## 0 (Ruby) vs. 1 (R) based indexing

Never hurts to keep repeating this.

## sequences

Ruby has the ability to construct numeric sequences with `..` and `...`, e.g.,

```ruby
# inclusive of second number
x = 1..3
x.to_a
=>  [1, 2, 3]
# exclusive of second number
x = 1...3
x.to_a
=>  [1, 2]
```

AFAIK, in R we can only do inclusive sequences

```r
1:3
#> [1] 1 2 3
```

## explicit imports

In at least Ruby and Python you have to be explicit about saying where to import methods from other files.

Whereas in R you can just use a function/etc. from any other file in the package without stating that you need it. This makes it harder to reason about the dependent functions/etc. needed in any one file. One tool that helps with this is [functionMap][] (though last commit in 2016, not sure if maintained anymore, is it Gábor?).

On a related note, in Ruby we can use global variables like:

```ruby
$foo = 5
```

From what I understand the above is bad pratice, but I do use them sometimes in my own Ruby stuff.

In R all variables/methods/classes are "global" within the namespace of the package.

## adding strings

ugh, I wish R had the ability to add strings together with `+`.

## ? as a valid character

um, yes please. I love methods in Ruby like `nil?`, `empty?`, etc. Such a straight-forward way to indicate intent. Wish we had these in R, but `?` isn't even a valid character on its own, so not (ever?) gonna happen.

## Classes

R's closest class system to Ruby (that I'm willing to use) is [R6](https://cran.rstudio.com/web/packages/R6/) from Winston Chang. Using `R6` makes it a bit easier to port from Ruby or a similar language as you can directly translate classes that have public vs. private methods, an initializer, print method, etc. Plus, with any sufficiently complex R package, using `R6` makes it much easier to manage the complexity.

## Ruby's ||= 

In ruby this operator means essentially "if a is undefined or falsey, evaluate b and set a to the result". In R there's AFAIK nothing like this. `||=` was used extensively in the Ruby gems I was porting, making the ported version in R more verbose. I could do in R `a %||% b` (where `%||% = function(x, y) if (is.null(x) || !x) y else x`) essentially doing "if a is null, undefined or falsey, evaluate b"; but then I have to still assign the result, giving `a = a %||% b`.

## splat args

The splat operator is used heavily in Ruby. It looks like:

```ruby
def foo(*args)
  p args
end
foo(1, 2, 3)
# => [1, 2, 3]
```

In R the most similar thing we have is the ellipsis, so 

```r
foo <- function(...) c(...)
foo(1, 2, 3)
#> [1] 1 2 3
```

Ruby splat args won't trip you up if you know how to do this conversion. Of course there's `rlang` and such in R as well.

[functionMap]: https://github.com/MangoTheCat/functionMap
[vcr]: https://github.com/ropensci/vcr
[webmockr]: https://github.com/ropensci/webmockr

---
name: ruby-and-r
layout: post
title: "Playing with Ruby Patterns in R"
date: 2018-01-25
author: Scott Chamberlain
sourceslug: _drafts/2018-01-25-ruby-and-r.Rmd
tags:
- R
- ruby
---



I was returning to a long-term project I've been working on - a package for caching HTTP requests in R called [vcr][rvcr], a port of the Ruby gem [vcr][] - when you do that thing you do when you are porting a library from one language to another. I stumbled upon some methods/functions I wasn't familiar with. 

For example, [take_while](https://apidock.com/ruby/Array/take_while) I had never seeen before. It iterates over an array, returning the elements of the array that evalulate to `true` (for those new to Ruby, they use `true` instead of `TRUE` as we do in R) when passed through the function given. R has lists and vectors - R's lists are the most similar to Ruby arrays because both can have mixed objects in them (e.g., a string and an integer) while still retaining those objects as is. 

In another example, I had never seen [unshift](https://apidock.com/ruby/Array/unshift) or it's sister [shift](https://apidock.com/ruby/v1_9_3_392/Array/shift). `unshift` is pretty simple - it prepends objects to the front of the array. `shift` has more complicated behavior - called without values passed deletes first element of the array, AND returns that deleted value. With `shift` you can also pass an index that is treated as a range (e.g., `1` is treated as `0` and `1`; Ruby has zero based indexing, unlike R's 1 based indexing). 

Anyway, I wanted to explore these new Ruby methods more by trying to implement them in R. Thus, started a bag of functions package called [rubfuns][] for "Ruby functions" to play while being able to have documentation, etc. 

It's entirely possible the stuff in `rubfuns` is already implemented in R elsewhere - the point is for me to learn more about both Ruby and R.

A big difference between Ruby and R is that Rubys's arrays have methods that can be called on them, e.g. 

```ruby
a = [1, 2, 3]
a.count
=> 3
```

Whereas the equivalent in R requires passing the vector to a method, rather than calling the method on the object itself


```r
a = c(1, 2, 3)
length(a)
#> [1] 3
```

Of course one could create a `R6` object in R and add methods to that object that can be called on a vector:


```r
library("R6")
Vec <- R6::R6Class(
  "Vec",
  public = list(
    x = NULL,
    initialize = function(x) {
      self$x <- x
    },

    count = function() length(self$x)
  )
)
```


```r
myvec <- Vec$new(1:3)
myvec$count()
#> [1] 3
```

But that's not baked into R itself, so not ideal.


Anyway, on with `rubfuns`:


```r
devtools::install_github("ropenscilabs/rubfuns")
```


```r
library("rubfuns")
```

`take_while` 


```r
x <- c(1, 2, 3, 4, 5, 0)
x %>% take_while(function(z) z < 3)
#> [1] 1 2 0
x <- c(1, 2, 3, 4, 9, -1)
x %>% take_while(function(z) z < 3)
#> [1]  1  2 -1
```

`drop_while` is a similar function to `take_while` but drops the elements that when passed to the supplied function evaluate to `TRUE`


```r
x <- c(1, 2, 3, 4, 5, 0)
x %>% drop_while(function(z) z < 3)
#> [1] 3 4 5
x <- c(1, 2, 3, 4, 9, -1)
x %>% drop_while(function(z) z < 3)
#> [1] 3 4 9
```

`delete_at` was in interesting function I saw in [vcr][]. It deletes the elements of an array at the positions given (remember, 0 based indexing in Ruby)


```r
x <- c(1, 2, 3, 4, 5, 0)
delete_at(x, 5)
#> [1] 1 2 3 4 0
delete_at(x, 4:5)
#> [1] 1 2 3 0
```

`delete_if` is similar to `delete_at` but instead you pass a function that when evaluates to `TRUE` deletes that element


```r
x <- c(1, 2, 3, 4, 5, 0)
delete_if(x, function(z) z > 2)
#> [1] 1 2 0
delete_if(x, function(z) z < 4)
#> [1] 4 5
```

`unshift` is quite simple. it prepends whatever you pass to it to the front of the vector


```r
x <- c(1, 2, 3)
x %>% unshift(4)
#> [1] 4 1 2 3
```


`shift` is more complicated. called without any values deletes the first element. called with a value deletes all elements up to and including that value


```r
x <- c(1, 2, 3)
x %>% shift
#> [1] 2 3
x %>% shift(2)
#> [1] 3
```


That's all I've got so far. Will likely add more functions as time goes on.


Unfortunately we can't follow what Ruby does by being able to modify the vector or list while also returning something. There are of course ways to achieve this, e.g., `R6` solution above or something like [zeallot][] - but if it's not baked into the R language it seems less likely to get wide adoption.

**todo**: plan to make sure the functions work with vectors and lists


[rvcr]: https://github.com/ropensci/vcr
[vcr]: https://github.com/vcr/vcr
[rubfuns]: https://github.com/ropenscilabs/rubfuns
[zeallot]: https://github.com/nteetor/zeallot

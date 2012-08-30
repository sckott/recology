---
name: making-matrices
layout: post
title: Making matrices with zeros and ones
date: 2012-08-30 08:02:00.00 -08:00
author: Scott Chamberlain
tags: 
- R
- matrix
- simulation
---


*********

## So I was trying to figure out a fast way to make matrices with randomly allocated 0 or 1 in each cell of the matrix. I reached out on Twitter, and got many responses (thanks tweeps!). 

*********

### Here is the solution I came up with. See if you can tell why it would be slow.

{% highlight r %}
mm <- matrix(0, 10, 5)
apply(mm, c(1, 2), function(x) sample(c(0, 1), 1))
{% endhighlight %}



{% highlight text %}
      [,1] [,2] [,3] [,4] [,5]
 [1,]    1    0    1    0    1
 [2,]    0    0    1    1    1
 [3,]    0    0    0    0    1
 [4,]    0    1    1    0    1
 [5,]    0    1    1    1    1
 [6,]    1    0    1    1    1
 [7,]    0    1    0    1    0
 [8,]    0    0    1    0    1
 [9,]    1    0    1    1    1
[10,]    1    0    0    1    1
{% endhighlight %}


*********

### Ted Hart (@distribecology) replied first with:

{% highlight r %}
matrix(rbinom(10 * 5, 1, 0.5), ncol = 5, nrow = 10)
{% endhighlight %}



{% highlight text %}
      [,1] [,2] [,3] [,4] [,5]
 [1,]    1    1    0    1    1
 [2,]    1    0    0    1    0
 [3,]    0    1    0    0    0
 [4,]    0    0    1    0    0
 [5,]    1    0    1    0    0
 [6,]    0    0    0    0    1
 [7,]    1    0    0    0    0
 [8,]    0    1    0    1    0
 [9,]    1    1    1    1    0
[10,]    0    1    1    0    0
{% endhighlight %}


*********


### Next, David Smith (@revodavid) and Rafael Maia (@hylospar) came up with about the same solution. 

{% highlight r %}
m <- 10
n <- 5
matrix(sample(0:1, m * n, replace = TRUE), m, n)
{% endhighlight %}



{% highlight text %}
      [,1] [,2] [,3] [,4] [,5]
 [1,]    0    0    0    0    1
 [2,]    0    0    0    0    0
 [3,]    0    1    1    0    1
 [4,]    1    0    0    1    0
 [5,]    0    0    0    0    1
 [6,]    1    0    1    1    1
 [7,]    1    1    1    1    0
 [8,]    0    0    0    1    1
 [9,]    1    0    0    0    1
[10,]    0    1    0    1    1
{% endhighlight %}


*********


### Then there was the solution by Luis Apiolaza (@zentree).

{% highlight r %}
m <- 10
n <- 5
round(matrix(runif(m * n), m, n))
{% endhighlight %}



{% highlight text %}
      [,1] [,2] [,3] [,4] [,5]
 [1,]    0    1    1    0    0
 [2,]    1    0    1    1    0
 [3,]    1    0    1    0    0
 [4,]    1    0    0    0    1
 [5,]    1    0    1    1    0
 [6,]    1    0    0    0    0
 [7,]    1    0    0    0    0
 [8,]    1    1    1    0    0
 [9,]    0    0    0    0    1
[10,]    1    0    0    1    1
{% endhighlight %}


*********

### Last, a solution was proposed using `RcppArmadillo`, but I couldn't get it to work on my machine, but here is the function anyway if someone can. 

{% highlight r %}
library(inline)
library(RcppArmadillo)
f <- cxxfunction(body = "return wrap(arma::randu(5,10));", plugin = "RcppArmadillo")
{% endhighlight %}


*********

### And here is the comparison of system.time for each solution. 

{% highlight r %}
mm <- matrix(0, 10, 5)
m <- 10
n <- 5

system.time(replicate(1000, apply(mm, c(1, 2), function(x) sample(c(0, 1), 1))))  # @recology_
{% endhighlight %}



{% highlight text %}
   user  system elapsed 
  0.470   0.002   0.471 
{% endhighlight %}



{% highlight r %}
system.time(replicate(1000, matrix(rbinom(10 * 5, 1, 0.5), ncol = 5, nrow = 10)))  # @distribecology
{% endhighlight %}



{% highlight text %}
   user  system elapsed 
  0.014   0.000   0.015 
{% endhighlight %}



{% highlight r %}
system.time(replicate(1000, matrix(sample(0:1, m * n, replace = TRUE), m, n)))  # @revodavid & @hylospar
{% endhighlight %}



{% highlight text %}
   user  system elapsed 
  0.015   0.000   0.014 
{% endhighlight %}



{% highlight r %}
system.time(replicate(1000, round(matrix(runif(m * n), m, n)), ))  # @zentree
{% endhighlight %}



{% highlight text %}
   user  system elapsed 
  0.014   0.000   0.014 
{% endhighlight %}


### If you want to take the time to learn C++ or already know it, the RcppArmadillo option would likely be the fastest, but I think (IMO) for many scientists, especially ecologists, we probably don't already know C++, so will stick to the next fastest options. 

*********

### Get the .Rmd file used to create this post [at my github account](https://github.com/SChamberlain/schamberlain.github.com/blob/master/_drafts/2012-08-30-making-matrices.Rmd).

*********

### Written in [Markdown](http://daringfireball.net/projects/markdown/), with help from [knitr](http://yihui.name/knitr/), and nice knitr highlighting/etc. in in [RStudio](http://rstudio.org/).
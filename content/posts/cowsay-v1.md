---
name: cowsay-v1
layout: post
title: "cowsay v1"
date: 2024-12-09
author: Scott Chamberlain
tags:
- R
- ascii
---

cowsay is a command line program written in Perl. The original version had a final release in 2016 (that's the version of many installed cowsay programs) and there's a number of forks of that release in Perl. There are also many many versions of cowsay in other programming languages, like [the one I maintain][cowsayr] written in R, unimaginatively called cowsay.

[I wrote about cowsay here back in 2014]({{< relref "cowsay" >}}). I didn't think this would ever be 300+ stars popular, but here we are. Given that people seem to actually use it - or at least star it - seems worth putting some more time into it.

## Return to the source

I just released v1 of cowsay. At a high level, the major thing in v1 is bringing it closer to the original cowsay. That doesn't mean in how it's used - you still use it within R, and pass arguments to a function rather than flags to a command line program. Instead, the output is as close as I could get to the original cowsay. This goal was spurred on by [an issue](https://github.com/sckott/cowsay/issues/67) - cough, sneeze - from 6 years ago.

The output of v1 is much closer to the original, for example:

in R cowsay before v1:

```
 -----
 hello world
 ------
    \   ^__^
     \  (oo)\ ________
        (__)\         )\ /\
             ||------w|
             ||      ||
```

Now in v1:

```
 ______________
< Hello world! >
 --------------
      \
       \

        ^__^
        (oo)\ ________
        (__)\         )\ /\
             ||------w|
             ||      ||
```

in Perl cli cowsay

```
 ______________
< Hello world! >
 --------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```

By much closer I mean:

1. Instead of just a top and bottom line there's actually sides now.
2. Fixed bubble top in GitHub main at least (see below note)
3. The bubble expands with the text to contain it all within the bubble, for example:


```r
library(cowsay)
library(fortunes)
say("fortune")
```

```
 ________________________________________________________
/ The problem, as always, is what the heck does one mean \
| by 'outlier' in these contexts. Seems to be like       |
| pornography -- "I know it when I see it."  Berton      |
| Gunter quoting Justice Potter Stewart in a discussion  |
\ about tests for outliers R-help April 2005             /
 --------------------------------------------------------
      \
       \

        ^__^
        (oo)\ ________
        (__)\         )\ /\
             ||------w|
             ||      ||
```


A few notes:

1. I realized in drafting this post that original cowsay uses underscores for the top of the bubble and hyphens for the bottom of the bubble whereas R cowsay was using hyphens for top and bottom. I just pushed a fix for this, so to get underscores for the bubble top install from GitHub (`pak::pak("sckott/cowsay")`).
2. With the refactoring of bubbles in v1, the "tail" is now above the animals b/c it was just easier that way. In a future version we'll try to fix that to have the tail coming down farther like original cowsay.

The other thing that brings R cowsay closer to og cowsay is having `think()`, which I hadn't realized was a thing until finding the page in the Wayback Machine for the original cowsay. For example:

```r
library(cowsay)
library(fortunes)
think("fortune")
```

```
 ________________________________________________________
( Dear Uwe, thank you very much for your unvaluable time )
( and effort.  Javier Cano thanking Uwe Ligges for       )
( solving a coding problem R-help July 2009              )
 --------------------------------------------------------
      o
       o

        ^__^
        (oo)\ ________
        (__)\         )\ /\
             ||------w|
             ||      ||
```

`think()` differs from `say()` in having circles for the tail to the bubble and parens for the bubble sides rather than slashes.

## Hand-rolled

With v1 you can now hand roll cowsay output, for example:

```r
library(cowsay)
library(fortunes)
quote <- as.character(fortune())
chicken <- animals[["chicken"]]
z <- paste(
  c(bubble_say(quote), bubble_tail(chicken, "\\"), chicken),
  collapse = "\n"
)
cat(z)
```

```
 _______________________________________________________
/ This is a bit like asking how should I tweak my       \
| sailboat so I can explore the ocean floor.            |
| Roger Koenker                                         |
| in response to a question about tweaking the quantreg |
| package to handle probit and heckit models            |
| R-help                                                |
\ May 2013                                              /
 -------------------------------------------------------
      \
       \
         _
       _/ }
      `>' \
      `|   \
       |   /'-.     .-.
        \'     ';`--' .'
         \'.    `'-./
          '.`-..-;`
            `;-..'
            _| _|
            /` /` [nosig]
```

A note about the refactored bubbles and tails: The tail horizontal position is now calculated based on the animal - so instead of always being in the same horizontal position, we attempt to place the tail close to the head of the animal.


## Fin

Have fun!


[cowsayr]: https://github.com/sckott/cowsay/
[docs]: https://sckott.github.io/cowsay/
[cowsaycran]: https://cran.r-project.org/web/packages/cowsay/index.html
[releasenotes]: https://github.com/sckott/cowsay/releases/tag/v1.0.0

---
name: cowsay
layout: post
title: cowsay - ascii messages and warnings for R
date: 2014-02-20
author: Scott Chamberlain
sourceslug: _drafts/2014-02-20-cowsay.Rmd
tags:
- R
- API
- ascii
---

## The history

Cowsay is a terminal program that generates ascii pictures of a cow saying what you tell the cow to say in a bubble. See the Wikipedia page for more information: <https://en.wikipedia.org/wiki/Cowsay> - Install cowsay to use in your terminal (on OSX):

```
brew update
brew install cowsay
```

Type `cowsay hello world!`, and you get:

```
 ______________
< hello world! >
 --------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```

Optionally, you can install [fortune](https://en.wikipedia.org/wiki/Fortune_(Unix)) to get pseudorandom messages from a database of quotations. On OSX do `brew install fortune`, then you can pipe a fortune quote to `cowsay`:

```
fortune | cowsay
```

And get something like:

```
 ______________________________________
/ "To take a significant step forward, \
| you must make a series of finite     |
| improvements." -- Donald J. Atwood,  |
\ General Motors                       /
 --------------------------------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```

You can also get different animals. Try `cowsay -f tux <yourmessage>`

## Cowsay in R

Why cowsay for R?  Why not. You never know what you will learn in fun side projects. Basically, this cowsay R package we are making prints messages that you pass to the function `say`.  There are three arguments to the `say` function:

* __what__: What do you want to say?  You can pass it a custom message, anything you want, like _what's up_, or _howdy!_. You can also get R's version of fortunes, quotes about R. Just pass the exact term _forture_. If you want a fact about cats from the [Cat Facts API](https://catfacts-api.appspot.com/), pass in _catfact_. Last, you can get the current time by passing _time_ to this parameter.
* __by__: Type of animal, one of cow, chicken, poop, cat, ant, pumpkin, ghost, spider, rabbit, pig, snowman, or frog. If you want more animals, send a pull request, or ask and at some point it will be added. 
* __type__: One of message (default), warning, or string (returns string). You could use string to pass into other functions, etc., instead of printing a warning or message.

There are three other contributors so far (a big thanks to them):

* Tyler Rinker
* Thomas Leeper
* Noam Ross

### Installation


```r
library(devtools)
install_github("cowsay", "sckott")
```



```r
library(cowsay)
```


p.s. or `install_github("sckott/cowsay")` if you have a newer version of devtools

### Get time


```r
say("time")
```

```

 ----- 
 2014-02-20 14:15:35 
 ------ 
    \   ^__^ 
     \  (oo)\ ________ 
        (__)\         )\ /\ 
             ||------w|
             ||      ||
```



```r
say("time", "chicken")
```

```


 ----- 
 2014-02-20 14:15:35 
 ------ 
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
            /` /`
  
```


### Vary type of output, default calls message


```r
say("hello world")
```

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



```r
say("hello world", type = "warning")
```

```
Warning: 
 ----- 
 hello world 
 ------ 
    \   ^__^ 
     \  (oo)\ ________ 
        (__)\         )\ /\ 
             ||------w|
             ||      ||
```



```r
say("hello world", type = "string")
```

```
[1] "\n ----- \n hello world \n ------ \n    \\   ^__^ \n     \\  (oo)\\ ________ \n        (__)\\         )\\ /\\ \n             ||------w|\n             ||      ||"
```


### Catfacts!!!!

From the [catfacts API](https://catfacts-api.appspot.com/), we can get random cat facts. If you put in _catfact_ you by default get a cat saying it. 


```r
say("catfact", "cat")
```

```


 ----- 
 Neutering a cat extends its life span by two or three years. 
 ------ 
    \   
     \  
               \`*-.
                 )  _`-.                 
                .  : `. .                
                : _   '                 
                ; *` _.   `*-._          
                `-.-'          `-.       
                  ;       `       `.     
                  :.       .       \
                  .\  .   :   .-'   .   
                  '  `+.;  ;  '      :   
                  :  '  |    ;       ;-. 
                  ; '   : :`-:     _.`* ;
               .*' /  .*' ; .*`- +'  `*' 
               `*-*   `*-*  `*-*'        
    
```


### R fortunes


```r
say("fortune")
```

```

 ----- 
 If I were to be treated by a cure created by stepwise regression, I would prefer voodoo.
 Dieter Menne
 in a thread about regressions with many variables
 R-help
 October 2009 
 ------ 
    \   ^__^ 
     \  (oo)\ ________ 
        (__)\         )\ /\ 
             ||------w|
             ||      ||
```



```r
say("fortune", "pig")
```

```


 ----- 
 Cross posting is sociopathic.
 Roger Koenker
 NA
 R-help
 November 2008 
 ------ 
    \   
     \  
       _//| .-~~~-.
     _/oo  }       }-@
    ('')_  }       |
     `--'| { }--{  }
          //_/  /_/
  
```


### Incorporate into a function

Define a function


```r
foo <- function(x) {
    if (x < 5) 
        say("woops, x should be 5 or greater")
}
```


Call the function, with an error on purpose


```r
foo(3)
```

```

 ----- 
 woops, x should be 5 or greater 
 ------ 
    \   ^__^ 
     \  (oo)\ ________ 
        (__)\         )\ /\ 
             ||------w|
             ||      ||
```


Or capture a warning or message and pass to the `say` function


```r
foo2 <- function(x) {
    err <- tryCatch(x^2, error = function(e) e)
    say(err$message, "frog")
}
```


Then call the function 


```r
foo2("hello")
```

```


 ----- 
 non-numeric argument to binary operator 
 ------ 
    \   
     \  
        (.)_(.)
     _ (   _   ) _
    / \/`-----'\/ \
  __\ ( (     ) ) /__
  )   /\ \._./ /\   (
   )_/ /|\   /|\ \_(
  
```


Awesome. Much better to have an error message from a frog than just the harsh console alone :)

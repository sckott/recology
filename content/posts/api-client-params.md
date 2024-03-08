---
name: api-client-params
layout: post
title: "API client design: how to deal with lots of parameters?"
date: 2020-12-21
author: Scott Chamberlain
sourceslug: _drafts/2020-12-21-api-client-params.md
tags:
- R
- programming
- builder-pattern
---

In February this year I wroute about [how many parameters functions should have](https://recology.info/2020/02/how-many-parameters/), looking at some other languages, with a detailed look at R. On a related topic ... 

As I work on many R packages that are API clients for various web services, I began wondering: What is the best way to deal with API routes that have a lot of parameters?

The general programming wisdom I've seen is that a function should have no more than 3-4 parameters (e.g., [this long SO thread][so2], or [this one][so3]). So should one do anything different from a normal function when that function is connecting to a web API route with a lot of parameters? I've not found very much spilled ink on this exact topic, but I'll discuss what I have found.

## Use cases?

A Software Engineering StackExchange thread [How to handle many arguments in an API wrapper?][so1] had a couple ideas. One idea is to consider use cases, and then make separate functions covering those use cases. This might work, but I haven't explored it thoroughly for a real API route yet. Pondering on it though I doubt this would work since you'd have to pre-emptively think about all the different scenarios users might dream up, which seems like a fools errand.

## Builder pattern

Another concept brought up in the thread mentioned above was the [Builder pattern][builder]. It's hard for me to understand the idea in abstract - [here's a nicer discussion of this in Ruby](https://medium.com/kkempin/builder-design-pattern-in-ruby-dfa2d557ff1b).

This is a good concept to know about, but I don't think is appropriate for the issue at hand, of how to handle many API parameters.

## Named parameter map

Another idea in that thread was to use a named parameter map. In R this would look something like this (imagine a lot more parameters though):

```r
foo <- function(args) {
  get("/some-api-route", args)
}
api_args <- list(query = "*:*", limit = 10)
my_args <- modifyList(api_args, list(query = "bears", limit = 300))
foo(my_args)
```

That is, the above would replace this:

```r
foo <- function(query = "*:*", limit = 10) {
  get("/some-api-route", list(query = query, limit = limit))
}
foo(query = "*:*", limit = 10)
```

So in the first code block the function no longer has a lot of parameters in it. The drawback of this in R (and I'm sure is similar in other languages) is that users lose the autocomplete helpers that most modern IDE's and text editors have - helping users type less and quickly get a tip on what each parameter is intended to do and importantly (if the developer has documented the function well) what types the parameters expects and what (if any) options there are to pass to the parameter.

Of course a user can "just" read the docs to figure out what each parameter expects, but it sure can save a lot of time if the help is right there in the tooltips of the IDE/text editor. In addition, in R there's automated checking that parameters in functions are also documented, which is nice for making sure parameters and docs don't get out of sync. You'd lose this by using a parameter map - though you could document the parameter map - and perhaps wire together some custom code to make sure the parameters in the parameter map are all handled by the function. This does seem like a lot of fuss though compared to simply having the parameters in the function itself.

This approach probably becomes more attractive if a client has many functions that take the same parameters - in which a named parameter map could handle the parameters and any logic behind checking those parameters.

## Include no parameters in the function

In other words: Pass all parameters on to the API w/o including any of them in the function - i.e., let the API handle any problems in parameters.

Another approach I've not seen written about but that I've seen in code is having a rather lite wrapper around an API and letting the API itself sort out any problems due to user inputs. 

An example is the [gh R package](https://gh.r-lib.org/), a client for the GitHub API. For query parameters you can pass in named parameters through the ellipsis `...`, all of which are passed as query parameters. The gh package does no checking of these parameters (that I know of); simply passes them to the GitHub API. The GitHub API happens to apparently ignore invalid (silently drop) parameters and invalid valuses of parameters (here, "stuff" is an invalid value for the `page` parameter).

```r
x <- gh("GET /users/{username}/repos", username = "gaborcsardi", page = "stuff")
length(x)
#> 30
```

I don't hate this solution, but I don't love it either. This approach is highly dependent on a well designed API that fails gracefully, with informative error messages and with correct status codes, etc. I would say  most APIs are not as nice as GitHub's, at least in the scientific API space in which I work. 

One plus side of this approach is the R package gh only has one parameter (`...`) to handle all query parameters, so you do solve the too many query parameters problem.

Another upside to this approach is you do not have to keep up with any changes in parameters on each API route - for example, an API route could drop one parameter, and add another, and the R client wouldn't have to change anything (assuming the change in parameters wasn't associated with a change that breaks code in the client). 

A major downside of this approach is that the user often has to mount a time-consuming expedition to figure out what parameters are accepted. Some API clients may document them, and some will simply direct users to the web APIs docs. I think this part alone makes this solution (include no parameters in the function) not a good one since the user experience can be so bad if the documentation is not good. And all developers know its much easier for their docs to get out of date than their code.

## Include some parameters in the function

Another approach is to define some query parameters in the function, and handle all others via R's ellipsis (`...`) - or similar in other languages. I've seen this relatively often and have used it myself. It's often used when there's a clear smaller set of important parameters - those can be put in the function as named parameters. And then there's a long tail of other parameters that the maintainer thinks are not likely to be used very often. Those can be looked up by the user in the API docs for whatever API the client interacts with. 

An example of this is the rOpenSci package [rtweet](https://docs.ropensci.org/rtweet/) - a client for the Twitter API. In the [search_tweets() function](https://docs.ropensci.org/rtweet/reference/search_tweets.html#arguments) there are a half dozen or so named parameters in the function, but then the ellipsis handles all other parameters. 

The drawback to this approach is that no two APIs behave the same way. In the case of Twitter they silently ignore/drop parameters they do not support (same as the GitHub API, see above). For example:

```r
library(rtweet)
search_tweets("hillaryclinton", n = 3, foo = "bar")
```

Works just fine even though `foo` is absolutely not a parameter supported by the Twitter API. They must ignore parameters they don't support. This is same behavior as the GitHub API we saw above.

In the case of Twitter and GitHub one might want to raise errors on unsupported parameters client side in rtweet to avoid any use confusion of parameters being silently dropped.

## Grouping similar parameters together

Many threads (e.g., [this one][so4]) suggest that similar parameters could be grouped together to reduce the number of parameters passed to a function. For example, if a function has the parameters `latitude` and `longitude` you could group those into a single parameter called e.g., `coordinates`.

```r
# Original function, each parameter separate
foo <- function(latitude, longitude) {
    # do something with latitude/longitude
    latitude
    longitude
}

# Modified function, grouping the two parameters into one
foo <- function(coordinates) {
    # do something with latitude/longitude
    coordinates$latitude
    coordinates$longitude
}
```

Though I've not tried this approach myself, it might be a good compromise between a function not handling any parameters (i.e., just passing all to the web API unhandled) and handling every parameter individually.

## Closing thoughts

The benefit of documenting API query parameters in a client package is that you can tell the user what each parameters expects in language they can understand. That is, if you simply direct users to the docs for the web API with which the client interacts, the API docs could be not very good and/or specify types expected that the user may not understand. In addition, there may be edge cases or similar with some parameters that are not documented in the API docs but that you can document in the client docs for each parameter. 

I would say the vast majority of web API clients I use that do succeed in having very few parameters also have docs in which it's a nightmare trying to figure out what parameters each method accepts. That is, the pursuit of very few parameters at least is correlated with a very poor user experience  - in my experience.



[builder]: https://en.wikipedia.org/wiki/Builder_pattern
[so1]: https://softwareengineering.stackexchange.com/questions/196895/how-to-handle-many-arguments-in-an-api-wrapper
[so2]: https://stackoverflow.com/questions/174968/how-many-parameters-are-too-many
[so3]: https://softwareengineering.stackexchange.com/questions/331803/techniques-for-minimising-number-of-function-arguments
[so4]: https://softwareengineering.stackexchange.com/a/352676/329940

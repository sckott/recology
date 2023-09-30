---
name: control-flow-exceptions
layout: post
title: "Exceptions in control flow in R"
date: 2019-03-04
author: Scott Chamberlain
sourceslug: _posts/2019-03-04-control-flow-exceptions.md
tags:
- R
- control flow
- exceptions
- exception handling
- API
- http
---

I was listening to a Bike Shed podcast [episode 189, "It's Gonna Work, Definitely, No Problems Whatsoever"](http://bikeshed.fm/189), and starting at 27:44 there was a conversation about exception handling. Specifically it was about exception handling in control flow when doing web API requests. This topic piqued my interest straight away as I do a lot of API stuff (making and wrapping).

The part of the conversation that I want to address is their conclusion that exceptions in control flow are an anti-pattern. Seems this is a general pattern in programming languages, e.g., this [SO thread](https://softwareengineering.stackexchange.com/a/189225/329940). But on the contrary there are some languages in which exceptions in control flow are considered normal behavior; e.g., Python ([this](https://softwareengineering.stackexchange.com/a/318542/329940), [this](https://softwareengineering.stackexchange.com/a/351121/329940)). 

My first reaction to this was one of vehement disagreement because in my experience wrapping web APIs raising exceptions on HTTP status codes of 400 and 500 series is the norm, in at least R and Ruby. They argued that there are better ways of handling these cases. After a whg with my gut reaction.

Let's take a step back first and look at some concepts before diving further into this.
ile I thought maybe the topic is worth thinking harder about rather than goin
## control flow

[Control flow](https://en.wikipedia.org/wiki/Control_flow) in programming is

> the order in which individual statements ... are executed or evaluated ... a control flow statement is a statement, the execution of which results in a choice being made as to which of two or more paths to follow.

[Control flow in R](https://stat.ethz.ch/R-manual/R-devel/library/base/html/Control.html) has an overview of control flow in R. Control flow constructs in R include `if/else`, `for`, `while`, `repeat`, `break`, `next`.

## exceptions

Exceptions are

> anomalous or exceptional conditions requiring special processing - often changing the normal flow of program execution (source: [wikiex][])

In R, exception handling can be done with `try`, `tryCatch`, `withCallingHandlers` and others. Often `warning()` is used to signal to the user what happened, but does not stop execution, and can be suppressed with `suppressWarnings()`. To stop execution, `stop()` is used.

<br>

## back to web API exceptions and control flow in R

Note the word **exceptional** above in our definition of exceptions. The BikeShed pod hosts were surprised to see exceptions raised with bad API requests because they didn't think a bad API request was **exceptional**, but rather an expected result given certain conditions (e.g., an HTTP 400 series client error means the client did something wrong and perhaps the server gave back a useful error message to help fix the request).

They observed that most Ruby API wrappers did have the behavior of raising an exception on a 400/500 series API status, but they disagreed with this approach.

In R world, most API wrappers in my experience also follow the pattern of raising an exception stopping the code flow on a 400/500 series HTTP error.
<!-- (the exception to this rule that I've used in some of my packages is when there is a common use case to iterate over A LOT of inputs, in which stopping execution would be painful) -->

What would it look like to not stop code execution flow when 400/500 series errors are returned from web API requests? What would need to change from the current setup? How would users be affected?

A typical R function that makes a web API request looks like the following:

```r
foo = function(path, query = list()) {
  conn = crul::HttpClient$new("https://httpbin.org")
  res = conn$get(path = path, query = query)
  res$raise_for_status()
  res$parse("UTF-8")
}
```

On a successful request all is good and we get back the JSON payload

```r
foo(path = "get", query = list(apple = "pink lady"))
#> [1] "{\n  \"args\": {\n    \"\": \"pink lady\"\n  }, ...
```

When there is a 400/500 series code the line `res$raise_for_status()` throws an error, stopping execution

```r
foo(path = "status/400")
#> Error: Bad Request (HTTP 400)
```

Instead of raising an error we could throw a warning and proceed to the next step

```r
bar = function(path, query = list()) {
  conn = crul::HttpClient$new("https://httpbin.org")
  res = conn$get(path = path, query = query)
  if (res$status_code >= 400) {
    warning(sprintf("HTTP %s %s", res$status_code, res$status_http()$explanation))
  }
  res$parse("UTF-8")
}
```

```r
bar(path = "status/400")
#> [1] ""
#> Warning message:
#> In bar(path = "status/400") :
#>  HTTP 400 Bad request syntax or unsupported method
```

This is fine, but there's a few scenarios in which this will be problematic:

1. Many APIs **DO NOT** return the same content-type on a 400 series error, and even more common on 500 series errors. In fact, often JSON APIs return an HTML error page, which may or may not contain a meaningul message, instead of the same content type as a successful response (e.g., JSON).
2. Rather then simply parsing the response `res$parse("UTF-8")`, the downstream code may be more complex (e.g., selecting particular fields/keys), and may fail out (and in R, this often means useless error messages for the user).

If we take their advice and don't fail out on 400/500 series codes, what would that look like? One could do something like:

```r
hello_world <- function(path, query = list()) {
  conn = crul::HttpClient$new("https://httpbin.org")
  res = conn$get(path = path, query = query)
  if (res$status_code >= 400) {
    warning(sprintf("HTTP %s %s", res$status_code, res$status_http()$explanation))
  }
  res
}
```

We still get the warning on an error

```r
hello_world(path = "status/400")
#> Warning message:
#> In hello_world(path = "status/400") :
#>   HTTP 400 Bad request syntax or unsupported method
```

But also we return the response object (`HttpResponse` from the `crul` package in this case):

```r
#> <crul response>
#>   url: https://httpbin.org/status/400
#>   request_headers:
#>     User-Agent: libcurl/7.54.0 r-curl/3.3 crul/0.7.0
#>     Accept-Encoding: gzip, deflate
#>     Accept: application/json, text/xml, application/xml, */*
#>   response_headers:
#>     status: HTTP/1.1 400 BAD REQUEST
#>     access-control-allow-credentials: true
#>     access-control-allow-origin: *
#>     content-type: text/html; charset=utf-8
#>     date: Mon, 04 Mar 2019 17:49:39 GMT
#>     server: nginx
#>     content-length: 0
#>     connection: keep-alive
#>   status: 400
```

Now the user can explore the response body, response headers, etc. and decide on their own what to do instead of the function failing out and returning nothing.

This approach is fine if your users are more advanced, but most packages/libraries are probably trying to give back a data object that users are familiar with. In R, that is clearly the data.frame. When there is a 400/500 series error, one option is to return an empty data.frame and throw a warning about the error, hopefully with enough information for the user to fix the request. This is probably best for naive users, but any package has some more advanced users that would benefit from more information; and more information will help a naive user + the maintainer debug a problem easier.

The next more complicated option would be a list that can have the same format regardless of errors or not:

```r
func <- function() {
  res <- hello_world(path = "status/400")
  mssg <- sprintf("HTTP %s %s", res$status_code, res$status_http()$explanation)
  list(data = res$parse("UTF-8"), error = mssg)
}
``` 

gives

```r
func()
#> $data
#> [1] ""
#> 
#> $error
#> [1] "HTTP 400 Bad request syntax or unsupported method"
```

Or possibly something more complex where you can build in accessors to make it easy to get data the user expects, but also dig into the HTTP response object itself if needed:

```r
Response <- R6::R6Class("Response",
  public = list(
    x = NULL,
    initialize = function(resp) self$x <- resp,
    data = function() self$x$parse("UTF-8"),
    error = function() {
      sprintf("HTTP %s %s", self$x$status_code, self$x$status_http()$explanation)
    }
  )
)
myfunc <- function() {
  res <- hello_world(path = "status/400")
  Response$new(res)
}
``` 

Which gives:

```r
out <- myfunc()
# the HTTP message
out$error()
#> [1] "HTTP 400 Bad request syntax or unsupported method"
# the response body, parsed
out$data()
#> [1] ""
# the full HTTP response object
out$x
```

## what about users handling exceptions on their side?

If one sticks swith erroring out of excecution flow with 400/500 series errors, the user can still handle it on their end. For example, if they are using a function in a loop/appply type call, they can use `tryCatch` or similar and check for an error and proceed one of two or more ways depending on the error or successful request. Of course this assumes that the user knows how to do this. 

Additionally, this means that each user will handle errors in different ways, possibly making mistakes in the process - arguing for the developer of the package to handle exceptions instead.

## it's too complex, just fail out

One reason I like to fail out on 400/500 series errors in my packages is that there is often significant data munging of the response. Failing out makes my life easier as I don't have to worry about what to do with HTTP responses that fail. In the world I run in of smallish APIs for science/research, API failure behavior often is not very good; it's typically unpredictable, changes from time to time, and failure response bodies are often just their HTML failure page, leading to brittle code for parsing that HTML as that HTML can change often. It'd be great if every API was as good as Github's for example, but we'll never be in that place. 

## performance considerations

In reading about exceptions in control flow, there's a common thread about performance (e.g., [c++](https://stackoverflow.com/questions/13835817/are-exceptions-in-c-really-slow), [Ruby 1](https://simonecarletti.com/blog/2010/01/how-slow-are-ruby-exceptions/), [Ruby 2](https://www.honeybadger.io/blog/benchmarking-exceptions-in-ruby-yep-theyre-slow/)). That is, if throwing exceptions is a slow procedure, that's one reason to avoid them. But if exceptions aren't slow then that's not a great argument for avoiding them. 

I haven't seen anything on performance an exceptions in R, though I'm sure there's something out there.

Even if exceptions are a slowish procedure, there is an argument to be made that failing early also saves time; that is, if you get a 400/500 series error you aren't then spending time with downstream processing of the response. However, then the user has less information. Trade-offs all the way down.

## conclusion

I'm not sure if I'll change anything in packages I maintain or not. I'll keep thinking about this and ask around to gauge others opinions on this. Part of me wants to follow the avoid exceptions path, but I worry about two things. First, the complexity increases for me as the developer. If I don't fail out, then I have to deal with parsing somehow every response. It's not as simple as giving back the HTTP response; I ideally want to give users a data structure they are familiar with, i.e., a data.frame. Second, for the user, if I give back a list or an `R6` object, that increases complexity on their side. Is the benefit of more information worth the cost of more complexity for the user? I've no idea. 




[wikiex]: https://en.wikipedia.org/wiki/Exception_handling


















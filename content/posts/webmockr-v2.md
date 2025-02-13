---
name: webmockr-v2
layout: post
title: "webmockr v2: another day, another stub"
date: 2025-02-13
author: Scott Chamberlain
tags:
- R
- http
- testing
---

`webmockr` v2 is here.

You can find the source at <https://github.com/ropensci/webmockr>, and the docs at <https://docs.ropensci.org/webmockr>.

There's some big changes in this version; most importantly a breaking change, thus the major version change this time.

Here's a run down of the important items in this release.

## Installation

```r
pak::pak("webmockr")
```

## The breaking change: error handling

Previous to v2 when stubs were constructed starting with `stub_request()` if an error occurred in a pipe chain, or non-pipe flow, the stub created prior to the error remained. This was not correct behavior from a logical perspective - i.e., one would expect if an error occurred that the thing they were trying to do did not stick around. The new behavior as of v2 deletes the stub upon any error during its creation. Under the hood we're using `withCallingHandlers()` to handle different types of errors, throw warnings, etc. For example, `wi_th()` only accepts types `list` and `partial`, so fails with this code:

```r
library(webmockr)
stub_request("get", "https://eu.httpbin.org") %>% wi_th(query = 5)
#> Error in `wi_th()`:
#> ! `z$query` must be of class list or partial
#> Run `rlang::last_trace()` to see where the error occurred.
#> Warning message:
#> Encountered an error constructing stub
#> • Removed stub
#> • To see a list of stubs run stub_registry()

stub_registry()
#> <webmockr stub registry>
#>  Registered Stubs
```

Note how we tell you the error, that the stub was removed, and there's no stubs after running `stub_registry()`.

## Partial matching

Stolen from Ruby's webmock, new functions are added `including()` and `excluding()` for use with `wi_th()` to say that you want a stub to match on a partial request body or query. Note that you could already do partial matching on request headers.

For example, let's say you have an http request you want to match that will have a large request body but you know you can uniquely match it and only it with just one component of that body. With partial matching it becomes easier and less code, for example, to match this http request:

```r
POST("https://hb.opencpu.org/post",
  body = list(
    fruit = "pear",
    meat = "chicken",
    bread = "wheat",
    cereal = "cheerios",
    pizza = "veggie",
    apple = "pink-lady",
    juice = "mango",
    poptart = "raspberry"
  )
)
```

We'd only need this stub

```r
stub_request("post", "https://hb.opencpu.org/post") %>%
  wi_th(body = including(list(fruit = "pear")))
```

rather than having to specify every part of the request body.

## Body diffing

Inspired by Ruby's [webmock][] that has an option to show request body diffs when there's no stub that matches an http request - `webmockr` wanted some of that magic.

We've added some new features for supporting request body diffs. There are two ways to use request body diffing.

First, you can toggle it on/off globally like

```r
webmockr_configure(show_body_diff = TRUE)
# or
webmockr_configure(show_body_diff = FALSE)
```

Second, a new function `stub_body_diff()` is a standalone function that compares by default the last stub created and the last http request made - but you can pass in any stub and http request. Note that body diffing functionality requires the suggested package [diffobj][].

`stub_body_diff()` uses by default the last stub and request made via the new functions `last_request()` and `last_stub()` - which get the last http request made and the last webmockr stub created, respectively. You can use these `last_*()` functions standalone as well to get the last stub or request as we keep track of those for you.

Here's an example:

```r
library(webmockr)
library(crul)

stub_request("post", "https://hb.opencpu.org/post") %>%
     wi_th(body = list(apple = "green"))

enable()
HttpClient$new("https://hb.opencpu.org")$post(
     path = "post", body = list(apple = "red")
   )
#> Error in `adap$handle_request()`:
#> ! Real HTTP connections are disabled.
#> ! Unregistered request:
#> ℹ POST:  https://hb.opencpu.org/post  with body {apple: red}  with headers {Accept-Encoding: gzip, deflate, Accept: application/json, text/xml, application/xml, */*}
#>
#> You can stub this request with the following snippet:
#>  stub_request('post', uri = 'https://hb.opencpu.org/post') %>%
#>      wi_th(
#>        headers = list('Accept-Encoding' = 'gzip, deflate', 'Accept' = 'application/json, text/xml, application/xml, */*'),
#>        body = list(apple="red")
#>      )
#>
#> registered request stubs:
#>  POST: https://hb.opencpu.org/post   with body {"apple":"green"}
#>
#>
#> ============================================================
#> Run `rlang::last_trace()` to see where the error occurred.

stub_body_diff()
#> < stub$body    > request$b..
#> @@ 1,3 @@      @@ 1,3 @@
#>   $apple         $apple
#> < [1] "green"  > [1] "red"
```

In the console, `diffobj` provides colorized output that doesn't show up in the example above.

## Give it a spin

What do you think? I think this version provides greater flexibility in matching requests, better error behavior, and greater ability to debug issues. Check out the [repo][webmockr], the [docs][webmockrdocs], and report any [issues][].


[webmockr]: https://github.com/ropensci/webmockr
[webmockrdocs]: https://docs.ropensci.org/webmockr
[issues]: https://github.com/ropensci/webmockr/issues
[diffobj]: https://github.com/brodieG/diffobj
[webmock]: https://github.com/bblimke/webmock

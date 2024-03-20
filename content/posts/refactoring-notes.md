---
name: refactoring-notes
layout: post
title: "Refactoring notes"
date: 2024-03-20T15:24:38-07:00
author: Scott Chamberlain
tags:
- testing
---

I worked on a refactor of an R package at work the other day. Here's some notes about that after doing the work. This IS NOT a best practices post - it's just a collection of thoughts.

For context, the package is an API client.

It made sense to break the work for any given exported function into the following components, as applicable depending on the endpoint being handled (some endpoints needed just a few lines of code, so those funtions were left unchanged):

- query building 
- http request (including error handling)
- http response handling

Before this separation each exported function did all three of the above items. For example, before the change the single function with all the code is called `fetch_items`. After the separation we still have the exported function `fetch_items`, but within `fetch_items` are up to three functions (as applicable) that have distinct duties:

- `fetch_items_query`: prepare the http request components
- `fetch_items_http`: the http request handling, includes http status code checking/handling
- `fetch_items_process`: process the http response

So code would be:

```r
fetch_items <- function(a, b, token) {
  request <- fetch_items_query(a, b)
  response <- fetch_items_http(request, token)
  fetch_items_process(response)
}
```

You may still need to do additional refactoring for the functions used inside of `fetch_items`. In fact, the functions that do processing of the http response (i.e., `fetch_items_process`) are sometimes pretty massive and need refactoring - BUT! are waiting on examples that will touch all the code paths - womp womp womp...

This separation of concerns and code improves the package because:

- *You can iterate on tests faster for code that's not doing http requests*. For example, the response handling function can rapidly run through a lot of tests since it doesn't have to wait on http requests - assuming you have responses cached in the package to run through it, which is easy enough 
	- You can still run fast tests on tests that do http requests if you use fixtures so you're not doing real http request other than to record the fixtures, e.g. using package [vcr][]
- *Separating concerns makes the code easier to reason about*. That is - assuming you have well named functions whose intent is clear - it's easier to understand code flow, etc.
- *Smaller functions are easier to understand*. This is pretty straightforward, and not specific to any particular type of code. If there's less going on in any one function it's easier to make changes to a package.
- *Breaking code down may reveal redundant code blocks that could be reused*. For example, after pulling out code from different functions you might notice that you're doing very similar tasks and can make a function that can be used across the exported functions rather than having repeated code.

### don't forget about failing early

I had to go back and make sure fail early code wasn't lost in breaking up code into chunks. For example, if you are checking if a parameter is of an acceptable type, or some other critical piece is not correct/available, those things should be done first thing so the function fails early.



[vcr]: https://github.com/ropensci/vcr

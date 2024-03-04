---
name: shiny-events
layout: post
title: "Shiny button weirdness"
date: 2024-03-04
author: Scott Chamberlain
sourceslug: _posts/2024-03-04-shiny-events.md
tags:
- R
- shiny
---


I've been working on an inherited [Shiny](https://shiny.posit.co/) app at work for the past few months. One of the many frustrating things about Shiny lately has been around buttons. Well, it wasn't really about buttons, but that's where it started.

I noticed that a number of buttons - some having file inputs, some having text inputs - did not trigger every time, and I expected them to trigger every time no matter what. 

I attempted many fixes before finally landing on a solution - explained below.


Load libraries

```r
library(shiny)
library(bslib)
library(crul)
```

Helper function, return a random UUID from an httpbin server. I pass input into this function below, but it is ignored - it's just to have a client side input be used within the reactive fxn - and it was easiest to just return a UUID, which doesn't need any inputs. :shrug:


```r
httpbin_uuid <- function(...) {
  con <- crul::HttpClient$new("https://hb.opencpu.org")
  res <- con$get("uuid")
  jsonlite::fromJSON(res$parse("UTF-8"))$uuid
}
```

A `bslib` ui component


```r
ui <- page_sidebar(
  title = "My dashboard",
  sidebar = list(
    actionButton("submit", "Submit"),
    actionButton("reset", "Reset")
  ),
  textInput(inputId = "name", "Your name"),
  textOutput("uuid")
)
```

Here's the server part that was giving me trouble. As I said this was an inherited repo, and the server side handling for many buttons was done with `eventReactive` as below. Using `eventReactive` meant that button clicks only sometimes triggered the server side code.

```r
server <- function(input, output, session) {
  tmp <- eventReactive(input$submit, {
    httpbin_uuid(input$name)
  })

  output$uuid <- renderText({ tmp() })

  observeEvent(input$reset, {
    updateTextInput(session, "name", "Your name", "")
    output$uuid <- renderText({})
  })
}
```

Eventually I landed upon switching from `eventReactive` to `observeEvent` for a variety of reasons. And tried something like this:

```r
  observeEvent(input$submit, {
    output$uuid <- renderText({
      httpbin_uuid(input$name)
    })
  })
```

However, this still did not work. 

The final missing piece was the function [isolate](https://shiny.posit.co/r/reference/shiny/latest/isolate.html). Without `isolate` the `observeEvent` handler was being triggered on changes other than just a button click.

```r
  observeEvent(input$submit, {
    output$uuid <- renderText({
      isolate(
      	httpbin_uuid(input$name)
      )
    })
  })
```

Here's the entire app with `eventReactive` that didn't work:

<details><summary>Click to expand</summary>
<p>

{% highlight r %}
library(shiny)
library(bslib)
library(crul)

httpbin_uuid <- function(...) {
  con <- crul::HttpClient$new("https://hb.opencpu.org")
  res <- con$get("uuid")
  jsonlite::fromJSON(res$parse("UTF-8"))$uuid
}

ui <- page_sidebar(
  title = "My dashboard",
  sidebar = list(
    actionButton("submit", "Submit"),
    actionButton("reset", "Reset")
  ),
  textInput(inputId = "name", "Your name"),
  textOutput("uuid")
)

server <- function(input, output, session) {
  tmp <- eventReactive(input$submit, {
    httpbin_uuid(input$name)
  })

  output$uuid <- renderText({ tmp() })

  observeEvent(input$reset, {
    updateTextInput(session, "name", "Your name", "")
    output$uuid <- renderText({})
  })
}

shinyApp(ui, server)
{% endhighlight %}

</p>
</details> 

<br>
And here's the entire app with `obseveEvent` and `isolate` that worked:

<details><summary>Click to expand</summary>
<p>

{% highlight r %}
library(shiny)
library(bslib)
library(crul)

httpbin_uuid <- function(...) {
  con <- crul::HttpClient$new("https://hb.opencpu.org")
  res <- con$get("uuid")
  jsonlite::fromJSON(res$parse("UTF-8"))$uuid
}

ui <- page_sidebar(
  title = "My dashboard",
  sidebar = list(
    actionButton("submit", "Submit"),
    actionButton("reset", "Reset")
  ),
  textInput(inputId = "name", "Your name"),
  textOutput("uuid")
)

server <- function(input, output, session) {
  observeEvent(input$submit, {
    output$uuid <- renderText({
      isolate(httpbin_uuid(input$name))
    })
  })

  observeEvent(input$reset, {
    updateTextInput(session, "name", "Your name", "")
    output$uuid <- renderText({})
  })
}

shinyApp(ui, server)
{% endhighlight %}

</p>
</details> 

To wrap up, I still don't completely understand `eventReactive`/`observeEvent`/`isolate`, but at least sorted out my current problem.

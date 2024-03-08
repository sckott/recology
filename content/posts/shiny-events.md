---
name: shiny-events
layout: post
title: "Shiny button weirdness"
date: 2024-03-04
tags:
- R
- shiny
---


I've been working on [Shiny](https://shiny.posit.co/) app at work for the past few months. One of the many frustrating things about Shiny lately has been around buttons. Well, it wasn't really about buttons, but that's where it started.




Load libraries

```r
library(shiny)
library(bslib)
library(crul)
```

Helper function, returned a random UUID from an httpbin server


```r
httpbin_uuid <- function(...) {
  con <- crul::HttpClient$new("https://hb.opencpu.org")
  res <- con$get("uuid")
  jsonlite::fromJSON(res$parse("UTF-8"))$uuid
}
```

A bslib ui component


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

However, keen eyes will notice that this still doesn't work. The final missing piece was the function `isolate`. Without `isolate` the `observeEvent` handler was being triggered on changes other than just a button click.

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

{{< detail-tag "Click to expand" >}}

```r
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
```

{{< /detail-tag >}}

{{< line_break >}}

And here's the entire app with `obseveEvent` and `isolate` that worked:

{{< detail-tag "Click to expand" >}}

```r
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
```

{{< /detail-tag >}}

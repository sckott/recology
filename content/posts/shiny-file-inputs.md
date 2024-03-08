---
name: shiny-file-inputs
layout: post
title: "Shiny file inputs"
date: 2024-03-08
author: Scott Chamberlain
sourceslug: _posts/shiny-file-inputs.md
tags:
- R
- shiny
---

I [wrote the other day](/2024/03/shiny-events/) about overcoming an issue with [Shiny](https://shiny.posit.co/). 

Another issue I ran into concurrently was about file inputs. The issue was that file inputs (i.e., `shiny::fileInput`) was difficult to clear. That is, after a user uploads a file, it was easy to get some of the various parts cleared/cleaned up, but not others:

- (Not Easy) The UI components of `fileInput` (the text of the file name, the loading display)
- (Not Easy) The data behind the `fileInput` handler
- (Easy) Displaying some feedback in the UI after handling file input




Load libraries

```r
library(shiny)
library(shinyjs)
library(bslib)
library(DT)
library(vroom)
```

A helper function to handle reactive inputs


```r
reactiveInput <- function(rval, path) {
  if (is.null(rval)) {
    return(NULL)
  } else if (rval == 'loaded') {
    return(path)
  } else if (rval == 'reset') {
    return(NULL)
  }
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
  fileInput(inputId = "afile", "Upload file", accept = ".csv"),
  DT::DTOutput("result"),
  shinyjs::useShinyjs()
)
```

Here's the server part that was giving me trouble.

```r
server <- function(input, output) {
  observeEvent(input$submit, {
    output$result <- DT::renderDataTable({
      dat <- vroom::vroom(
        isolate(input$afile$datapath)
      )
      DT::datatable(dat)
    })
  })

  observeEvent(input$reset, {
    shinyjs::reset("afile")
    output$result <- renderText({})
  })
}
```

With `shinyjs::reset` we can reset the UI components of the file input handler, and with `renderText` with an empty input we can reset the UI feedback. However, the data backing the file input handler is not reset. This led to problems in the UI where you could keep pressing submit after clicking the Reset button because the data for the last uploaded file was still there, whereas the user should get an error that they need to upload a file before clicking Submit.

To be able to completey reset data behind the file input handler I found out about a solution using reactive values via stackoverflow. Basically, the change involves handling file input data through a reactive value and keeping track of the state of the file input loader. 


Here's the entire app that doesn't work

{{< detail-tag "Click to expand" >}}

```r
library(shiny)
library(shinyjs)
library(bslib)
library(DT)
library(vroom)

ui <- page_sidebar(
  title = "My dashboard",
  sidebar = list(
    actionButton("submit", "Submit"),
    actionButton("reset", "Reset")
  ),
  fileInput(inputId = "afile", "Upload file", accept = ".csv"),
  DT::DTOutput("result"),
  shinyjs::useShinyjs()
)

server <- function(input, output) {
  observeEvent(input$submit, {
    output$result <- DT::renderDataTable({
      dat <- vroom::vroom(
        isolate(input$afile$datapath)
      )
      DT::datatable(dat)
    })
  })

  observeEvent(input$reset, {
    shinyjs::reset("afile")
    output$result <- renderText({})
  })
}

shinyApp(ui, server)
```

{{< /detail-tag >}}

{{< line_break >}}

And here's the entire app that does work

{{< detail-tag "Click to expand" >}}

```r
library(shiny)
library(shinyjs)
library(bslib)
library(DT)
library(vroom)

reactiveInput <- function(rval, path) {
  if (is.null(rval)) {
    return(NULL)
  } else if (rval == 'loaded') {
    return(path)
  } else if (rval == 'reset') {
    return(NULL)
  }
}

ui <- page_sidebar(
  title = "My dashboard",
  sidebar = list(
    actionButton("submit", "Submit"),
    actionButton("reset", "Reset")
  ),
  fileInput(inputId = "afile", "Upload file", accept = ".csv"),
  DT::DTOutput("result"),
  shinyjs::useShinyjs()
)

server <- function(input, output) {
  rv_file <- reactiveValues(file_state = NULL)

  thefile <- reactive({
    reactiveInput(rv_file$file_state, input$afile$datapath)
  })

  observeEvent(input$afile, {
    rv_file$file_state <- 'loaded'
  })

  observeEvent(input$submit, {
    output$result <- DT::renderDataTable({
      dat <- vroom::vroom(
        isolate(thefile())
      )
      DT::datatable(dat)
    })
  })

  observeEvent(input$reset, {
    shinyjs::reset("afile")
    rv_file$file_state <- 'reset'
    output$result <- renderText({})
  })
}

shinyApp(ui, server)
```

{{< /detail-tag >}}

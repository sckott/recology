---
name: video-editing
layout: post
title: video editing notes
date: 2016-08-12
sourceslug: _posts/2016-08-12-video-editing.md
tags:
- talks
- video
---

This is how I edit videos of talks that I need to incorporate slides and video together

I'm on a Mac

* import to iMovie (using v10 something)
* drop movie into editing section
* split pdf slides into individual files `pdfseparate foobar.pdf %d.pdf`
* convert individual pdf slides into png `sips -s format png --out "${pdf%%.*}.png" "$pdf"`
* import png's into imovie
* for each image, drop into editing area where you want it
* when focused on the png of the slide:
    * select crop, then - choose `fit`, say okay
    * select "add as overlay" (very most left symbol), then choose `picture in picture`
    * then choose `swap`
    * then move inset to where you want it
    * say okay
* rinse and repeat for all slides
* export - via `File` option
* share to youtube

### e.g. of the result

{{< youtube MHWX0f3TG4I >}}

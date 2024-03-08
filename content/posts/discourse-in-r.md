---
name: discourse-in-r
layout: post
title: discgolf - Dicourse from R
date: 2015-01-15
author: Scott Chamberlain
sourceslug: _drafts/2015-01-15-discourse-in-r.Rmd
tags:
- R
- community
- API
---



[Discourse][disc] is a great discussion forum application. It's another thing from [Jeff Atwood](https://en.wikipedia.org/wiki/Jeff_Atwood), the co-founder of [Stackoverflow/Stackexchange](https://stackoverflow.com/). The installation is epecially easy with their dockerized installation setup on DigitalOcean ([instructions here][https://www.digitalocean.com/community/tutorials/how-to-install-discourse-on-ubuntu-14-04]). 

In [rOpenSci](https://ropensci.org/), we've been using a Google Groups mailing list, which is sufficient I guess, but doesn't support Markdown, and we all know [Google can kill products any day](https://www.slate.com/articles/technology/technology/2013/03/google_reader_why_did_everyone_s_favorite_rss_program_die_what_free_web.html), so it makes sense to use something with which we have more control. We've set up our own Discourse installation to have rOpenSci discussions - find it at [discuss.ropensci.org][metadisc]. Check it out if you want to discuss anything rOpenSci related, or general open science, open source software, etc. You can login with email, Mozilla Persona, Twitter, or GitHub. 

Discourse does have a RESTful API, which I found through the [Ruby gem](https://github.com/discourse/discourse_api/). Why not interact with the API via R?

## Install

Install `discgolf` 


```r
install.packages("devtools")
devtools::install_github("sckott/discgolf")
```


```r
library("discgolf")
```

## Authentication

The Discourse API is based on using a specific installation of Discourse (as far as I know), which requires your username and an API key for that installation. Get those (I found mine in the admin panel), and you can pass them in to each function call, or set as option variables in `.Rprofile` (use `discourse_api_key` and `discourse_username`) or environment variables in `.Renviron` (use `DISCOURSE_API_KEY` and `DISCOURSE_USERNAME`).

## Examples

Get the latest topics (abbreviated content for blog post brevity)


```r
latest_topics()
```


```
#>    id                             title                       fancy_title
#> 1   8       Welcome to rOpenSci Discuss       Welcome to rOpenSci Discuss
#> 2  92    Feedback on geojsonio package?    Feedback on geojsonio package?
#> 3 102                Astronomy research                Astronomy research
#> 4  99           Rgbif argument question           Rgbif argument question
#> 5  93 Feedback on rnoaa ghcnd functions Feedback on rnoaa ghcnd functions
#>                                slug
#> 1       welcome-to-ropensci-discuss
#> 2     feedback-on-geojsonio-package
#> 3                astronomy-research
#> 4           rgbif-argument-question
#> 5 feedback-on-rnoaa-ghcnd-functions
```

Get new topics


```r
new_topics()
#> $topic_list
#> $topic_list$can_create_topic
#> [1] TRUE
#> 
#> $topic_list$draft
#> NULL
#> 
#> $topic_list$draft_key
#> [1] "new_topic"
#> 
#> $topic_list$draft_sequence
#> [1] 15
#> 
#> $topic_list$per_page
#> [1] 30
#> 
#> $topic_list$topics
#> list()
```

Get topics by a specific user


```r
topics_by("cboettig")
#> $users
#>   id username uploaded_avatar_id
#> 1  3 cboettig                  4
#> 2  1   sckott                  2
#> 3 35 noamross                 57
#> 4  2  karthik                  3
#>                                            avatar_template
#> 1  /user_avatar/discuss.ropensci.org/cboettig/{size}/4.png
#> 2    /user_avatar/discuss.ropensci.org/sckott/{size}/2.png
#> 3 /user_avatar/discuss.ropensci.org/noamross/{size}/57.png
#> 4   /user_avatar/discuss.ropensci.org/karthik/{size}/3.png
#> 
#> $topic_list
#> $topic_list$can_create_topic
#> [1] TRUE
#> 
#> $topic_list$draft
#> NULL
#> 
#> $topic_list$draft_key
#> [1] "new_topic"
#> 
#> $topic_list$draft_sequence
#> [1] 15
#> 
#> $topic_list$per_page
#> [1] 30
#> 
#> $topic_list$topics
#>   id                                      title
#> 1 15 Using Discourse for blog comments as well?
#> 2 16                            Reply by email?
#>                                  fancy_title
#> 1 Using Discourse for blog comments as well?
#> 2                            Reply by email?
#>                                        slug posts_count reply_count
#> 1 using-discourse-for-blog-comments-as-well           8           4
#> 2                            reply-by-email           6           2
#>   highest_post_number image_url               created_at
#> 1                   8        NA 2014-12-15T19:33:11.879Z
#> 2                   6        NA 2014-12-15T20:10:36.414Z
#>             last_posted_at bumped                bumped_at unseen
#> 1 2015-01-02T19:47:42.403Z   TRUE 2015-01-02T19:47:42.403Z  FALSE
#> 2 2014-12-17T00:18:31.427Z   TRUE 2014-12-17T00:18:31.427Z  FALSE
#>   last_read_post_number unread new_posts pinned unpinned visible closed
#> 1                     8      0         0  FALSE       NA    TRUE  FALSE
#> 2                     6      0         0  FALSE       NA    TRUE  FALSE
#>   archived notification_level bookmarked liked views like_count
#> 1    FALSE                  2       TRUE FALSE    71          0
#> 2    FALSE                  3       TRUE FALSE    54          0
#>   has_summary archetype last_poster_username category_id pinned_globally
#> 1       FALSE   regular             cboettig           3           FALSE
#> 2       FALSE   regular               sckott           1           FALSE
#>   bookmarked_post_numbers
#> 1                       1
#> 2                       1
#>                                                                                                                   posters
#> 1 latest, NA, NA, NA, Original Poster, Most Recent Poster, Frequent Poster, Frequent Poster, Frequent Poster, 3, 1, 35, 2
#> 2                                                                   NA, latest, Original Poster, Most Recent Poster, 3, 1
```

Get a single topic by id number


```r
topic(8)
```


```
#>   id              name username
#> 1 11            system   system
#> 2 14 Scott Chamberlain   sckott
#> 3 51 Scott Chamberlain   sckott
#>                                         avatar_template uploaded_avatar_id
#> 1 /user_avatar/discuss.ropensci.org/system/{size}/1.png                  1
#> 2 /user_avatar/discuss.ropensci.org/sckott/{size}/2.png                  2
#> 3 /user_avatar/discuss.ropensci.org/sckott/{size}/2.png                  2
```

Create topic


```r
text <- '
print("hello world")
#> [1] "hello world"

head(mtcars)
#>                    mpg cyl disp  hp drat    wt  qsec vs am gear carb
#> Mazda RX4         21.0   6  160 110 3.90 2.620 16.46  0  1    4    4
#> Mazda RX4 Wag     21.0   6  160 110 3.90 2.875 17.02  0  1    4    4
#> Datsun 710        22.8   4  108  93 3.85 2.320 18.61  1  1    4    1
#> Hornet 4 Drive    21.4   6  258 110 3.08 3.215 19.44  1  0    3    1
#> Hornet Sportabout 18.7   8  360 175 3.15 3.440 17.02  0  0    3    2
#> Valiant           18.1   6  225 105 2.76 3.460 20.22  1  0    3    1
'

create_topic(title="testing from discgolf - 2", text=text)
```

## Wrapup

There are more functions I didn't highlight, and there are many methods that haven't been implemented yet... in good time it will be done. 

[disc]: https://www.discourse.org/
[metadisc]: https://meta.discourse.org/
[rodisc]: https://discuss.ropensci.org/

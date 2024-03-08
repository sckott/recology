---
name: usda-plants-database-r
layout: post
title: USDA plants database API in R
date: 2016-10-19
sourceslug: _posts/2016-10-19-usda-plants-database-r.md
tags:
- API
- R
- ecology
- plants
---



The USDA maintains a database of plant information, some of it trait data, some
of it life history. Check it out at <https://plants.usda.gov/java/>

They've been talking about releasing an API for a long time, but have not done so.

Thus, since at least some version of their data is in the public web,
I've created a RESTful API for the data:

* source code: <https://github.com/sckott/usdaplantsapi/>
* base URL: <https://plantsdb.xyz>

Check out the API, and open issues for bugs/feature requests in the github repo.

The following is an example using it from R, but you can use it from anywhere,
the command line, Ruby, Python, a browser, whatevs.

Here, we'll use [request](https://github.com/sckott/request), a higher level
http client for R that I've been working on. A small quirk with `request` is that
when piping, you have to assign the output of the request to an object before you
can do any further manipulation. But that's probably good for avoiding too long
pipe chains.

> note, that I've set `tibble.max_extra_cols = 15` to not print the many
columns that are returned, for blog post brevity. When you run below
you'll get more columns.

Install from CRAN


```r
install.packages("request")
```

There is a small improvement in the dev version of `request` to make any data.frame's
tibble's (which the below examples uses). To get that install from GitHub:


```r
devtools::install_github("sckott/request")
```


```r
library('request')
library('tibble')
```

### Heartbeat

The simplest call to the API is to a route `/heartbeat`,
which just lists the available routes.

Set the base url we'll use throughout the work below


```r
root <- api("https://plantsdb.xyz")
```


```r
root %>% api_path(heartbeat)
#> $routes
#> [1] "/search (HEAD, GET)" "/heartbeat"
```


Okay, so there are just two routes, `/search` and `/heartbeat`.

## Search

The search route suppports the following parameters:

- `fields`, e.g., `fields='Genus,Species'` (default: all fields returned)
- `limit`, e.g., `limit=10` (default: 10)
- `offset`, e.g., `offset=1` (default: 0)
- search on any fields in the output, e.g, `Genus=Pinus` or `Species=annua`

### basic search

Let's first not pass any params


```r
root %>% api_path(search)
#> $count
#> [1] 92171
#>
#> $returned
#> [1] 10
#>
#> $citation
#> [1] "USDA, NRCS. 2016. The PLANTS Database (https://plants.usda.gov, 12 July 2016). National Plant Data Team, Greensboro, NC 27401-4901 USA."
#>
#> $terms
#> [1] "Our plant information, including the distribution maps, lists, and text, is not copyrighted and is free for any use."
#>
#> $data
#> # A tibble: 10 × 134
#>       id Symbol Accepted_Symbol_x Synonym_Symbol_x
#> *  <int>  <chr>             <chr>            <chr>
#> 1      1   ABAB              ABAB
#> 2      2  ABAB2             ABPR3            ABAB2
#> 3      3  ABAB3              ABTH            ABAB3
#> 4      4 ABAB70            ABAB70
#> 5      5   ABAC             ABUMB             ABAC
#> 6      6   ABAL              ABAL
#> 7      7  ABAL2             ABUMU            ABAL2
#> 8      8  ABAL3             ABAL3
#> 9      9   ABAM              ABAM
#> 10    10  ABAM2             ABAM2
#> # ... with 130 more variables: Scientific_Name_x <chr>,
#> #   Hybrid_Genus_Indicator <chr>, Hybrid_Species_Indicator <chr>,
#> #   Species <chr>, Subspecies_Prefix <chr>,
#> #   Hybrid_Subspecies_Indicator <chr>, Subspecies <chr>,
#> #   Variety_Prefix <chr>, Hybrid_Variety_Indicator <chr>, Variety <chr>,
#> #   Subvariety_Prefix <chr>, Subvariety <chr>, Forma_Prefix <chr>,
#> #   Forma <chr>, Genera_Binomial_Author <chr>, ...
#>
#> $error
#> NULL
```

You get slots:

* `count`: number of results found
* `returned`: numbef of results returned
* `citation`: suggested citation, from USDA
* `terms`: terms of use, from USDA
* `data`: the results
* `error`: if an error occurred, you'll see the message here

Note that if any data.frame's are found, we make them into tibble's, nicely
formatted data.frame's that make it easy to deal with large data.

### Pagination

limit number of results


```r
root %>%
  api_path(search) %>%
  api_query(limit = 5)
#> $count
#> [1] 92171
#>
#> $returned
#> [1] 5
#>
#> $citation
#> [1] "USDA, NRCS. 2016. The PLANTS Database (https://plants.usda.gov, 12 July 2016). National Plant Data Team, Greensboro, NC 27401-4901 USA."
#>
#> $terms
#> [1] "Our plant information, including the distribution maps, lists, and text, is not copyrighted and is free for any use."
#>
#> $data
#> # A tibble: 5 × 134
#>      id Symbol Accepted_Symbol_x Synonym_Symbol_x
#> * <int>  <chr>             <chr>            <chr>
#> 1     1   ABAB              ABAB
#> 2     2  ABAB2             ABPR3            ABAB2
#> 3     3  ABAB3              ABTH            ABAB3
#> 4     4 ABAB70            ABAB70
#> 5     5   ABAC             ABUMB             ABAC
#> # ... with 130 more variables: Scientific_Name_x <chr>,
#> #   Hybrid_Genus_Indicator <chr>, Hybrid_Species_Indicator <chr>,
#> #   Species <chr>, Subspecies_Prefix <chr>,
#> #   Hybrid_Subspecies_Indicator <chr>, Subspecies <chr>,
#> #   Variety_Prefix <chr>, Hybrid_Variety_Indicator <chr>, Variety <chr>,
#> #   Subvariety_Prefix <chr>, Subvariety <chr>, Forma_Prefix <chr>,
#> #   Forma <chr>, Genera_Binomial_Author <chr>, ...
#>
#> $error
#> NULL
```

change record to start at


```r
root %>%
  api_path(search) %>%
  api_query(limit = 5, offset = 10)
#> $count
#> [1] 92161
#>
#> $returned
#> [1] 5
#>
#> $citation
#> [1] "USDA, NRCS. 2016. The PLANTS Database (https://plants.usda.gov, 12 July 2016). National Plant Data Team, Greensboro, NC 27401-4901 USA."
#>
#> $terms
#> [1] "Our plant information, including the distribution maps, lists, and text, is not copyrighted and is free for any use."
#>
#> $data
#> # A tibble: 5 × 134
#>      id Symbol Accepted_Symbol_x Synonym_Symbol_x
#> * <int>  <chr>             <chr>            <chr>
#> 1    11  ABAM3             ABAM3
#> 2    12  ABAM4              NAAM            ABAM4
#> 3    13  ABAM5              ABAB            ABAM5
#> 4    14   ABAN              ABAN
#> 5    15  ABANA              ABAN            ABANA
#> # ... with 130 more variables: Scientific_Name_x <chr>,
#> #   Hybrid_Genus_Indicator <chr>, Hybrid_Species_Indicator <chr>,
#> #   Species <chr>, Subspecies_Prefix <chr>,
#> #   Hybrid_Subspecies_Indicator <chr>, Subspecies <chr>,
#> #   Variety_Prefix <chr>, Hybrid_Variety_Indicator <chr>, Variety <chr>,
#> #   Subvariety_Prefix <chr>, Subvariety <chr>, Forma_Prefix <chr>,
#> #   Forma <chr>, Genera_Binomial_Author <chr>, ...
#>
#> $error
#> NULL
```

### Return fields

You can say what fields you want returned, useful when you just want a
subset of fields


```r
root %>%
  api_path(search) %>%
  api_query(fields = 'Genus,Species,Symbol')
#> $count
#> [1] 92171
#>
#> $returned
#> [1] 10
#>
#> $citation
#> [1] "USDA, NRCS. 2016. The PLANTS Database (https://plants.usda.gov, 12 July 2016). National Plant Data Team, Greensboro, NC 27401-4901 USA."
#>
#> $terms
#> [1] "Our plant information, including the distribution maps, lists, and text, is not copyrighted and is free for any use."
#>
#> $data
#> # A tibble: 10 × 3
#>    Symbol     Species       Genus
#> *   <chr>       <chr>       <chr>
#> 1    ABAB abutiloides    Abutilon
#> 2   ABAB2       abrus       Abrus
#> 3   ABAB3    abutilon    Abutilon
#> 4  ABAB70    abietina Abietinella
#> 5    ABAC   acutalata     Abronia
#> 6    ABAL      alpina     Abronia
#> 7   ABAL2        alba     Abronia
#> 8   ABAL3        alba       Abies
#> 9    ABAM    amabilis       Abies
#> 10  ABAM2     ameliae     Abronia
#>
#> $error
#> NULL
```


### Query

You can query on individual fields


```r
root %>%
  api_path(search) %>%
  api_query(Genus = Pinus, fields = "Genus,Species")
#> $count
#> [1] 185
#>
#> $returned
#> [1] 10
#>
#> $citation
#> [1] "USDA, NRCS. 2016. The PLANTS Database (https://plants.usda.gov, 12 July 2016). National Plant Data Team, Greensboro, NC 27401-4901 USA."
#>
#> $terms
#> [1] "Our plant information, including the distribution maps, lists, and text, is not copyrighted and is free for any use."
#>
#> $data
#> # A tibble: 10 × 2
#>       Species Genus
#> *       <chr> <chr>
#> 1  albicaulis Pinus
#> 2    apacheca Pinus
#> 3    aristata Pinus
#> 4   arizonica Pinus
#> 5    armandii Pinus
#> 6   arizonica Pinus
#> 7    aristata Pinus
#> 8   arizonica Pinus
#> 9   arizonica Pinus
#> 10  attenuata Pinus
#>
#> $error
#> NULL
```

Another query example


```r
root %>%
  api_path(search) %>%
  api_query(Species = annua, fields = "Genus,Species")
#> $count
#> [1] 30
#>
#> $returned
#> [1] 10
#>
#> $citation
#> [1] "USDA, NRCS. 2016. The PLANTS Database (https://plants.usda.gov, 12 July 2016). National Plant Data Team, Greensboro, NC 27401-4901 USA."
#>
#> $terms
#> [1] "Our plant information, including the distribution maps, lists, and text, is not copyrighted and is free for any use."
#>
#> $data
#> # A tibble: 10 × 2
#>    Species         Genus
#> *    <chr>         <chr>
#> 1    annua        Adonis
#> 2    annua     Artemisia
#> 3    annua   Bulbostylis
#> 4    annua    Castilleja
#> 5    annua   Craniolaria
#> 6    annua Dimorphotheca
#> 7    annua       Drosera
#> 8    annua    Eleocharis
#> 9    annua  Fimbristylis
#> 10   annua    Heliomeris
#>
#> $error
#> NULL
```

And one more example, here we're interested in finding taxa that are perennials


```r
root %>%
  api_path(search) %>%
  api_query(Duration = Perennial, fields = "Genus,Species,Symbol,Duration")
#> $count
#> [1] 25296
#>
#> $returned
#> [1] 10
#>
#> $citation
#> [1] "USDA, NRCS. 2016. The PLANTS Database (https://plants.usda.gov, 12 July 2016). National Plant Data Team, Greensboro, NC 27401-4901 USA."
#>
#> $terms
#> [1] "Our plant information, including the distribution maps, lists, and text, is not copyrighted and is free for any use."
#>
#> $data
#> # A tibble: 10 × 4
#>    Symbol     Species  Duration    Genus
#> *   <chr>       <chr>     <chr>    <chr>
#> 1    ABAB abutiloides Perennial Abutilon
#> 2    ABAL      alpina Perennial  Abronia
#> 3   ABAL3        alba Perennial    Abies
#> 4    ABAM    amabilis Perennial    Abies
#> 5   ABAM2     ameliae Perennial  Abronia
#> 6   ABAM3   ammophila Perennial  Abronia
#> 7    ABAR   argillosa Perennial  Abronia
#> 8    ABAU     auritum Perennial Abutilon
#> 9    ABBA    balsamea Perennial    Abies
#> 10  ABBAB    balsamea Perennial    Abies
#>
#> $error
#> NULL
```

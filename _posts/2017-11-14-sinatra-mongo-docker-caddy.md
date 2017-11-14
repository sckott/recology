---
name: sinatra-mongo-docker-caddy
layout: post
title: "Web APIs with Sinatra, Mongo, Docker, and Caddy"
date: 2017-11-14
author: Scott Chamberlain
sourceslug: _drafts/2017-11-14-sinatra-mongo-docker-caddy.Rmd
tags:
- API
- ruby
- docker
- caddy
- mongo
- sinatra
---

## The problem

The R community has a package distribution thing called [CRAN][] just like Ruby has [Rubygems][], and Python has [Pypi][], etc. On all packages on CRAN, the CRAN maintainers run checks on each package on multiple versions of R and on many operating systems. They report those results on a page associated with the package, like [this one](https://cran.rstudio.com/web/checks/check_results_crul.html). 

You might be thinking: okay, but we have Travis-CI and friends, so who cares about that?  Well, it's these checks that CRAN runs that will determine if your package on CRAN leads to emails to you asking for changes, and possibly the package being taken down if e.g., they email and you don't respond for a period of time. 

So CRAN provides these package checks. Now what?  Ideally, these would be available through an API so that the data is machine readable, which then makes many other things possible (see [What's Next](#whats-next) below).

So how to build the API?


## Building the CRAN checks API

On GitHub: <https://github.com/ropensci/cchecksapi>

My main goal learning goals with this API tech wise were two fold: 

- learn how to dockerize the application 
- learn how to use MongoDB 

I hadn't Dockerized a web API myself before, so that was an important goal - and I had actually never used MongoDB, but wanted to give it a shot to get familiar with it. 

The whole stack is:

* language: Ruby
* web API framework: Sinatra
* http Ruby gem: faraday
* database: mongodb
* server: caddy
* container: all wrapped up in docker (docker-compose)
* hosting: Amazon EC2
* scheduling: crontab

At a high level, the system is as so:

* Once a day a few Ruby scripts ([for packages][forpkgs], [for maintainers][formaint]):
    * collects the names of packages on CRAN from Gábor Csárdi's <https://crandb.r-pkg.org> API and maintainer emails from CRAN itself, then
    * goes out to the CRAN website and collects check results for each package, then
    * insert data into a MongoDB database
* The API provides routes for getting data on specific packages by name, or all packages, and data on all packages for any given maintainers email adddress, or all maintainers
    * API calls make a query into the MongoDB database matching on the package name or maintainer email address
    * data is given back as JSON

The API doesn't currently use caching, but may add if it seems needed.

## Ruby and Sinatra

I really like Ruby. It's a language that is fun to use, the community is great, and there's tons of packages.  Ruby is great for making web stuff, including web APIs. When doing web stuff, for me that means web APIs. For web APIs in Ruby, Rails is too heavy for all the stuff I do - that's where [Sinatra][] comes in.

Sinatra is a lightweight framework for making web apps/APIs. I make all my web APIs with Sinatra, and have had few complaints. Some may say "you should use X or Y because faster", or whatever, but Sinatra is plenty fast for my use cases. Not every use case is "we're Facebook", or "we're Google". 

Until recently I've been very much manually managing my Sinatra web APIs on servers - that is, installing/updating everything on the server itself, without using containers or any configuration management. This blog post is the blog post I would have wanted to read when I was figuring out how to dockerize my web APIs.

## The API

The main meat of the API is definitions of routes. In addition, I've included a number of rules about what HTTP verbs are allowed to be used, what headers to send in each response, how to respond to client and server failures, etc. 

This is what one of the route definitions looks like:

```ruby
get '/pkgs/?' do
  headers_get
  begin
    lim = (params[:limit] || 10).to_i
    off = (params[:offset] || 0).to_i
    raise Exception.new('limit too large (max 1000)') unless lim <= 1000
    d = $cks.find({}, {"limit" => lim, "skip" => off})
    dat = d.to_a
    raise Exception.new('no results found') if d.nil?
    { found: d.count, count: dat.length, offset: nil, error: nil,
      data: dat }.to_json
  rescue Exception => e
    halt 400, { count: 0, error: { message: e.message }, data: nil }.to_json
  end
end
```

This code chunk is for the `/pkgs` route on the API (check it out at <https://cranchecks.info/pkgs>). The `headers_get` bit sends a pre-defined set of headers in the response. The `begin ... rescue ... end` bit is a "try catch" thing - leading to a JSON failure response in case there is a failure - and a JSON response on success.

## Collecting data and MongoDB

As stated above, data is updated once a day. The code for scraping data on the package level and maintainer level is pretty similar. For both, the steps are the following: a) collect all names (for `/pkgs` that's package names from <https://crandb.r-pkg.org>; for `/maintainers` that's maintainer email addresses from <https://cran.rstudio.com/web/checks/check_summary_by_maintainer.html>), b) for each package name or maintainer email scrape CRAN check results, c) with all data collected drop data in MongoDB and then load all new data (maybe this could be an update step?). You can see the gory details on GitHub for [packages](https://github.com/ropensci/cchecksapi/blob/master/scrape.rb) and [maintainers](https://github.com/ropensci/cchecksapi/blob/master/scrape_maintainer.rb). 

Those steps above in code for packages is like the following:

```ruby
def scrape_all
  pkgs = cran_packages; # get all pkg names
  out = [] # make an array
  pkgs.each do |x| # for each pkg, scrape check results
    out << scrape_pkg(x)
  end
  if $cks.count > 0
    $cks.drop # drop data in Mongo
    $cks = $mongo[:checks] # recreate database in Mongo
  end
  $cks.insert_many(out.map { |e| prep_mongo(e) }) # load new data into Mongo
end
```

`$cks` is the MongoDB database connection.

## Docker

For containerizing the API, I used Docker. A colleague had used [Docker Compose](https://docs.docker.com/compose/), and it was a really easy experience spinning up and taking down the application we were working on. So I wanted to learn how to do that myself. After trial and error, finally got to a solution for this API. Here is my `docker-compose.yml` file:

```Dockerfile
mongo:
  image: mongo
  volumes:
    - $HOME/data/mongodb:/data/db # persists data to disk outside container
  restart: always
  ports:
    - "27017:27017"

api:
  build: .
  ports:
    - "8834:8834"
  links:
    - mongo
```

This specifies the container for MongoDB and for the API, and specifies in the API container to link to the mongo container.

To build and run do 

```
docker-compose build && docker-compose up -d
``` 

The `-d` flag is for daemonize, i.e., run in the background. To kill them run

```
docker-compose stop && docker-compose rm
``` 

## Caddy server

Caddy is great server. I never really used Nginx, so I can't compare the two really - I just know that Caddy is super easy. To install, check out the installation page <https://caddyserver.com/download>, and it's easy as something like `curl https://getcaddy.com | bash -s personal` (depends on configuration options on that page and license choice). 

I know there's an option to run a separate container with Caddy, but I run Caddy outside containers. 

My `Caddyfile` has something similar to the following:

```
cranchecks.info {
  gzip
  tls email@foobar.com

  log / logfile.log "{remote} - [{when}] {method} {uri} {query} {proto} {status} {size} {>User-Agent}" {
     rotate_size 3
  }

  proxy / localhost:8834 {
    transparent
  }
}
```

- `gzip` tells Caddy to serve gzipp'ed content (see <https://caddyserver.com/docs/gzip>)
- `tls` says use the given email for registering with [Letsencrypt](https://letsencrypt.org/) (see <https://caddyserver.com/docs/tls>)
- `log` line specifies how to log requests (and `rotate_size` says start a new file when the current one reaches 3 MB) (see <https://caddyserver.com/docs/log>)
- `proxy` is for specifying reverse proxy (see <https://caddyserver.com/docs/proxy>)

## What's Next

There's still more work to do. 

* Better `/maintainers` results
  * right now, we have two arrays of results, one from the html table on the CRAN results page and the other from the text below it. This duplication isn't ideal. 
  * it would be helpful to have a summary across all packages for any given maintainer
* Better `/pkgs` results
  * it would be helpful to have a summary across all R versions and platforms for any given package
* Include actual CRAN check results - CRAN check results can include output of the failures (whether they're in examples or the test suite, or an installation error). The API doesn't currently include that output, but thinking about how it could.
* Possibly update data more often. Right now we update once per day. Seems like results do roll in at different times though, perhaps as builds are done for each pkg?
* Notification service:  package maintainers can opt-in to notifications when their checks are failing so they can be on top of fixes quickly.  This could be managed through the API itself, with no GUI, but to make it palatable to all types may want to make a super simple web page to sign up. 

Check out the [issue tracker](https://github.com/ropensci/cchecksapi/issues) to follow progress or file a feature request or bug.

<br>

-----

## Thanks

Thanks to [Gábor Csárdi][gabor] for the idea to make a `/maintainers` route.

## Further reading

In a [similar post][cloud66] Cloud66 folks talked about deploying an API with the same stack essentially: Sinatra, MongoDB, and Docker. 

## p.s. 

I mostly write about R software, so some readers may use R: if you want to make a web API but only know R, try learning Ruby!  It can't hurt to learn Ruby, and you'll be happy you did. 


[cchecks]: https://github.com/ropensci/cchecksapi
[dopost]: https://www.digitalocean.com/community/tutorials/how-to-deploy-sinatra-based-ruby-web-applications-on-ubuntu-13
[cloud66]: http://blog.cloud66.com/deploying-rest-apis-to-docker-using-ruby-and-sinatra/
[Sinatra]: http://www.sinatrarb.com/
[CRAN]: https://cran.rstudio.com/web/packages/
[Rubygems]: https://rubygems.org/
[Pypi]: https://pypi.python.org/pypi
[forpkgs]: https://github.com/ropensci/cchecksapi/blob/master/scrape.rb
[formaint]: https://github.com/ropensci/cchecksapi/blob/master/scrape_maintainer.rb
[gabor]: https://github.com/gaborcsardi

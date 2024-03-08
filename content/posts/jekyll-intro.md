---
name: jekyll-intro
layout: post
title: Jekyll - an intro
date: 2013-11-20
author: Scott Chamberlain
sourceslug: _drafts/2013-11-20-jekyll-intro.md
tags:
- R
- github
- jekyll
- ruby
---

I started using Jekyll when I didn't really know HTML, CSS, or Ruby - so I've had to learn a lot - but using Jekyll has been a great learning experience for all those languages. 

I've tried to boil down steps to building a Jekyll site or blog to the minimal steps:

<br><br>

### Install Jekyll

+ Mac/Linux/Unix: 
	+ Install dependencies: 
		+ [Ruby](http://www.ruby-lang.org/en/downloads/)
		+ [RubyGems](http://rubygems.org/pages/download)
	+ Install Jekyll using RubyGems `gem install jekyll` (you may need to do `sudo...`)
	+ If you're having trouble installing, see the [troubleshooting page](http://jekyllrb.com/docs/troubleshooting/).
+ Windows: Jekyll doesn't officially support installation on Windows - follow [these steps](http://www.madhur.co.in/blog/2011/09/01/runningjekyllwindows.html) for a Windows install. 

<br><br>

### Make a site

The easiest way to get started is by using the command `jekyll new SITENAME` - let's replace `SITENAME` with `foobar` for this example.

So we run `jekyll new foobar`, which gives us:

```bash
New jekyll site installed in /Users/scottmac2/foobar.
```

Go into that directory, and run 

```bash
cd foobar
jekyll serve
```

Which gives you the files and directories:

```bash
|
--|- _config.yml
  |- _posts
  |- css
  |- _layouts
  |- _site
  |- index.html
```

Then point your browser to [http://localhost:4000/](http://localhost:4000/). And you should see the following:

![](http://f.cl.ly/items/2q322a2P3f2m2A3a3l0O/Screen%20Shot%202013-11-20%20at%209.54.21%20AM.png)

<br><br>

### Write a new blog post

We'll add a new file to the `_posts` folder. 

```bash
---
layout: post
title:  My second post
date:   2013-11-20
categories: jekyll programming R
---

My second blog post!
```

Paste this in to a new file in the `_posts` folder, save as today's date ({{ page.date | date: "%Y-%m-%d" }}) plus the post name, which gives us {{ page.date | date: "%Y-%m-%d" }}-second-post.md.

<br><br>

### Deploying

An obvious option given that Jekyll was built by Github, is to put it up on Github. Github has some instructions [here](http://jekyllrb.com/docs/github-pages/). Here is my attempt at instructions: 

+ If you don't have a Github account already, [create one](https://help.github.com/articles/signing-up-for-a-new-github-account) - it's free.
+ Set up Git. Github's help for this: https://help.github.com/articles/set-up-git
+ Creat a new repo on Github, with the same name as your repo on your machine, in this case `foobar`. 
+ Make your new blog directory `foobar` a git repo by doing `git init` within the repo.
+ Add you files to be tracked by git via `git add --all`
+ Commit your changes by `git commit -am 'new blog files added'`
+ Make a `gh-pages` branch by doing `git branch gh-pages`.
+ Add link for your repo on Github: `git remote add origin https://github.com/<yourgithubusername>/foobar.git`
+ Push to Github using `git push -u origin master`

Github gives you one repo that you can name `<yourgithubusername>.github.io` that will be viewable at the URL `http://<yourgithubusername>.github.io`. You can have your blog/website on the master branch, and you don't need to create a `gh-pages` branch. But if you have your site in any other named repo, you will need the `gh-pages` branch. If you don't use a `<yourgithubusername>.github.io` repo, your site will be viewable at `<yourgithubusername>.github.io/<reponame>`, in this case `<yourgithubusername>.github.io/foobar`. 

*Beginners take note:* Instead of the command line, you could use a Git GUI, from Github ([OSX](http://mac.github.com/), [Windows](http://windows.github.com/)), or others, e.g., [GitBox](http://gitboxapp.com/).

<br><br>

### Other info

That's the basics of how to get started. Inevitably, you'll run into problems with various dependencies. The [Jekyll site](http://jekyllrb.com/) has a lot of documntation now, so go there for help - and see a roundup of links below. 

For inspiration, here are many examples of sites that use Jekyll: http://jekyllrb.com/docs/sites/. If you want to build off someone else's work, find one that provides their code.

----------------

A roundup of links for building static sites with jekyll

* [http://net.tutsplus.com/tutorials/other/building-static-sites-with-jekyll/](http://net.tutsplus.com/tutorials/other/building-static-sites-with-jekyll/)
* [http://www.andrewmunsell.com/tutorials/jekyll-by-example/](http://www.andrewmunsell.com/tutorials/jekyll-by-example/)
* [Jekyll Bootstrap](http://jekyllbootstrap.com/)
* Jekyll thoughts by [Carl Boettiger](http://carlboettiger.info/index.html): [http://carlboettiger.info/2012/12/30/learning-jekyll.html](http://carlboettiger.info/2012/12/30/learning-jekyll.html)
* [http://danielmcgraw.com/2011/04/14/The-Ultimate-Guide-To-Getting-Started-With-Jekyll-Part-1/](http://danielmcgraw.com/2011/04/14/The-Ultimate-Guide-To-Getting-Started-With-Jekyll-Part-1/)
* [A book on building sites with Jekyll](http://mijingo.com/products/screencasts/static-websites-with-jekyll/)
* [http://yeswejekyll.com/](http://yeswejekyll.com/)
* [http://hellarobots.com/2012/01/06/blogging-with-jekyll-quickstart.html](http://hellarobots.com/2012/01/06/blogging-with-jekyll-quickstart.html)
* [http://www.sitepoint.com/zero-to-jekyll-in-20-minutes/](http://www.sitepoint.com/zero-to-jekyll-in-20-minutes/)

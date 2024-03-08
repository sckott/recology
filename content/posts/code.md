---
name: code
layout: post
title: On writing, sharing, collaborating, and hosting code for science
date: 2013-07-20
author: Scott Chamberlain
sourceslug: _drafts/2013-07-20-code.Rmd
tags:
- code
- github
---

I recently engaged with a number of tweeps in response to my tweet:

> Rule number 1 wrt science code: DO NOT post your code on your personal website

That tweet wasn't super clear, and it's difficult to convey my thoughts in a tweet. What I should have said was do post your code - ideally on Github/Bitbucket/etc. Here goes with a much longer version to explain what I meant. The tweet was just about where to host code, whereas the following is about more than that, but related.

### Code writing during analyses, etc.

When you write code to do simulations, analyses, data manipulation, visualization - whatever it is - it helps to version your code. That is, not naming files like *myfile_v1.r*, *myfile_v2.r*, etc., but with versioning using version control systems (VCS) like [git][git], [svn][svn], [mercurial][mc], etc. Although git will give you headaches during the learning process, it takes care of versioning your code for you, finding differences in different versions, helps you manage conflicts from different contributors, and allows you to restore that old code you accidentally deleted. 

And you don't have to use git or svn on a code hosting site - you can use git or svn locally on your own machine. However, there are many benefits to putting your code up on the interwebs. 

### Collaborating on code

Whenever you collaborate on code writing you have the extreme joy of dealing with conflicts. Perhaps you use Dropbox for collaborating on some code writing. Crap, now there is a line of code that messes up the analysis, and you don't know who put it there, and why it's there. Wouldn't it be nice to have a place to collect bugs in the code. 

All of these things become easy if you host code on a service such as Github. If you are already versioning your code with git you are in luck - all you need to do is create an account on github/bitbucket and push your code up. If not, you should definitley learn git.

Hosting your code on Github (or Bitbucket, etc.) allows each collaborator to work separately on the code simultaneously, then merge their code together, while git helps you take care of merging. An awesome feature of git (and other VCS's) is branching. What the heck is that? Basically, you can create a complete copy of your git project, do any changes you want, then throw it away or merge it back in to your main branch. Pretty sweet. 

### Sharing your code
 
Whether sharing your code with a collaborator, or with the world, if you put code on a website created specifically for hosting code, I would argue your life would be easier. Groups like Github and Bitbucket have solved a lot of problems around versioning code, displaying it, etc., whereas your website (whether it be Google sites, Wordpress, Tumblr, etc.) can not say the same. 

It is becoming clear to many that open science has many benefits. For the sake of transparency and contributing to the public science good, I would argue that sharing your code is the right thing to do, especially given that most of us are publicly funded. However, even if you don't want to share your code publicly, you can get free private hosting with an [academic discount on Github](https://github.com/edu), and Bitbucket gives you private hosting for free.

### Contributing to the software you use

Much of the software you and I use in R, Python, etc. is likely hosted on a code hosting platform such as Github, Bitbucket, R-Forge, etc. Code gets better faster if its users report bugs and request features to the software authors. By creating an account on Github, for example, to host your own code, you can easily report bugs or request features where others are developing software you use. This is better than email as only those two people get the benefit of learning from the conversation - while engaging where the software is created, or on a related mailing list, helps everyone. 

### On long-term availability of code

Where is the best place to host your code in the long-term. Some may trust their own website over a company - a company can go out of business, be sold to another company and then be shut down, etc. However, code on personal websites can also be lost if a person moves institutions, etc. If you use a VCS, and host your code on Bitbucket/Github/Etc., even if they shut down, you will always have the same code that was up on their site, and you can host it on the newer awesome code hosting site. In addition, even if a company shuts down and you have to move your code, you are getting all the benefits as stated above.

### Anyway...

My point is this: do post your code somewhere, even if on your own site, but I think you'll find that you and others can get the most out of your code if you host it on Bitbucket, Github, etc. Do tell me if you think I'm wrong and why.

### A few resources if you're so inclined

+ [Push, Pull, Fork: GitHub for Academics](http://hybridpedagogy.com/Journal/files/GitHub_for_Academics.html)
+ Carl Boettiger has some interesting posts on [research workflow](http://carlboettiger.info/2012/05/06/research-workflow.html) and [github issues as a research to do list](http://carlboettiger.info/2012/12/06/github-issues-tracker:-the-perfect-research-todo-list)
+ Do have a look at [Karthik Ram's][kr] paper on how git can facilitate greater reproducibility and transparency in science [here][karthik].
+ Github is posting a bunch of videos on Youtube that are quite helpful for learning how to use git and Github [here][gityou]
+ Git GUIs make using git easier:
	+ [SourceTree](http://www.sourcetreeapp.com/)
	+ [GitBox](http://gitboxapp.com/)
	+ [Github's git GUI](http://mac.github.com/)

[git]: http://git-scm.com/
[svn]: http://subversion.apache.org/
[karthik]: http://www.scfbm.org/content/8/1/7/abstract
[kr]: http://inundata.org/
[mc]: http://mercurial.selenic.com/wiki/
[gityou]: https://www.youtube.com/channel/UCP7RrmoueENv9TZts3HXXtw

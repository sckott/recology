--- 
name: moving-from-blogger-wordpress-to-jekyll
layout: post
title: Moving from blogger and wordpress to jekyll
date: 2012-01-11
categories: 
- thoughts
- blogger
- wordpress
- jekyll
---

Recology used to be hosted on Blogger, and my personal website was hosted on Wordpress.  Neither platform was very satisfying.  Blogger is very limited in their layouts, unless you use dynamic views, which suck because they don't allow javascript snippets to render GitHub gists.  Wordpress is just limited all around as you can't put in hardly anythig excep text and some pictures. They both have their place, but not so much for content that requires syntax highlighting, references, etc. 

[Jekyll][] powered sites on [GitHub][] are an awesome alternative.  You do have to write the code yourself, but you can copy any number of templates on GitHub with a simple `git clone` onto your machine, edit the text a bit, push it up to GitHub, and that's it.  

On Blogger and Wordpress you can't see the code behind why different blogs/sites look different.  But on Jekyll/GitHub you can see the code behind each site (see [here][] for a list of Jekyll/GitHub sites and their source code), which makes learning so easy.  

Here is a video on YouTube that explains in some detail Jekyll/GitHub sites:

<iframe width="560" height="315" src="http://www.youtube.com/embed/7mXeJlFdZ2c" frameborder="0" allowfullscreen></iframe>

A great point in the video above is that a Jekyll site allows a workflow that is great not only for code-junkies, but for scientists.  What is the most important thing about science?  That it is reproducible of course.   Documenting your code and sharing with everyone on GitHub or SVN, etc. is great for science in facilitating collaboration and facilitating transparency.  Having your website/blog on Jekyll fits right in to this workflow (that is, pull down any changes - write/edit something - commit - push to GitHub).  Although this sort of worklow isn't necessary for a blog, it is nice for scientists to use this workflow all the time. 


[Jekyll]: https://github.com/mojombo/jekyll
[GitHub]: https://github.com/
[here]: https://github.com/mojombo/jekyll/wiki/sites
---
name: sublime-text-workflow
layout: post
title: "My Sublime Text workflow/setup"
date: 2018-01-31
author: Scott Chamberlain
sourceslug: _drafts/2018-01-31-sublime-text-workflow.Rmd
tags:
- R
- sublime-text
- workflow
---

[Sublime Text][sb] is pretty great. 

Let's start at the beginning. 

Why would my primary editing tool not be vim? My background is as a biologist, spending way to many years in grad school. My first programming language was [R][] back in 2006; my first text editor about the same year was [Notepad++][np]; my first interaction with the cli was probably a year later or so (but that was on Windows).

After using Notepad++ for a few years, I stumbled upon Sublime Text via advice from a friend. I used it for a few years without paying (which you can still do), and after that realized it was worth paying for. They now have an easy to use [Discourse forum](https://forum.sublimetext.com/) too.

Anyway, vim is too intimidating to me, and at this point I like my workflow enough to not want to spend the time learning vim.

## Why Sublime Text?

I have found Sublime Text to be faster than at least [Atom][], ESPECIALLY when dealing with large files. Atom seems to get bogged down with a very large file and you can take a long time to scroll through it. 

I like the idea of supporting the small team behind Sublime Text rather than the presumably large team behind Atom or the presumably extremely large team behind [vscode][].

Can't think of any other reasons - the speed one is enough reason :)

p.s. I've never tried vscode.

## Why R and Sublime Text?

RStudio has been great, and I still use it from time to time. However, it's started to be buggy here and there, and anyway, I do most everything else in Sublime Text so it doesn't take much to push me towards Sublime Text for every project I do. I definitely prefer RStudio when working on R packages that include C++ code as it helps me out a lot as a C++ newb. 

The key thing that brought me over to using Sublime Text and R is being able to send code reliably to my cli of choice with a keyboard shortcut (see `SendCode` below).

I do development in other languages besides R - primarily Ruby and Python - so having a primary workflow that is agnostic with respect to the programming language is really nice.

## My Sublime Text packages

(check out SB packages at <https://packagecontrol.io/>)

* [GitSavvy](https://packagecontrol.io/packages/GitSavvy)
    * lots of good Git goodies
* [MarkdownEditing](https://packagecontrol.io/packages/MarkdownEditing)
    * gotta have markdown support
* [R-Box](https://packagecontrol.io/packages/R-Box)
    * lots of R tools including building and installing packages
* [SendCode](https://packagecontrol.io/packages/SendCode)
    * crucial for using Sublime Text and R on the cli - sends code from Sublime Text to your cli of choice. I use [iTerm2][] as my cli.
* [GotoWindow](https://packagecontrol.io/packages/GotoWindow)
    * speeds up your work a lot by quickly switching between projects with a keyboard shortcut
* [Marked integration](https://github.com/icio/sublime-text-marked)
    * Marked is a great markdown app - really nice to have an integration with Marked to quickly open it from Sublime

## Other useful things

* Do make sure to enable `subl` - a shortcut cli command to open Sublime Text - see <https://stackoverflow.com/questions/16199581/open-sublime-text-from-terminal-in-macos> for discussion of how to do it. It's use case for me is opening up the current directory on your cli in Sublime Text.
* Set Sublime Text as your default editor for git work, check out <https://help.github.com/articles/associating-text-editors-with-git/> for guidance
* Unrelated to Sublime Text, but if you go this route of separate text editor and cli, then arranging windows can start to slow you down a bit. On osx, there's a little app called [Spectacle][] that provides keyboard shortcuts for easily arranging windows in lots of combinations.

## The setup

![](/2018-01-31-sublime-text-workflow/sbandr.png)

[sb]: https://www.sublimetext.com/
[R]: https://www.r-project.org/
[np]: https://notepad-plus-plus.org/
[iTerm2]: https://www.iterm2.com/
[vscode]: https://code.visualstudio.com/
[atom]: https://atom.io/
[Spectacle]: https://www.spectacleapp.com/

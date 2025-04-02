---
name: web-frameworks
layout: post
title: "Picking a web framework"
date: 2025-03-27
author: Scott Chamberlain
tags:
- ruby
- rails
- javascript
- svelte
- python
- htmx
- html
---

Over the past few months at work we've been looking into web framework options for a project that currently uses [R Shiny][shiny]. Our needs have grown beyond what Shiny can provide. We decided to try Rails, SvelteKit, and HTMX/FastAPI to see which one would best suit our needs.

## The frameworks

Info and links on each:

- [Rails][]
  - Main language: [Ruby][ruby]
  - Docs: [Rails Guides](https://guides.rubyonrails.org/)
- [Svelte Kit][kit]
  - Main language: [JavaScript][javascript]
  - Docs: [Svelte Kit Docs](https://kit.svelte.dev/docs/)
- [HTMX][]/[FastAPI][]
  - Main language: [Python][python]
  - Docs: [HTMX Docs](https://htmx.org/docs/), [FastAPI Docs](https://fastapi.tiangolo.com/)

## Build minimal apps

I built a minimal version of our existing Shiny app using each framework. For each app I created only the landing page, and two other pages - in total these three pages encompassed a lot of the complexity of the app, and allowed me to get a feel for how it would be to use each framework IRL. Because of *reasons* I'm not going to share these minimal apps.

The salient point I want to make is that it's important to actually use each framework to have opinions grounded in experience rather than other people's opinions.

## How to decide?

Ideally there would be an existing decision framework for deciding what web framework to use. Unfortunately, I haven't found such a decision framework.

Thus, I cobbled together a short list of factors to consider:

- Programming language(s)
- What is the community like? Can we get help (from humans, AI, docs, FH expertise, etc.)?
- Can we iterate quickly?
- Extension support
- Performance/scalability requirements
- Good for our team? (small learning curve, maintainable)

## The outcome

Here's what I landed on:

| Topic | Rails | Svelte | HTMX/FastAPI |
|---------|:-----:|:------:|:------:|
| Lang.      | -- | -- | <i class="fa-solid fa-circle-check"></i> |
| Comm/Help  | -- | -- | -- |
| Iterate    | -- | -- | <i class="fa-solid fa-circle-check"></i> |
| Ext.       | -- | <i class="fa-solid fa-circle-check"></i> | -- |
| Perf./Scal.| -- | <i class="fa-solid fa-circle-check"></i> |   -- |
| Our team | -- | -- | <i class="fa-solid fa-circle-check"></i> |

Explanation of the above outcomes:

- Language: I am - and fellow team members are - more proficient in Python than JavaScript and Ruby.
- Community/Help: This one is not clear cut because I'd need more time with each framework, but first impressions are that HTMX/FastAPI is slightly easier to navigate and get help with - but that is maybe due to just being more familiar with Python vs. the other languages.
- Iterate: Iterating quickly is essential. Part of that is up to the PM/whoever is running the project - but with respect to technology, having a programming language you're comfortable with, and that's easy to write tests for, goes a long way.
- Extension support: Javascript has the largest ecosystem of any language, but Python is no slouch. Ruby also has a massive number of gems.
- Performance/scalability: In my playing around with these frameworks Svelte felt the snappiest, and opinions on the internet seem to suggest the same.
- Good for our team: We have a small team. AFAICT that's unlikely to change - if any, only slightly. Therefore, it's critical that the framework we choose is easy to get started with, easy to maintain, easy to reason about, and easy to debug.

### Squishier factors

There were many other factors that contributed to the outcome that were even less quantifiable:

- Navigation through files: Rails and Sveltekit have larger trees (number of files and nestedness) than HTMX/FastAPI - thus the latter was easier to navigate.
- Familiarity with the programming language: Mentioned above, but additional things related to the language are:
  - tests: I'm very comfortable with python testing tools, and very unfamiliar with Ruby and JS testing tools
  - knowing where to look: this is hard to quantify but for python I just kinda know where to look if I need help whereas with Ruby and Javascript I'm less familiar with where to look
- What do I like using personally: I love using Ruby, so I'd be happy with landing on Rails. However, Rails wasn't the best option for other reasons
- What can we hire for easily? In our space, at least AFAICT it'd be easiest to hire folks with a Python background
- Will the team continue to be the same size? or will it grow/shrink?: AFAICT we're not likely to grow much, so picking a framework that a small team can manage is critical
- User growth? If we expect rapid growth in number of users of our app, we'd want to account for that

## Framework specific observations

### Rails

- Rails seems to be ideal for a database backed app - e.g., like a shop where users create accounts, put things in their cart, checkout, etc. Our app is not that: it handles auth with a remote database, and it primarily is a dashboard for work being run on the Fred Hutch clusters.
- Rails logs are really nice, including SQL queries and request/response details - but that's not our use case
- The magic variables of Rails is not helpful for me at least
- No live reload out of the box - and I didn't find an easy solution - this is not great
- Out of the box has a loading bar at the very top, which is really nice
- Debugging is great, opens a debugging window right in the app tab
- `config/routes.rb` was hard to grok for me
- there's no search on the [Rails docs site](https://guides.rubyonrails.org/) - which is kind of baffling

### Svelte Kit

- Svelte Kit felt easy to use considering I have very little javascript experience. However, it felt harder to reason about how things fit together than Rails or HTMX/FastAPI.
- I really liked using components (JS + HTML + CSS in a single file). It was a new concept to me, but it felt very intuitive. It's really nice to be able to in one file have the JS, HTML, and CSS all in the same view for the component.
- Being able to opt in to type safe Typescript seems very appealing - the other frameworks don't have that as nicely (though Ruby has [sorbet](https://sorbet.org/), and Python has [mypy](https://mypy-lang.org/))
- Logs were hard to decipher for me at least
- Since it's JS, nice to be able to just hop into the browser console and debug

### HTMX/FastAPI

- An important reason why I think we'll go with this framework is that we can more quickly get things done. I'll explain: I'm going to be the main developer of the next iteration of the app, and I know Python pretty well, and Javascript very little. In the future if the app is around, sure, you can hire easily for either. For now, I'm more comfortable with Python, and some team members that may contribute or review code are more comfortable with Python too. Although I haven't spent a ton of time with HTMX yet, I love the idea of the Javascript parts being expressed within HTML attributes.
- Had to use a 3rd party library for auto-reload of the UI - but came out of box with server reload
- FastAPI comes with OpenAPI browser docs for the server API which is a really nice feature

## A simple heuristic?

There's alot that can go into picking a web framework. Somtimes I wonder if there any simpler heuristics that can be used to pick a framework.

What if we simply look at the file structure for a default project for each framework? The following is a screenshot of the file structure for each of (left to right) Rails, Svelte, and HTMX/FastAPI using the [tree][] command:

```bash
tree -L 3 -I '.git|__py_cache__|node_modules|public|bin'
```

Where `-L` means 3 levels deep from the root of each directory, and `-I` excludes gitignored files/dirs, and manually ignore rendered file dirs, and binaries, etc. The yellow tree tips are directories.

<img src="/proof-web-frameworks.jpg" height="400" alt="tree comparison of rails, svelte, htmx/fastapi">

The comparison is quite stark: Rails has a lot going on, HTMX/FastAPI has very little going on, and Svelte is in the middle (leaning closer to HTMX/FastAPI).

This could be looked at two different ways. One, for Rails proponents this is probably just a reflection of the desired batteries included approach (and I do realize many Rails components/features are optional). The other though is that with Rails there's a lot going on and a lot to hold in your head at one time, whereas with HTMX/FastAPI there's very little complexity and therefore may be easier to reason about.

## What's next?

When we get the green light to work on this, we'll try HTMX/FastAPI first, and hopefully that will suit or our needs. If it doesn't I'd likely reach for Svelte Kit as the next option.

## Lingering questions

- How much time should you spend deciding which framework to use?
  - Presumably scales with how big the goal is? Deciding for a single project, or for many future projects. How complex are the requirements? If very complex probably requires more time.
- How to best judge the health of a framework?
  - I feel like i have a good sense for how to do this, but curious what others do and if anyone uses some kind of quantitative measure. If you are already deeply familiar with the community you probably have insider knowledge that folks do not have that are new to the community (e.g., xyz framework is maintained by one person and although they do a great job they are just one person).

[shiny]: https://shiny.posit.co/
[Rails]: https://rubyonrails.org/
[ruby]: https://www.ruby-lang.org/en/
[kit]: https://svelte.dev/docs/kit/introduction
[javascript]: https://en.wikipedia.org/wiki/JavaScript
[HTMX]: https://htmx.org/
[FastAPI]: https://fastapi.tiangolo.com/
[python]: https://www.python.org/
[tree]: https://linux.die.net/man/1/tree

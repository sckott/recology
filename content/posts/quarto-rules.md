---
name: quarto-rules
layout: post
title: "Software rules and Quarto"
date: 2024-09-26
author: Scott Chamberlain
tags:
- quarto
---

At [work][] I've been using [Quarto][] quite a bit for website and books for work projects.

One of the projects I've been working on lately that uses Quarto is the [WILDS Contributor Guide][wildsguide] (WILDS = _Workflows Integrating Large Data and Software_). This guide (a Quarto book) is mostly a guide for our own immediate team members, but aims to a) be a guide for any contributors to our open source software work, and b) demonstrate good open source software practices for the greater [Fred Hutch][work] community where we work.

Whenever there's a group of people working on the same software, it can help to have some guidelines - or rules - for how software should be built. With any group there's likely to be some aspects that are left up to the individual, whereas other aspects should be enforced rules.

There are many benefits to having everyone follow the same set of rules, including a predictable and consistent software building culture, and trust from the users of the software that the maintainers have reasonable guard rails (assuming those rules are transparent; see note below about [Transparency]({{<ref "#transparency" >}}) ).

For the rules, how do we:

- enforce them with the least effort possible? this is not out of laziness for its own sake, but realizing that if it's not easy it may not happen
- keep track of any changes in rules (in our case the [WILDS Guide][wildsguide]) so that what we say we do is what we actually do

Searching around I haven't found much out there that formalizes this. There's some great transparent and documented stuff out there, e.g. [Thoughtbot's playbook](https://thoughtbot.com/playbook#developing) - but they don't describe how they check that their employees do what they say they should do.

What we're doing is the following:

- In our [WILDS Guide][wildsguide] we have:
	- Easy to find rules for humans ... that are defined with
	- Machine readable rules for machines
- For rule compliance repos will have their on GitHub Actions running various things
- For automatable rule compliance across repos we're using GitHub Actions. I've just started work on this automated compliance at <https://github.com/getwilds/rules>. You can see [an example](https://github.com/getwilds/rules/actions/runs/10892898375/job/30226762776#step:6:13) of one of the rule checks output
- For rule compliance that requires human review we'll enfuse into the culture the actions that need to be taken

This is very much a work in progress, and could be a fool's errand. Maybe all this rule compliance stuff will make it too hard to get work done. Maybe it will just be too complicated and the work of doing all of this isn't worth it; i.e., rule compliance  isn't the goal, but is just a tool to get our real work done and build trust in the community.

I'd love to hear what's working - and what's not - for other folks. Holla at me on [Mastodon][] or [Bluesky][].

----

If you're interested in the details ...

### Machine readable

The machine readable rules are defined using Quarto's `_variables.yml` file, ours is at <https://github.com/getwilds/guide/blob/main/_variables.yml>. A snippet of it:

```yaml
version: 1.2
rules:
  merge-main-release: >
    Every merge from `dev` into `main` should constitute a release, which
    should generate a tagged version of the software and an increment to the
    version number
  release-tags: Code releases that correspond to specific git tags.
```

The great thing about this approach is that it's a single file and it's easy for a machine to read. So a machine can watch for any changes in this file to trigger any todo's in other places.

That's not how I started though. My first thought was child documents, thinking that it would make it clear to have a separate "rules" dir in the repo with a separate child callout in a qmd file for every rule. This looked like

```
::: {.callout-note icon=false}

## {{ iconify carbon rule-draft }} Rule

At least two but no more than three designated project leads (specified in the [CODEOWNERS file][codeowners]).
:::
```

### Appearance of rules

I ended up using just simple Bootstrap badges with icons at the beginning of a rule to indicate that it's a rule. I disregarded this at first as I thought it wasn't grabbing the readers attention enough. But this allowed flexibility to have a rule be embedded within a paragraph or be on its own line in a bullet or not.

![screenshot of callouts on WILDS guide](/quarto-rules/badge.png)

However, my first gut feeling was to use alerts, or what Quarto calls "callouts". 

![screenshot of callouts on WILDS guide](/quarto-rules/guide-callout.png)

The landing page of our WILDS guide has [a section describing the rules](http://getwilds.org/guide/#rules).

### Transparency

The building trust part of my motivation above I think means that rules need to be transparent to users. If this is done well I think it makes our lives easier as well. 

What I mean in practice is the following. So I discussed how we're using badges to indicate a rule in our guide above. One way to approach this is if you click on one of the badges it brings you to another page or github repo that has more details, including more words about how it's implemented, and link to a automated GH Action that does the check or to docs about how a human review is done. This doesn't exist yet.



[work]: https://www.fredhutch.org/en.html
[Quarto]: https://quarto.org/docs/guide/
[wildsguide]: http://getwilds.org/guide/
[Mastodon]: https://fosstodon.org/@sckottie
[Bluesky]: https://bsky.app/profile/sckott.bsky.social

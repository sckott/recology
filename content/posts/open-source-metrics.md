---
name: open-source-metrics
layout: post
title: Metrics for open source projects
date: 2015-10-19
author: Scott Chamberlain
sourceslug: _drafts/2015-10-19-open-source-metrics.Rmd
tags:
- data
- open source
- altmetrics
- code
- ropensci
- R
---



Measuring use of open source software isn't always straightforward. The problem is especially acute for software targeted largely at academia, where usage is not measured just by software downloads, but also by citations.

Citations are a well-known pain point because the citation graph is privately held by iron doors (e.g., [Scopus][scopus], [Google Scholar][schol]). New ventures aim to open up citation data, but of course it's an immense amount of work, and so does not come quickly.

The following is a laundry list of metrics on software of which I am aware, and some of which I use in our [rOpenSci twice monthly updates][news].

I primarily develop software for the R language, so some of the metrics are specific to R, but many are not. In addition, we (rOpenSci) don't develop web apps, which may bring in an additional set of metrics not covered below.

I organize by source instead of type of data because some sources give multiple kinds of data - I note what kinds of data they give with <span class="label label-default">labels</span>.

## CRAN downloads

{{< rawhtml >}}
<span class="label label-warning">downloads</span>
{{< /rawhtml >}}

- Link: [https://github.com/metacran/cranlogs.app](https://github.com/metacran/cranlogs.app)
- This is a REST API for CRAN downloads from the RStudio CRAN CDN. Note however, that the RStudio CDN is only one of many - there are other mirrors users can insall packages from, and are not included in this count. However, a significant portion of downloads probably come from the RStudio CDN.
- Other programming languages have similar support, e.g., [Ruby](https://guides.rubygems.org/rubygems-org-api/) and [Node](https://github.com/npm/download-counts).

## Lagotto

<small><span class="label label-success">citations</span>&nbsp;<span class="label label-info">github</span>&nbsp;<span class="label label-primary">social-media</span></small>

- Link: [https://software.lagotto.io/works](https://software.lagotto.io/works)
- Lagotto is a Rails application, developed by [Martin Fenner](https://github.com/mfenner), originally designed to collect and provide article level metrics for scientific publications at Public Library of Science. It is now used by many publishers, and there are installations of Lagotto targeting [datasets](https://mdc.lagotto.io/) and [software](https://software.lagotto.io/works).
- Discussion forum: [https://discuss.lagotto.io/](https://discuss.lagotto.io/)

## Depsy

<small><span class="label label-success">citations</span>&nbsp;<span class="label label-info">github</span></small>

- Link: [https://depsy.org](https://depsy.org)
- This is a nascent venture by the [ImpactStory team](https://impactstory.org/about) that seeks to uncover the impact of research software. As far as I can tell, they'll collect usage via software downloads and citations in the literature.

## Web Site Analytics

<small><span class="label label-danger">page-views</span></small>

- If you happen to have a website for your project, collecting analytics is a way to gauge views of the landing page, and any help/tutorial pages you may have. A good easy way to do this is a deploy a basic site on your `gh-pages` branch of your GitHub repo, and use the easily integrated Google Analytics.
- Whatever analytics you use, in my experience this mostly brings up links from google searches and blog posts that may mention your project
- Google Analytics beacon (for README views): [https://github.com/igrigorik/ga-beacon](https://github.com/igrigorik/ga-beacon). I haven't tried this yet, but seems promising.

## Auomated tracking: SSNMP

<small><span class="label label-success">citations</span>&nbsp;<span class="label label-info">github</span></small>

- Link: [https://scisoft-net-map.isri.cmu.edu](https://scisoft-net-map.isri.cmu.edu)
- Scientific Software Network Map Project
- This is a cool NSF funded project by Chris Bogart that tracks software usage via GitHub and citations in literature.  

## Google Scholar

<small><span class="label label-success">citations</span></small>

- Link: [https://scholar.google.com/](https://scholar.google.com/)
- Searching Google Scholar for software citations manually is fine at a small scale, but at a larger scale scraping is best. However, you're not legally supposed to do this, and Google will shut you down.
- Could try using g-scholar alerts as well, especially if new citations of your work are infrequent.
- If you have institutional access to Scopus/Web of Science, you could search those, but I don't push this as an option since it's available to so few.

## GitHub

<small><span class="label label-info">github</span></small>

- Links: [https://developer.github.com/v3/](https://developer.github.com/v3/)
- I keep a list of rOpenSci uses found in GitHub repos at [https://discuss.ropensci.org/t/use-of-some-ropensci-packages-on-github/137](https://discuss.ropensci.org/t/use-of-some-ropensci-packages-on-github/137)
- GitHub does collect traffic data on each repo (clones, downloads, page views), but they are not exposed in the API. I've bugged them a bit about this - hopefully we'll be able to get that dat in their API soon.
- Bitbucket/Gitlab - don't use them, but I assume they also provide some metrics via their APIs

## Other

- Support forums: Whether you use UserVoice, Discourse, Google Groups, Gitter, etc., depending on your viewpoint, these interactions could be counted as metrics of software usage. 
- Emails: I personally get a lot of emails asking for help with software I maintain. I imagine this is true for most software developers. Counting these could be another metric of software usage, although I never have counted mine.
- Social media: See Lagotto above, which tracks some social media outlets.
- Code coverage: There are many options now for code coverage, integrated with each Travis-CI build. A good option is [CodeCov](https://codecov.io). CodeCov gives percentage test coverage, which one could use as one measure of code quality.
- Reviews: There isn't a lot of code review going on that I'm aware of. Even if there was, I suppose this would just be a logical TRUE/FALSE.
- Cash money y'all: Grants/consulting income/etc. could be counted as a metric.
- Users: If you require users to create an account or similar before getting your software, you have a sense of number of users and perhaps their demographics.

## Promising

Some software metrics things on the horizon that look interesting:

* [Software Attribution for Geoscience Applications][saga] (SAGA)
* Crossref: They have [a very nice API][crapi], but they don't yet provide citation counts - but [they may soon][crmaybe].
* [njsmith/sempervirens](https://github.com/njsmith/sempervirens) - a prototype for _gathering anonymous, opt-in usage data for open scientific software_
* [Force11 Software Citation Working Group](https://github.com/force11/force11-scwg) - _...produce a consolidated set of citation principles in order to encourage broad adoption of a consistent policy for software citation across disciplines and venues_

## Missed?

I'm sure I missed things. Let me know.

[scopus]: https://www.scopus.com/
[schol]: https://scholar.google.com/
[saga]: https://geodynamics.org/cig/projects/saga/
[crapi]: https://github.com/CrossRef/rest-api-doc/blob/master/rest_api.md
[crmaybe]: https://github.com/CrossRef/rest-api-doc/issues/46
[neil]: https://youtu.be/jMH7FTGqQEE?t=1h3m41s
[wssspe3]: https://wssspe.researchcomputing.org.uk/wssspe3/
[news]: https://ropensci.github.io/biweekly/

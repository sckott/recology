---
name: open-schol
layout: post
title: Thoughts on principles for open scholarly infrastructure
date: 2015-10-19
author: Scott Chamberlain
sourceslug: _drafts/2015-10-19-open-schol.Rmd
tags:
- infrastructure
- open science
---

[Geoff Bilder][geoff], [Jennifer Lin][jlin], and [Cameron Neylon][cam] wrote a great [post][post] back in February this year titled _Principles for Open Scholarly Infrastructures_ [^1]. In it, they explore the principles, describe why we need them, and talk a bit about implementation.

We thought this could be applied to software as well. We discuss this with respect to rOpenSci specifically, but make broader points about software.

## Their principles

They discussed three principles, and within each of the three principles they outlined a set of guidelines to follow. What follows is a short synopsis of each guideline, and we address some of the (paraphrased) points they brought up under each principle (those that apply more to software).

### Governance

> If an infrastructure is successful and becomes critical to the community, we need to ensure it is not co-opted by particular interest groups.

### Sustainability

> An organisation that is both well meaning and has the right expertise will still not be trusted if it does not have sustainable resources to execute its mission.

### Insurance

> Long term trust requires the community to believe it retains control.

## Software principles

Towards the end of the post, they ask:

> What would an organisation actually look like if run on these principles?

They list [ORCID][orcid] and [CERN][cern] as examples. They didn't mention software per se, but I think software can be thought of as infrastructure. I think [rOpenSci][ros] is an example of software infrastructure. Let me explain.

Are we really infrastructure? I think we are in a sense. We are building a long-lasting framework for building and maintaining software, supporting the people that make the software, and maintaing the underlying tools to make it all run smoothly. 

The breadth of our work is increasing. We started making software clients to work with data in ecology and evolutionary biology. Since then, we've branched out to many disciplines, and many types of tools. 

Our community...

We provide a number of services that are infrastructury:

* Code review (see our [onboarding process][onboarding])
* Community standards for quality software (see our [development guidlines][guide] and [policies][policies])
* General purpose software that solves all reasonable use cases
* Liberally licensed software that can be used in all settings (almost all our software is [MIT][mit] licensed)
* Low level clients for many data science tools

In some ways, rOpenSci isn't infrastructure. For example, we are specific to a single programming language. However, this could change in time, and anyway, R is one language, but used across all sectors and in all disciplines. 

### Addressing principles in software

* Insurance - The open source nature of our software only addresses this principle. That is, liberally licensed open source software goes a long way towards making sure that the software is owned by the community (even if properietary derivatives are made).
    * __Open source__: Bingo! Everything we do is open source. This is suprisingly not ubiquotous in academic software, due to combination of some not bothering to use a license (essentially meaning it can't be re-used anywhere), or using a very restrictive license, either out of not considering the consequences or on purpose for competitive or monetary gain.
    * __Open data__: We're not a data provider, but if/when we do, it will surely be completely open.
* Governance 
    * __Be cross-disiplinary__: We started out narrowly focused on ecology and evolution, as we started rOpenSci while during graduate work on the topic. Since then, we've recognized many pain points across disciplines that could be greatly ameliorated by good software.
    * __Be transparent__: We've strived to be open about our governance, and will continue to do so. The Jupyter and Dat projects are great examples of this.
* Sustainability
    * __Mission consistent revenue__: We're lucky in that we've found funding from foundations that share our goals. This is critical to our long-term success so that our mission doesn't diverge from its path.
    * __Revenue based on services, not data__: Exactly! In software, this means make open source software, which we do - all open licensed, free to use from academic to non-profit to enterprise. Instead of value-added services, we offer assurance of quality and long-term maintenance, both in short supply in academic software.

[^1]: “Bilder G, Lin J, Neylon C (2015) Principles for Open Scholarly Infrastructure-v1, retrieved 2015-10-15, http://dx.doi.org/10.6084/m9.figshare.1314859”

[geoff]: http://www.gbilder.com/blog/
[jlin]: https://about.me/jenniferlin
[cam]: http://cameronneylon.net/
[post]: http://cameronneylon.net/blog/principles-for-open-scholarly-infrastructures/
[orcid]: http://orcid.org/
[cern]: http://home.web.cern.ch/
[ros]: http://ropensci.org/
[onboarding]: https://github.com/ropensci/onboarding
[guide]: https://github.com/ropensci/packaging_guide
[policies]: https://github.com/ropensci/policies
[mit]: http://choosealicense.com/licenses/mit/

--- 
name: science-publications-need-interactive-graphics
layout: post
title: Journal Articles Need Interactive Graphics
date: 2012-02-25
author: Pascal Mickelson
tags: 
- datavisualization
- publishing
- interactivegraphics
---

I should have thought of it earlier: In a day and age when we are increasingly reading scientific literature on computer screens, why is it that we limit our peer-reviewed data representation to static, unchanging graphs and plots? Why do we not try to create dynamic visualizations of our rich and varied data sets? Would we not derive benefits in the quality and clarity of scientific discourse from publishing these visualizations?

An article in the very good (and under-appreciated, in my opinion) *[American Scientist][]* magazine written by Brian Hayes started me thinking about these questions.  ["Pixels or Perish"][PorP] begins by recapping the evolution of graphics in scientific publications and notes that before people were good at making plots digitally, they were good at making figures from using photographic techniques; and before that, from elaborate engravings.  Clearly, the state-of-the-art in scientific publishing is a moving target.

Hayes points out that one of the primary advantages of static images is that everyone knows how to use them and that almost no one lacks the tools to view them.  That is, printed images in a magazine or static digital images in the portable document format (pdf) are easily viewed on paper or on a screen and can be readily interpreted by a wide audience.  While I agree that this feature is very important, why have we not, as scientists, moved to the next level?  We do not lack the ability to interpret data--it is our job to do so--not to mention that we are some of the heaviest generators of data in the first place.

The obstacles to progress towards interactive data are two-fold.  First, generating dynamic data visualizations is not as easy as generating static plots.  The data visualization tools simply are not as well developed and they do not show up as frequently in the programming environments in which scientists work.  One example Hayes cites is that the ideas from programs such as [D^3][dthree] have not yet made an appearance in software, like [R][] and [Matlab][], that more scientists use. This is one reason why I am so excited by the work that our very own [Scott][] has been doing with this [Recology][] blog, in trying to promote awareness of tools in [R][].

The second is that neither of our currently dominant publishing formats (physical paper and digital pdf files) support dynamic graphics. Hayes says it better than I could: "…the Web is not where scientists publish…\[publications are\]…available *through* the Web, not *on* the Web."  So, not many current publications really take advantage of the new capabilities that the Web has offered us to showcase dynamic data sets.  In fact, while [Science][] and [Nature][]--just to name two prominent examples of scientific journals--make available HTML versions of their articles, it seems like most of the interactivity is limited to looking at larger versions of figures in the articles\*.  I myself usually just download the pdf version of articles rather than viewing the HTML version.  This obstacle, however, is not a fundamental one; it is only the current situation.

The more serious obstacle that Hayes foresees in transitioning to dynamic graphics is one of archiving. Figures in journal articles printed in 1900 are still readable today, but there is no guarantee that a particular file format will survive in usable form to 2100, or even 2020.  I do not know the answer to this conundrum.  A balance might need to be struck between generating static and dynamic data.  At least in the medium term, papers should probably also contain static versions of figures representing dynamic data sets. It is inelegant, but it could avoid the situation where we lose access to information that was once there.

That said, if the [New York Times][nytimes] can do it, so can we.  We should not wait to make our data presentation more dynamic and interactive.  At first, it will be difficult to incorporate these kinds of figures into the articles themselves, and they will likely be relegated to the "supplemental material" dead zone that is infrequently viewed.  But the more dynamic material that journals receive from authors, the more incentive they will have to expand upon their current offerings.  Ultimately, doing so will greatly improve the quality of scientific discourse.

[nytimes]: http://www.nytimes.com
[American Scientist]: http://www.americanscientist.org/
[PorP]: http://www.americanscientist.org/issues/pub/pixels-or-perish
[dthree]: http://vis.stanford.edu/files/2011-D3-InfoVis.pdf
[R]: http://www.r-project.org/
[Matlab]: http://www.mathworks.com/products/matlab/
[Scott]: http://schamberlain.github.com/recologyabout.html
[Science]: http://www.sciencemag.org/
[Nature]: http://wwww.nature.com
[Recology]: http://schamberlain.github.com/

<small>* Whether the lack of dynamic data visualization on these journals' websites is due to the authors not submitting such material or due to restrictions from the journals themselves, I do not know. I suspect the burden falls more on the authors' shoulders at this point than the journals'.</small>
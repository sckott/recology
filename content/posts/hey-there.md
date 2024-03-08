---
name: hey-there
layout: post
title: heythere - a robot to automate GitHub issue comments
date: 2016-03-24
sourceslug: _drafts/2016-03-24-hey-there.md
tags:
- ruby
- peer-review
- review
- robot
---

GitHub issues are great for humans to correspond over software, or any other project. At rOpenSci we use an issue based software review system ([ropensci/onboarding](https://github.com/ropensci/onboarding)). Software authors and reviewers go back and forth on the software, making a better product in the end.

We have a relatively small number of pieces of software under review at any one time compared to e.g., scientific journals - however, even with the small number, we as organizers, and authors and reviewers can forget things. For example:

* an organizer can forget to remind a reviewer to get a review in
* a reviewer can forget about a review, and may benefit from a friendly reminder
* an author may forget about updating software based on the review

As we are managing more package submissions through our system, automated things done by machine, or robot, will be increasingly helpful to keep the system moving smoothly.

A big red flag with automated systems is the annoyance factor. We can try to be smart about this and only remind people when it's really needed.

I've been working on a thing for a while now, it's called `heythere`. It's a Ruby application that is currently set up to run on Heroku, though you could run it anywhere you want. It's running right now once per day to check to see if it should send any reminders to organizers, authors, reviewers.

`heythere` on GitHub: [ropenscilabs/heythere][ht]

## How it works

`heythere` is controlled through a series of environment variables that controls GitHub authentication, the first day post reviewer assignment when a reminder should be sent, how many days after reviews are submitted to ask if the author needs any help, and more. Check out the [repo][ht] for all the env var options.

The Ruby app can be run via a rake task from the command line, or triggered with a scheduler on something like Heroku.

When the app runs, we look for environment variables that you set. If we don't find them we use sensible defaults.

Using the env vars, we grab the issues for the repository you chose, limit to a subset of your choosing based on a series of labels, then compare dates on comments compared to your env vars, and either skip or send of comments on issues.

We use [ockokit](https://github.com/octokit/octokit.rb) under the hood to work with GitHub issues.

## How to use it

### clone

```
git clone git@github.com:ropenscilabs/heythere.git
cd heythere
```

### setup

Change the repo in `Rakefile` to whatever your repository is.

```ruby
Heythere.hey_there(repo = 'ropensci/onboarding')
```

Create the app (use a different name, of course)

```bash
heroku apps:create ropensci-hey-there
```

Add the repository that you are targeting:

```bash
heroku config:add HEYTHERE_REPOSITORY=<github-repository> (like `owner/repo`)
```

Create a GitHub personal access token just for this application. You'll need to set a env var for your username and the token. We read these in the app.

```bash
heroku config:add GITHUB_USERNAME=<github-user>
heroku config:add GITHUB_PAT_OCTOKIT=<github-pat-for-octokit>
```

Optionally, set env vars for various options. You don't have to set these - we'll use defaults

```bash
heroku config:add HEYTHERE_PRE_DEADLINE_DAYS=<number-of-days-integer>
heroku config:add HEYTHERE_DEADLINE_DAYS=<number-of-days-integer>
heroku config:add HEYTHERE_POST_DEADLINE_EVERY_DAYS=<number-of-days-integer>
heroku config:add HEYTHERE_POST_REVIEW_IN_DAYS=<number-of-days-integer>
heroku config:add HEYTHERE_POST_REVIEW_TOGGLE=<boolean>
heroku config:add HEYTHERE_BOT_NICKNAME=<string>
```

Also save all these env vars in your `.bash_profile`, `.zshrc`, or similar so you can run the app locally. E.g. with entries like `export HEYTHERE_PRE_DEADLINE_DAYS=15`

You can see all your Heroku config vars using `heroku config` or use `rake envs`

Push your app to Heroku

```bash
git push heroku master
```

Add the scheduler to your heroku app

```bash
heroku addons:create scheduler:standard
heroku addons:open scheduler
```

Add the task ```rake hey``` to your heroku scheduler and set to whatever schedule you want.


### usage

If you have your repo in an env var as above, run the rake task `hey`

```bash
rake hey
```

If not, then pass the repo to `hey` like

```bash
rake hey repo=owner/repo
```

### what does it look like?

This is what a comment looks like in a thread

![assertr_img](/2016-03-24-hey-there/testhey.png)

You could set up a different GitHub account as your robot so it's clearly not coming from a real person.


## feedback

I'll continue to improve `heythere` as we get feedback on its use in `ropensci/onboarding`. Would also love any feedback from you, internet. Thanks!

[ht]: https://github.com/ropenscilabs/heythere


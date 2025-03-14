---
name: sixtyfour
layout: post
title: "sixtyfour: writing robust code against AWS"
date: 2025-03-13
author: Scott Chamberlain
tags:
- r
- aws
---

## Introduction

At work ([Fred Hutch Cancer Center][work]) we've been working on an R package (`sixtyfour`) over the last ~1.5 years. This post is a quick intro to the package with some learnings about working with AWS.

[sixtyfour][] is a science-focused, more humane R interface to AWS. It is built on top of the great `paws` package maintained by [Dyfan Jones][dyfan], which handles authentication and the low-level work of interacting with AWS services while `sixtyfour` provides higher-level interfaces for common tasks.

Maintaining code that interacts with AWS is no easy task. With the release of the first public version of `sixtyfour`, I'd like to do a brief quickstart to the package and go over some of our learnings related to interacting with AWS, including sensitive pieces of information, examples and tests.

## sixtyfour quickstart

Most `sixtyfour` functions are prefixed with `aws_`, while a smaller set of functions are prefixed with `six_`. These `six_` functions are our so called "magical" functions, in that they get a task done with sensible defaults and with verbose output to keep you informed. For example, below we'll use two `six_` functions to create a user, create a bucket, and give that user permissions to the bucket.

Install the package from [GitHub][sixtyfourgh] using `pak`:

```r
# install.packages("pak")
pak::pak("getwilds/sixtyfour")
```

Load `sixtyfour`:

```r
library(sixtyfour)
```

`sixtyfour` leverages the `paws` package and it handles authentication - [it looks in many different places for credentials][pawscreds]. One way to set them is through env vars like:

```r
Sys.setenv(
  AWS_ACCESS_KEY_ID = "your key",
  AWS_SECRET_ACCESS_KEY = "your secret",
  AWS_REGION = "us-west-2"
)
```

Create a user: creating a user is not just a single API call to AWS. To have a real user setup that can access AWS they need to have a username in an AWS account, then have some policies attached and access keys before they can get any information from the AWS API. `six_user_create()` not only creates the user but copies an email template with the keys for the user to make it easy to send the information to the person behind the new user name.

```r
user <- random_user()
six_user_create(user)
```

Create a bucket

```r
bucket <- random_bucket()
aws_bucket_create(bucket)
```

Add the user to the bucket so they can access it with read permissions: adding a user to a bucket takes a few steps: create a bucket policy if missing, then attach the policy to the user. In addition, we've simplified the permissions to just "read" and "write", handling the necessary AWS policies behind the scenes to give a user read or write access. Of course you can drop down to lower level `aws_*` functions if you need more control.

```r
six_bucket_add_user(
  bucket = bucket,
  username = user,
  permissions = "read"
)
```

## Sensitive information

When interacting with AWS there's many pieces of information that you likely do not want shown to other people. These include:

- Access keys
- Secret keys
- AWS Account ID
- AWS ARN's that include sensitive information (like Account ID)
- AWS Region
- and surely more

We used a few different approaches to safeguard users (including us as we develop the package):

- Many packages allow credentials to be passed in as arguments to functions. We don't allow this because it would make it easy for users to pass raw strings in to functions that are sensitive. `paws` already handled finding credentials and so we rely on it.
- Provide the function `aws_configure()` to let users redact secrets in outputs from the AWS API - and the  `with_redacted` function allows you to temporarily redact sensitive information from the output of a code block (like a `with` context manager in Python). What does this look like? Here's an example:

```r
with_redacted(
  new_user <- six_user_create(random_user())
)
#> ℹ Added policy UserInfo to BarreledRunoff
#> ✔ Key pair created for BarreledRunoff
#> ℹ AccessKeyId: *****
#> ℹ SecretAccessKey: *****
#> Email template copied to your clipboard
```

If we didn't use `with_redacted`, the output would show the access key ID and the secret. You haven't lost the actual key and secret though assuming you assigned it to a variable (here `new_user`) - even if you forget to assign to a variable you can always do `.Last.value`.

In addition, for `six_user_create` we copy an email template to your clipboard for sharing the new AWS user with the real person it should be associated with.

Why would we want to redact secrets? There's a number of use cases that demand it:

- You're using `sixtyfour` on your laptop in a coffee shop or other public place where you probably don't want someone peeking over your shoulder at your secrets
- You're using `sixtyfour` in a Quarto or Rmarkdown document where the output will be rendered and shared


## Package examples

### Reproducible and self-cleaning examples

In earlier versions of `sixtyfour` the examples for exported functions were pretty barebones: they only worked if x, y, or z was already done and it wasn't documented, and they didn't clean up after themselves.

Recently we've done a big refresh of all the examples, going over them with a fine-toothed comb. Now all examples should be (doesn't hurt to hedge <i class="fa-solid fa-face-grimace"></i>) handled correctly without issues regardless of the machine and whether credentials are available or not:

Table 1. Examples that require credentials correctly run (<i class="fa-solid fa-circle-check"></i>) or don't run (<i class="fa-solid fa-circle-xmark"></i>), or does not apply ("N/A").

||Me|User|GHA Pkgdown[^1]|CRAN[^2]|
|---|:---:|:---:|:---:|:---:|
| w/ credentials | <i class="fa-solid fa-circle-check"></i> | <i class="fa-solid fa-circle-check"></i> | <i class="fa-solid fa-circle-check"></i> | N/A |
| w/o credentials | <i class="fa-solid fa-circle-xmark"></i> | <i class="fa-solid fa-circle-xmark"></i>| <i class="fa-solid fa-circle-xmark"></i> | <i class="fa-solid fa-circle-xmark"></i> |

We wanted to make sure the following things were true with `sixtyfour` examples:

- they're in sync with the code - i.e., an example doesn't reflect a historical version of the function
- they don't fail when CRAN folks are running them
- they clean up after themselves so whoever runs them isn't leaving created resources to lie fallow and accumulate costs

The approach we landed on was to mostly use `@examplesIf aws_has_creds()`; inspired by a similar pattern in Jenny Bryan's [googledrive][] package (see for example [`@examplesIf drive_has_token()`](https://github.com/tidyverse/googledrive/blob/main/R/drive_get.R#L65C4-L65C33)). That is, with `@examplesIf aws_has_creds()` we only run the example if appropriate AWS credentials are found.

In examples where we wanted to be especially careful we used `@examplesIf aws_has_creds() && interactive()` so that examples only run when AWS credentials are available and the user is running the examples interactively.

A tricky part of `sixtyfour` examples is that they hit real AWS services, so any failures in examples means that they may not have been cleaned up properly and could leave services running. It's not reasonable to expect users to set up some kind of mock service (e.g., Minio, Localstack; see [Testing]({{< ref "#testing" >}}) below) - so we can't go that route. Although in software testing we can make sure to cleanup after ourselves, it's harder to think about how to do that with examples where you want the examples to have just the code that's important and not other tidying code lying around.

### Maintaining examples for internal functions

There's a fair number of examples in `sixtyfour` that are meant for internal use or perhaps for more technical users. Instead of talking about this in detail read about this in a recent post I did: [Keeping internal function examples alive](https://recology.info/2025/02/r-examples-internal/).

## Testing

### How to not break the bank testing

We use the open source (and free) versions of a few tools to test our code without breaking the bank:

- [Minio](https://min.io/)
- [Localstack](https://localstack.cloud/)

If we were writing this package in Python or Javascript we'd have additional tools at our disposal as those ecosystems have more mature tools for testing code. For example, Python has [moto][] and Javascript has [aws-sdk-mock][]. Because Minio and Localstack aren't language specific tools we can use them in R.

We use Minio mainly for testing S3 functionality in `sixtyfour`, and we use Localstack for testing other AWS services (e.g., IAM, secrets manager, VPC security groups, etc.). We set these up on GitHub Actions, and skip tests that use these if either service is not available.

Table 2. AWS services that we test with Minio or Localstack

| Service | Minio | Localstack |
| --- | --- | --- |
| S3 | <i class="fa-solid fa-circle-check"></i> | <i class="fa-solid fa-circle-check"></i> |
| IAM | -- | <i class="fa-solid fa-circle-check"></i> |
| Secrets Manager | -- | <i class="fa-solid fa-circle-check"></i> |
| VPC Security Groups (EC2) | -- | <i class="fa-solid fa-circle-check"></i> |
| Redshift | -- | <i class="fa-solid fa-circle-check"></i> |
| RDS | -- | -- |
| Cost Explorer | -- | -- |

There are a few tests that use the real AWS services or we mock them because they are not available in Localstack. One of these is RDS for which we use [vcr][] to record and replay HTTP requests so that at least after a cassette is recorded, subsequent tests that match the cassette will not make real HTTP requests. This speeds up tests and reduces the chance of spinnning up an RDS database and forgetting about it.

For Cost Explorer, we use mocking via [webmockr][]. We went the mocking route for this service because we wanted to avoid git checking in vcr cassettes with potentially sensitive billing data.

An important gotcha with either approach above (`vcr` or `webmockr`) is that if a test fails before cleaning up, then a resource (e.g., an RDS database) could be left running and could incur huge charges. We haven't done this yet but plan to make sure cleanup steps (i.e., delete AWS resources) are run even on test failures.

## Get a test AWS account if you can

What I mean by a test account is that it's not an account used for "production" work. That is, one ideally shouldn't run automated tests against an account used for real work - even with the best of intentions mistakes can be made.

We were able to get a test AWS account at Fred Hutch, so we were lucky. If we were not able to, we'd have to take many more precautions to make sure we weren't accidentally messing up production accounts/services folks are using.

Depending on what institution you're at getting an AWS account just for testing can be a significant burden, so may not be within reach for some.

Why not just avoid using an AWS account for testing all together? I think it's important to run code against a real AWS account to make sure it works for real users who aren't running the code against mocks, etc. - even if it's just manually done.

## Fin

Please do try `sixtyfour`! Let us know if you have any [questions or feedback][sixtyfourissues].


[^1]: Our GitHub Actions `pkgdown` workflow runs the examples with AWS credentials present so that users can see rendered examples. Currently our GHA R CMD CHECK workflow doesn't run examples, but maybe we should change that?
[^2]: In theory, a CRAN team member could have AWS credentials set on a machinen they're running checks on but that seems unlikely.

[work]: https://ocdo.fredhutch.org/
[sixtyfour]: https://getwilds.org/sixtyfour/
[sixtyfourgh]: https://github.com/getwilds/sixtyfour
[sixtyfourissues]: https://github.com/getwilds/sixtyfour/issues
[dyfan]: https://github.com/DyfanJones
[pawscreds]: https://www.paws-r-sdk.com/developer_guide/credentials/#set-credentials
[vcr]: https://docs.ropensci.org/vcr/
[webmockr]: https://docs.ropensci.org/webmockr/
[withr]: https://withr.r-lib.org/
[moto]: https://github.com/getmoto/moto
[aws-sdk-mock]: https://www.npmjs.com/package/aws-sdk-mock
[googledrive]: https://github.com/tidyverse/googledrive/

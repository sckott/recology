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

## How our AWS account fits in

Having a test AWS account is essential - depending on what institution you're at this can be a significant burden, so may not be within reach for some.

As we [discuss below]({{< ref "#testing" >}}) tests in `sixtyfour` are run whenever possible against Minio or Localstack so we're not hitting the real AWS account.

However, with the open source version of Minio and Localstack there's some AWS services for which we'd have to use real AWS requests.

In addition, it is essential I think to run the code against a real AWS account to make sure it works for real users who aren't running the code against Minio and Localstack - even if this is just manually checked occasionally.

We were able to get a test AWS account at Fred Hutch, so we were lucky. If we were not able to, we'd have to take many more precations to make sure we weren't accidentally messing up production accounts/services folks are using.

## Sensitive information

When interacting with AWS there's many situations where you may not want certain pieces of information shown. These include

- Access keys
- Secret keys
- AWS Account ID
- AWS ARN's that include sensitive information (like Account ID)
- AWS Region
- and surely more

We used a few different approaches to safeguard users (including us as we develop the package):

- Many packages allow credentials to be passed in as arguments to functions. We don't allow this because it would make it easy for users to pass raw strings in to functions that are sensitive. `paws` already handled finding credentials and so we rely on it.
- Provide the function `aws_configure()` to let users redact secrets in outputs from the AWS API - and the  `with_redacted` fxn allows you to temporarily redact sensitive information from a code block (in a [withr][] fashion).

## Package examples

### Reproducible and self-cleaning examples

In earlier versions of `sixtyfour` the examples for exported functions were pretty barebones: they only worked if x, y, or z was already done and it wasn't documented, and they didn't clean up after themselves.

Recently we've done a big refresh of all the examples, going over them with a fine-toothed comb. Now all examples should be (doesn't hurt to hedge 😬) able to run without issues regardless of the machine and whether credentials are available or not:

||Me|User|CRAN|
|----|---|---|---|
|w/ credentials|✅|✅|✅|
|w/o credentials|✅|✅|✅|

We wanted to make sure the following things were true with the packages' examples:

- they're in sync with the code - i.e., an example doesn't reflect a historical version of the function
- they don't fail when CRAN folks are running them
- they clean up after themselves so whoever runs them isn't leaving created resources to lie fallow and accumulate costs

The approach we laneded on was to mostly use `@examplesIf aws_has_creds()`. That is, only run the examples if appropriate AWS credentials are found (code is from `paws`).

In examples where we wanted to be especially careful we used `@examplesIf aws_has_creds() && interactive()` so that examples only run when AWS credentials are available and the user is running the examples interactively.

A tricky part of `sixtyfour` examples is that they hit real AWS services, so any failures in examples means that they may not have been cleaned up properly and could leave services running. It's not reasonable to expect users to set up some kind of mock service (e.g., Minio, Localstack; see [Testing]({{< ref "#testing" >}}) below) - so we can't go that route. Although in software testing we can make sure to cleanup after ourselves, it's harder to think about how to do that with examples where you want the examples to have just the code that's important and not other tidying code laying around.

### Maintaining examples for internal functions

There's a fair number of examples that are meant for internal use or perhaps for more technical users. Instead of talking about this in detail read about this in a recent post I did: [Keeping internal function examples alive](https://recology.info/2025/02/r-examples-internal/).

## Testing

### How to not break the bank testing

We use the open source (and free) versions of a few tools to test our code without breaking the bank:

- [Minio](https://min.io/)
- [Localstack](https://localstack.cloud/)

If we were writing this package in Python or Javascript we'd have additional tools at our dispoasl as those ecosystems have more mature tools for testing code. For example, Python has [moto][] and Javascript has [aws-sdk-mock][]. Because Minio and Localstack aren't language specific libraries we can use them in R.

We use Minio mainly for testing S3 functionality in `sixtyfour`, and we use Localstack for testing other AWS services (e.g., IAM, secrets manager, VPC security groups, etc.). We set these up on GitHub Actions, and skip tests that use these if either service is not available.

Table 2. AWS services that we test with Minio or Localstack

| Service | Minio | Localstack |
| --- | --- | --- |
| S3 | ✅ | ✅ |
| IAM | -- | ✅ |
| Secrets Manager | -- | ✅ |
| VPC Security Groups (EC2) | -- | ✅ |
| Redshift | -- | ✅ |
| RDS | -- | -- |
| Cost Explorer | -- | -- |

There are a few tests that use the real AWS services. As RDS and Cost Explorer are not available in the free Localstack version, we use the real AWS services. For RDS, we use [vcr][] to record and replay HTTP requests for RDS tests so that at least after a cassette is recorded, subsequent tests that match the cassette will not make real HTTP requests. This speeds up tests and reduces the chance of spinnning up a database and forgetting about it.

For Cost Explorer, we use mocking via [webmockr][]. We went the mocking route for this service because we wanted to avoid git checking in vcr cassettes with potentially sensitive billing data.

An important gotcha with either approach above (`vcr` or `webmockr`) is that if a test fails before cleaning up, then a resource (e.g., an RDS database) could be left running and could incur huge charges. We haven't done this yet but plan to make sure cleanup steps (delete resources) are run even on test failures.

## Fin

Please do try `sixtyfour`, and let us know if you have any [questions or feedback][sixtyfourissues].



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

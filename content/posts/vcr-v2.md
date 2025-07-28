---
name: vcr-v2
layout: post
title: "vcr v2"
date: 2025-07-28
author: Scott Chamberlain
tags:
- r
- testing
- http
- vcr
---

I'm excited to announce a new release of vcr: v2. vcr helps you record and replay HTTP interactions in your tests (and more now, [see below](#documentation-support)). This release brings improvements in usability and security, it streamlines the API, and adds many new features.

Where all past versions of vcr have been minor tweaks on a direct port of the [Ruby gem of the same name](https://github.com/vcr/vcr), this version diverges from the vision of the Ruby vcr to focus on what makes sense for R users.

You can install it from CRAN with:

```r
install.packages("vcr")
```

## New Local Scoping Tools

One of the most significant improvements is the introduction of better scoping tools:

- {{< fundocs local_cassette >}}: Creates a cassette that's automatically ejected when the current function exits
- {{< fundocs local_vcr_configure >}}: Temporarily modify vcr configuration
- {{< fundocs local_vcr_configure_log >}}: Set logging for the current function scope

Whereas you used to have to write:

```r
test_that("API call works", {
  vcr::use_cassette("github_api", {
    response <- request("https://api.github.com/users/octocat") %>%
      req_perform()
  })
  expect_equal(resp_body_json(response)$login, "octocat")
})
```

You can now write:

```r
test_that("API call works", {
  vcr::local_cassette("github_api")

  response <- request("https://api.github.com/users/octocat") %>%
    req_perform()
  expect_equal(resp_body_json(response)$login, "octocat")
})
```

## Better Default Settings

The v2 release comes with smarter defaults that should work better out of the box:

- The default request matcher now considers method, URI, and body (if present)
- Request bodies and headers are only written to cassettes if they're needed for matching, making cassettes more lightweight than before
- The default cassette directory is now `tests/testthat/_vcr`. This brings it in line with the `tests/testthat/_snaps` directory used for [snapshot testing](https://testthat.r-lib.org/articles/snapshotting.html)
- File handling works without additional configuration, with files automatically saved in a `{cassette-name}-files` directory

## Enhanced Security

Security has been improved with better handling of sensitive information:

- The `Authorization` header is never written to disk
- Request bodies and headers are only written if they're needed for matching, reducing unwanted data exposure
- Better handling of raw bodies with automatic gzipping before base64 conversion

## Improved Debugging

New tools make it easier to understand what's happening during tests:

- {{< fundocs vcr_last_request >}} and {{< fundocs vcr_last_response >}} for inspecting HTTP interactions
- {{< fundocs local_casette >}} and {{< fundocs use_cassette >}} set env vars `VCR_IS_RECORDING` and `VCR_IS_REPLAYING` and provide helpers {{< fundocs is_recording >}} and {{< fundocs is_replaying >}}
- {{< fundocs current_cassette_recording >}} and {{< fundocs current_cassette_replaying >}} aid in cassette state inspection
- {{< fundocs local_vcr_configure_log >}} and {{< fundocs vcr_configure_log >}} for setting logging for the current function scope and globally. vcr had logging capabilities before this version, but the logging output has been significantly improved. These functions show you what vcr is doing internally with respect to matching requests, for example, let's say you have a test and it runs fine the first time:

```r
test_that("httr2 user agent", {
  vcr::local_cassette("httr2_user_agent")

  response <- request("https://hb.cran.dev/get") %>%
    req_perform()
  expect_match(resp_body_json(response)$headers$`User-Agent`, "httr2")
})
```

But something changes and now you get a message like:

```r
<vcr_unhandled/rlang_error/error/condition>
Error in `RequestHandlerHttr2$new(req)$handle()`: Failed to find matching request in active cassette, "httr2_user_agent".
i Use `local_vcr_configure_log()` to get more details.
i Learn more in `vignette(vcr::debugging)`.
```

You can add {{< fundocs local_vcr_configure_log >}} to the test block to enable logging for the current function scope, which will show you what vcr is doing internally with respect to matching requests:

```r
[Cassette: httr2_user_agent] Handling request: GET https://hb.cran.dev/post
[Cassette: httr2_user_agent]   Looking for existing requests using method/uri
[Cassette: httr2_user_agent]     Request 1: NO MATCH
[Cassette: httr2_user_agent]       `matching$uri$path`: "/post"
[Cassette: httr2_user_agent]       `recorded$uri$path`: "/get"
[Cassette: httr2_user_agent]   No matching requests
```

See the [Debugging vcr failures vignette](https://docs.ropensci.org/vcr/articles/debugging.html) for more details on debugging.

## Documentation Support

Writing documentation with vcr is now officially supported with two new functions:

- Examples: {{< fundocs insert_example_cassette >}} simplifies using vcr in package examples. For an example see the [ellmer package](https://github.com/search?q=repo%3Atidyverse%2Fellmer+vcr_example_start+path%3A%2F%5ER%5C%2F%2F&type=code).
- Vignettes: {{< fundocs setup_knitr >}} makes it straightforward to use vcr in vignettes. For an example see the [ellmer package](https://github.com/search?q=repo%3Atidyverse%2Fellmer%20setup_knitr&type=code).


## New Serialization Option

A new serializer option `qs2` has been added, using the [`qs2` package][qs2] to generate compressed binary cassette files that are smaller than YAML or JSON files. This is particularly beneficial for cassettes with large amounts of data. The tradeoff however is that the files are not human-readable. See the docs for {{< fundocs local_cassette >}}

## Lifecycle changes

- `check_cassette_names()`: has been deprecated since it can't be implemented 100% correctly and diagnoses a relatively rare problem. It will be removed in a future version.
- `use_vcr()`: has been deprecated since the defaults now set in vcr make this function unnecessary. It will be removed in a future version. This does mean you'll need to add `vcr` to Suggests in your DESCRIPTION file manually, but other than that there should be no other setup needed unless you want to customize configuration through {{< fundocs vcr_configure >}}

## Breaking Changes

As this is a major version update, there are many breaking changes. See the [release notes](https://github.com/ropensci/vcr/releases/tag/v2.0.0) for the details. Here's a few highlights from the breaking changes:

- Removed functions: `vcr_last_error()`, `vcr_log_file()`, `vcr_log_info()`, and several internal classes
- Cassettes are now implemented as a stack - `eject_cassette()` can only remove the most recently inserted cassette
- Several configuration options have been removed or changed
- The `cassettes()` function has been simplified and now only lists currently active cassettes
- In {{< fundocs use_cassette >}} note that four parameters have been dropped and will be ignored silently due to the ellipsis (`...`): `update_content_length_header`, `allow_playback_repeats`, `persist_with`, `clean_outdated_http_interactions`
- {{< fundocs vcr_configure >}} has dropped many parameters, and now does not have an ellipsis (`...`), so will fail with an error if you try to pass any of those removed parameters.

## You don't need no library!

vcr no longer needs to be loaded in the global environment to be able to use it! that is, before you had to `library(vcr)` before you could use its functions, but now you can simply call vcr functions via namespacing like `vcr::use_cassette()`.

## vcr has a logo!

![vcr logo](https://docs.ropensci.org/vcr/logo.png)

Thank you [drmowinckels](https://github.com/drmowinckels) for instigating, and [hadley](https://github.com/hadley), [aaronwolen](https://github.com/aaronwolen), and [maelle](https://github.com/maelle) for narrowing down the winner.

## New author

This release of `vcr` is nearly all due to a new contributor you probably have not heard of: [Hadley Wickham](https://github.com/hadley). Hadley contributed ~75% of the commits to this release :p

## Contributing to vcr

With all the changes made in v2, vcr should now be much easier to contribute to. vcr used to have more R6 classes, which can be harder to reason about. In addition, a number of unused parameters in functions have been removed, simplifying the package. vcr used to hook into webmockr for some of its functionality, increasing complexity - that connection has been removed, making vcr easier to maintain. Tests can now be run in parallel so iterating on vcr code with test feedback is now faster.

## Migrating to v2

If you've been using vcr before this release:

- Update to vcr v2.
- Consider a fixture location change: the default is now `tests/testthat/_vcr`. If you don't set `vcr::vcr_configure(dir)` then you'll get the new default location.
- Re-record your cassettes: delete your old cassettes (and the old fixtures directory if you're changing to the new default dir at `tests/testthat/_vcr`), then run your tests two more times (once to record new cassettes and another to make sure the tests work upon replay)
- If you run into any issues or have questions let us know at <https://github.com/ropensci/vcr/issues>

## All the changes

For more details about all the changes and new features in this version, check out the [release notes](https://github.com/ropensci/vcr/releases/tag/v2.0.0) and the updated [package documentation][docs].


[docs]: https://docs.ropensci.org/vcr/
[qs2]: https://github.com/ropensci/qs2

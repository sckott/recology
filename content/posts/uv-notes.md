---
name: uv-notes
layout: post
title: "uv notes"
date: 2025-02-20
author: Scott Chamberlain
tags:
- python
- uv
---

## What is uv

I've recently started using `uv` to manage Python projects and packages: many projects at work and the one active package I have on pypi.org (`habanero`).

I don't really know enough about all the various Python tools similar to `uv` to give an informed opinion. Rather, this is purely reflections on using `uv`.

`uv`'s tagline is:

> An extremely fast Python package and project manager, written in Rust.

uv [docs][uvdocs] and [source code][uvsrc].

## Reflections

### Fast

It's super fast. I don't remember my experience with plain ol pip being anywhere near this fast, though surely that could be user (me) incompetence.

### Self python

The ability for `uv` to install Python itself is very nice. This means I don't have to manage downloading Python myself, and worry about adding things to the path, etc.

### User land

With `uv` I do not run into user vs. not user install issues I had with pip often. This was probably just me not using python/pip the right way? Anyway, `uv` [doesn't support the `--user` flag](https://docs.astral.sh/uv/pip/compatibility/#-user-and-the-user-install-scheme) it turns out.

### uv run

It's very nice that `uv run` enters and exits the virtual environment for you. This wasn’t super obvious that this was even happening when I first starting using the command, but of course makes sense now. You can still activate/deactivate the virtual env yourself though.

### Inline script metadata

`uv` supports a concept of [inline script metadata](https://docs.astral.sh/uv/guides/scripts/#declaring-script-dependencies) - which comes from [PEP 723](https://peps.python.org/pep-0723/). Simon Willison also [wrote about this](https://simonwillison.net/2024/Dec/19/one-shot-python-tools/#inline-dependencies-and-uv-run) recently.

It looks like (example from their docs)

```python
# /// script
# dependencies = [
#   "requests<3",
#   "rich",
# ]
# ///

import requests
from rich.pretty import pprint

resp = requests.get("https://peps.python.org/api/peps.json")
data = resp.json()
pprint([(k, v["title"]) for k, v in data.items()][:10])
```

I have not used this feature but I think it could be very helpful. There's lots of Python scripts that really don't need a project structure but would benefit from properly managing dependencies. Now with this feature there's no need to have the heavier project structure when you have all your code in a single script.

### REPL tools

I don't know if this is the "right" way to do things, but there's some dependencies my project or package do not depend on but that I want to use for development. I like to use ipython repl instead of the default python one - although the one that comes with Python is getting very good. So I install ipython and rich with `uv pip install ipython rich`. This invocation does not add them as dependencies but still (I think?) manages these dependencies within the project/package structure.

### VC backed?

I'm a little nervous about `uv` being made by a [VC backed company](https://astral.sh/blog/announcing-astral-the-company-behind-ruff). If I come to depend on `uv` and then they get bought and things change, or they just fold soon after, that's a bummer. But, it is open source so I imagine projects as big and important as `uv` and `ruff` may be adopted by the community. And I absolutely want people making open source software to be able to make a living, so we kinda need to keep our options open for how to do that.

## Links

Other blog posts covering `uv`:
- <https://www.bitecode.dev/p/a-year-of-uv-pros-cons-and-should>
- <https://simonwillison.net/2024/Dec/19/one-shot-python-tools/>


[uvsrc]: https://github.com/astral-sh/uv
[uvdocs]: https://docs.astral.sh/uv/
[habanero]: https://pypi.org/project/habanero/

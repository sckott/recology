---
name: fastapi-litestar-htmx
layout: post
title: "Notes on FastAPI, LiteStar and HTMX"
date: 2025-10-09
author: Scott Chamberlain
tags:
- python
- fastapi
- litestar
- htmx
- html
---

I recently wrote about [Picking a web framework]({{< relref "web-frameworks.md" >}}) for a project at [work](https://ocdo.fredhutch.org/). We're moving from an R Shiny app to something else. We weren't sure what that something else should be so I rebuilt the app (in part) in three different web frameworks (each in a different programming language):

- [FastAPI](https://fastapi.tiangolo.com/) (Python)
- [Rails](https://rubyonrails.org/) (Ruby)
- [Svelte](https://svelte.dev/) (JavaScript)

I decided to go with FastAPI for many reasons - go read the post linked above.

However, someone in a [Mastodon thread about that post mentioned](https://mastodon.social/@minkiu/114236534994138576) that I should check out [LiteStar](https://github.com/litestar-org/litestar). After building the new app in FastAPI for a while there were enough pain points that I decided to try out LiteStar.

The following are observations about FastAPI, LiteStar, and HTMX.

## LiteStar > FastAPI

### More batteries included

It all depends on your use case, but for what we need, more stuff included is better for us. Of course, if you want to decide what components to include yourself, FastAPI, Starlette, Flask, etc. are good options.

### Defining routes

In FastAPI you define a route like

```python
from fastapi import FastAPI

app = FastAPI()

@app.get("/")
async def root():
    return {"message": "Hello World"}
```

Whereas with LiteStar you define a route like

```python
from litestar import Litestar, get

@get("/")
async def root():
    return {"message": "Hello World"}
```

These are just very slightly different, but LiteStar's syntax is slightly more concise, and as [James Bennett points out](https://www.b-list.org/weblog/2025/aug/06/litestar/) `@app.get` is a bound method while `@get` is a standalone function. LiteStar's approach makes it easier to organize routes or sets of routes in various files, making it easier to "scale" applications from small to large with respect to complexity, not requests or users. It's harder with FastAPI because as Bennett points out:

> You need to import the main application object into the other files in order to decorate the routes, but you need to import the other files into your “main” application file to make sure the route registrations are visible from there, and now you have a circular import, and that doesn’t work.

### HTMX is built in to LiteStar

Whereas you have to use a third-party library to add HTMX support to FastAPI (e.g., [fasthx](https://github.com/volfpeter/fasthx)), LiteStar comes with [HTMX support built-in](https://docs.litestar.dev/latest/usage/htmx.html).

This is a big selling point for us: in the work project where I'm using all this stuff we want to rely on HTMX as much as possible to avoid dipping into harder-to-reason-about JavaScript.

### LiteStar is faster

Although this isn't a huge difference-maker for any web app at a small size and user base (as ours is now), it makes a difference as the app and user numbers grow. And speed makes the developer experience (in this case, mine) better as there's less waiting around. LiteStar's [benchmarks are pretty impressive](https://docs.litestar.dev/latest/benchmarks.html).

### advanced-alchemy

[advanced-alchemy](https://github.com/litestar-org/advanced-alchemy) is a really nice part of LiteStar - it can be used outside of LiteStar as well. It has UUID-keyed models, proper UTC timestamp types, a JSON type, command-line helpers for database management, and more.

We're using the [SQLAlchemyPlugin](https://docs.advanced-alchemy.litestar.dev/latest/reference/extensions/litestar/index.html#advanced_alchemy.extensions.litestar.SQLAlchemyPlugin), the [JsonB type](https://docs.advanced-alchemy.litestar.dev/latest/usage/types.html#jsonb), the [DateTimeUTC type](https://docs.advanced-alchemy.litestar.dev/latest/usage/types.html#datetime-utc), and the [UUIDBase class](https://docs.advanced-alchemy.litestar.dev/latest/usage/modeling.html#base-classes) that automatically generates UUIDs for us.

I did experiment with using the [pagination utilities in advanced-alchemy](https://docs.advanced-alchemy.litestar.dev/latest/usage/repositories.html#pagination). It was for an external API instead of a database - for that reason I think it didn't work as well as I'd hoped. We do have a database used by the app that's separate from the API, so we may come back to the pagination utilities.

### Handling multiple content types

There's not a huge difference between FastAPI and LiteStar here, but LiteStar is a little nicer here. LiteStar has some built-in support for handling content types, whereas it's more DIY in FastAPI.

### Grouping routes

LiteStar makes it easy to [organize routes](https://docs.litestar.dev/2/usage/routing/) using Routers and Controllers. Our app is a candidate for this for sure - though we haven't taken advantage of it yet, we will. For example, you can organize many routes that share the same root route like:

```python
from litestar import Litestar, Controller, get, post

class UserController(Controller):
    path = "/users"

    @get("/{user_id:int}")
    async def get_user(self, user_id: int) -> str:
        return f"Fetching user with ID: {user_id}"

    @post("/")
    async def create_user(self) -> str:
        return "Creating a new user"

    @patch("/{user_id:int}")
    async def update_user(self, user_id: int) -> str:
        return f"Updating user with ID: {user_id}"

app = Litestar(route_handlers=[UserController])
```

Which gives us the routes:

- GET /users/{user_id}
- POST /users
- PATCH /users/{user_id}

This approach makes it easy to add shared requirements for these routes under `UserController` - for example authentication, content types, etc. - rather than having to repeat those components for each route separately.

From what I understand you can achieve the same thing with FastAPI but with third party libraries, e.g., [fastapi-utils](https://fastapi-utils.davidmontague.xyz/user-guide/class-based-views/).

## LiteStar pain points

### Session middleware is not available in exception handlers

This makes it quite painful when there's an exception as you don't have access to session data, primarily the user session data.

Whereas it'd be nice to have a simpler custom handler like:

```python
def custom_404_handler(request: Request, _exc: HTTPException) -> Template:
    return Template(
        template_name="404.html",
        context={"request": request},
        status_code=HTTP_404_NOT_FOUND,
    )
```

Instead we have to do something like:

```python
def custom_404_handler(request: Request, _exc: HTTPException) -> Template:
    session_data = {}
    try:
        session_id = request.cookies.get("session")
        if session_id:
            session_data = {
                "logged_in": True,
                "session": {"logged_in": True},
                "username": "user",
            }
    except Exception:
        pass

    return Template(
        template_name="404.html",
        context={"request": request, "session_override": session_data},
        status_code=HTTP_404_NOT_FOUND,
    )
```

It's entirely possible there's an easy solution here, or I'm misunderstanding something.

## HTMX - good and bad

- I love the ability to use many HTTP methods (get, post, put, patch, delete) on html tags, for example, on `a` tags, `button` tags, etc.
- It's nice to have a dependency (HTMX) that doesn't change that much - it's purposely slow-moving and meant to have a tight scope.
- We're also using JavaScript in this work project - so we're not entirely avoiding JS - but it's nice to avoid at least some of it.
- Some have tried HTMX and found it wanting (e.g., [this post](https://ajmoon.com/posts/mesh-i-tried-htmx-then-ditched-it)), but for me it's at least good enough. I imagine if I was more experienced with JS I'd have stronger feelings.
- Swaps in particular are hard for me to reason about. The names of the swap options don't mean much to me, so that's the first hurdle. For example, the default is `innerHTML`; what does that mean exactly?
- Triggers are really nice. Having used a little bit of JS trying to achieve the same thing, it's so nice to be able to succinctly say "hey, trigger this on load (page load), and every 30 seconds" (i.e.: `hx-trigger="load, every 30s"`).

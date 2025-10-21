---
name: database-writing-linked-tables
layout: post
title: "Writing to linked tables in a transaction"
date: 2025-10-21
author: Scott Chamberlain
tags:
- python
- database
- data
- litestar
---

I recently had a use case at work (a LiteStar app) where I needed to write to two linked tables (see below) in a transaction in our PostgreSQL database.

In the models for the two tables was included a foreign key relationship:

```python
from sqlalchemy import Column, String, DateTime, ForeignKey
from sqlalchemy.orm import Mapped, relationship
from typing import List

# UUIDBase automatically generates a UUID for the primary key
from advanced_alchemy.extensions.litestar import base

class flows(base.UUIDBase):
    __tablename__ = 'flows'
    name: Column(String)
    date: Column(DateTime)
    files: Mapped[List["Files"]] = relationship(
      back_populates='flow',
      cascade='all, delete-orphan'
    )

class Files(base.UUIDBase):
    __tablename__ = 'files'
    file_name: Column(String)
    date: Column(DateTime)
    flow_id: Mapped[UUID] = mapped_column(ForeignKey('flows.id'))
    flow: Mapped["Flows"] = relationship(back_populates='files')
```

My first - very naive approach was to include both writes in a single transaction (see next block). This kept failing because the foreign key from the first write (to the `flows` table) wasn't available yet. The error that arose was that the ID wasn't found, which took probably too long for me to figure out that it just wasn't available yet.

{{< callout "note" >}}
note that `session.begin()` is optional, but I'm going with it for clarity
{{< /callout >}}


```python
from sqlalchemy.ext.asyncio import AsyncSession

async with AsyncSession(engine) as session:
    async with session.begin():
      write_new_submission(data=some_data, session=session)
      record_new_files(data=some_file_data, session=session)
```

One could try to separate these two writes into two different transactions. However, if either fails we'd want both rolled back because we don't want to have one write succeed without the other. I didn't try this but that would look like:

```python
async with AsyncSession(engine) as session:
    async with session.begin():
      write_new_submission(data=some_data, session=session)

async with AsyncSession(engine) as session:
    async with session.begin():
      record_new_files(data=some_file_data, session=session)
```

The next attempt was to take the `session` object and try to split the writes into two `session.begin()` blocks, which I think gave the same problem as above:

```python
async with AsyncSession(engine) as session:
    async with session.begin():
      write_new_submission(data=some_data, session=session)

    async with session.begin():
      record_new_files(data=some_file_data, session=session)
```

The next thing I tried - which worked - was to use a flush after the first write, which made the ID available for the second write:

```python
async with AsyncSession(engine) as session:
    async with session.begin():
      write_new_submission(data=some_data, session=session)
      session.flush()
      record_new_files(data=some_file_data, session=session)
```

Bingo, bango, bango!

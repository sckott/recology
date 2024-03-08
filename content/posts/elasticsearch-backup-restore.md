---
name: elasticsearch-backup-restore
layout: post
title: Elasticsearch backup and restore
date: 2015-02-26T21:00:00-08:00
author: Scott Chamberlain
sourceslug: _drafts/2015-02-26-elasticsearch-backup-restore.Rmd
tags:
- elasticsearch
---

## setup backup

```bash
curl -XPUT 'http://localhost:9200/_snapshot/my_backup/' -d '{
    "type": "fs",
    "settings": {
        "location": "/Users/sacmac/esbackups/my_backup",
        "compress": true
    }
}'
```

## create backup

```bash
http PUT "localhost:9200/_snapshot/my_backup/snapshot_2?wait_for_completion=true"
```

## get info on snapshot

```bash
http "localhost:9200/_snapshot/my_backup/snapshot_2"
```

## restore

```bash
curl -XPOST "localhost:9200/_snapshot/my_backup/snapshot_2/_restore"
```

## partial restore, including various options that can be used

```bash
curl -XPOST "localhost:9200/_snapshot/my_backup/snapshot_2/_restore" -d '{
    "indices": "index_1,index_2",
    "ignore_unavailable": "true",
    "include_global_state": false,
    "rename_pattern": "index_(.+)",
    "rename_replacement": "restored_index_$1"
}'
```

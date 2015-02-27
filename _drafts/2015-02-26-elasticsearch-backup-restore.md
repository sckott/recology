---
name: elasticsearch-backup-restore
layout: post
title: Elasticsearch backup and restore
date: 2015-02-26
author: Scott Chamberlain
sourceslug: _drafts/2015-02-26-elasticsearch-backup-restore.Rmd
tags:
- elasticsearch
---

## setup backup

```
curl -XPUT 'http://localhost:9200/_snapshot/my_backup/' -d '{
    "type": "fs",
    "settings": {
        "location": "/Users/sacmac/esbackups/my_backup",
        "compress": true
    }
}'
```

## create backup

```
http PUT "localhost:9200/_snapshot/my_backup/snapshot_2?wait_for_completion=true"
```

## get info on snapshot

```
http "localhost:9200/_snapshot/my_backup/snapshot_2"
```

## restore

```
curl -XPOST "localhost:9200/_snapshot/my_backup/snapshot_2/_restore"
```

## partial restore, including various options that can be used

```
curl -XPOST "localhost:9200/_snapshot/my_backup/snapshot_2/_restore" -d '{
    "indices": "index_1,index_2",
    "ignore_unavailable": "true",
    "include_global_state": false,
    "rename_pattern": "index_(.+)",
    "rename_replacement": "restored_index_$1"
}'
```

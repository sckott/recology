---
name: secure-elasticsearch
layout: post
title: note to self, secure elasticsearch
date: 2015-02-26
author: Scott Chamberlain
sourceslug: _drafts/2015-02-26-secure-elasticsearch.Rmd
tags:
- R
- elasticsearch
- security
---

Recently I spun up a box on DigitalOcean planning to make a tens of thousdands of queries to an Elasticsearch instance on the same box. I could have done this on my own machine, but didn't want to take up compute resources.

I installed R and Elasticsearch on a 2 GB droplet, then went about doing my thang.

A day later when things were still running, DigitalOcean sent me a message that apparently my box had been serving up a DDoS attack.

This was incredibly surprising, as I don't even know how to do such a thing.

After some digging it seems that the culprit was likely Elasticsearch, as a number of tutorials/blog posts state that Elaticsearch is insecure by default, so if it's exposed on a public port, someone can hack in. I had only used Elasticsearch locally on my own machine, so I hadn't thought about security. Here's a few resources for security help:

* [DigitalOcean tutorial no. 1][do1]
* [DigitalOcean tutorial no. 2][do2]
* [Blog post on securing ES][saskia]
* [SO answer on securing ES][so]

Trying to narrow down the various pieces of advice for securing Elasticsearch, here's a list:

* Use `iptables` (or rather [nftables][nftables]?) to firewall the box
* Whitelist certain trusted IPs 
* Use the [`elasticsearch-http-basic`][esbasic] plugin, adds basic username/pwd login
* Remove public access: use `network.bind_host: localhost` and `script.disable_dynamic: true` in the `elasticsearch.yml` config file [from][do1]

Elasticsearch provides a new feature for security that's built into Elasticsearch, [Shield](http://www.elasticsearch.org/overview/shield/), but I believe it's only available to enterprise customers. Boo. 

[do1]: https://www.digitalocean.com/community/tutorials/how-to-install-elasticsearch-on-an-ubuntu-vps
[do2]: https://www.digitalocean.com/community/tutorials/elasticsearch-fluentd-and-kibana-open-source-log-search-and-visualization
[esbasic]: https://github.com/Asquera/elasticsearch-http-basic
[saskia]: http://saskia-vola.com/install-secure-elasticsearch-1-x-digital-ocean/
[so]: http://stackoverflow.com/questions/26006373/how-to-secure-a-digital-ocean-elasticsearch-cluster
[nftables]: http://en.wikipedia.org/wiki/Nftables

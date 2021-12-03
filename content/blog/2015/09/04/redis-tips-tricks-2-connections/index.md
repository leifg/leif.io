---
title: "Redis Tips & Tricks #2 - Connections"
date: 2015-09-04T11:30:44-07:00
draft: false
tags: [redis]
categories: [programming]
---

As it turns out, connecting to redis may introduce a bit of problem if you're not aware of the connection handling.

I haven't tried with every client out there but especially the [redis ruby client](https://github.com/redis/redis-rb) has this problem.

So imagine this scenario:

```ruby
(1..10000).each{|num| Redis.connect.get("key_#{num}")}
```


Every iteration will open a new file handle and will keep it open (I have not been waiting forever but I have seen open files for more than 24 hours).

Try this on a ruby console and monitor the open files with:

```shell
watch -n1 "lsof -p <PID> | grep <REDIS_PORT>"
```


Of course it's easy to fix in the example above but imagine you are writing a threaded program that accesses redis (e.g. [Sidekiq](http://sidekiq.org/) worker).

In that case you want to implement a [connection pool](https://github.com/mperham/connection_pool).

So be careful when spawning redis connections.

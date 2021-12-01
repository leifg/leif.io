---
title: "Redis Tips & Tricks #1 - Memory"
date: 2014-12-19T17:15:36+00:00
draft: false
tags: [redis]
categories: [programming]
---

It's neither a tip, nor a trick. It's more a statement:

**ALL data is kept in memory**

"No shit" some of you might say, but I actually have to confess: I did not know that when I started using redis. I always assumed "there is a file on the disk, that is where my data lives".

The truth is: all of redis' data is kept in memory and from time to time it is [also written to disk](http://redis.io/topics/persistence)

This has 2 effects:

- As the database grows, so grows its memory consumption
- If your machine crashes all data that hasn't been written to the disk is lost.

So keep that in mind when you want to use redis.

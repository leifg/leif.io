---
title: "Grep Bundler Version From Gemfile.lock"
date: 2021-12-10T17:31:27-08:00
draft: false
tags: [ruby]
categories: [programming]
---

If you're working on any kind of Ruby project you probably won't be able to avoid [bundler](https://bundler.io).

This is just a quick tip to install the exact same version of bundler than the Gemfile was originally installed with.

Here you go:

```shell
gem install bundler -v $(grep 'BUNDLED WITH' -A1 Gemfile.lock | tail -n 1 )
```

I used it a couple of times and it can be useful to keep bundler versions in sync when you're using [docker](https://www.docker.com).


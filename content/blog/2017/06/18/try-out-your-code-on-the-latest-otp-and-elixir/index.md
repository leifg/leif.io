---
title: Try out your code on the latest OTP and Elixir
date: 2017-06-18T20:06:44+02:00
draft: false
tags: [elixir]
categories: [programming]
---

*TL;DR:* If you want an easy way to run the latest version of elixir (an the latest version of OTP) and you have docker installed, do this:

```shell
docker pull leifg/elixir:edge
docker run --rm -it leifg/elixir:edge iex
```

## Elixir Docker Builds

A while ago I started building my custom [Elixir Docker image](https://hub.docker.com/r/leifg/elixir) using [Github](github.com/leifg/docker-elixir) and [Docker hub automated builds](https://docs.docker.com/docker-hub/builds/).

I tagged the Elixir versions I wanted to build to create a `1.x` and `1.x.y` tag on Docker Hub. In addition the `master` branch would be tagged with `latest`. I always used the latest stable OTP to reduce complexity.

This was working fine and I was using these images for various projects.

## Edge Builds

Then came the time when I actually wanted to try out code with the latest Elixir (and OTP) version.

So I created a `stable` branch. On this branch the only Docker builds that happen are based on tags.

The master branch is then exclusively used for edge builds. Meaning: [Erlang/OTP master](https://github.com/erlang/otp) and [Elixir master](https://github.com/elixir-lang/elixir) will be built as soon as a build is triggered on Docker hub.

## Automatic Builds

At this point builds on Docker hub were only triggered when the configured repository (in my case [leifg/docker-elixir](https://github.com/leifg/docker-elixir)) is updated.

But I wanted to have a new image whenever something in Elixir or Erlang/OTP master changes.

Luckily Docker hub provides a feature called [remote build triggers](https://docs.docker.com/docker-hub/builds/#remote-build-triggers).

I ended up utilizing [Zapier](https://zapier.com/) using the [Github Trigger](https://zapier.com/help/github/) and the [Webhook Action](https://zapier.com/help/webhooks/#supported-actions) to start a new build on Docker hub every time a commit on Elixir (or Erlang/OTP) master happens.

## Bottom line

Unfortunately the docker builds take quite long (~30 min) and Zapier only triggers POST requests only every 15 minutes (at least in my tier).

But nevertheless: ~1h after a commit on these 2 repos you are able to play around with the built version.

```shell
docker pull leifg/elixir:edge
docker run --rm -it leifg/elixir:edge iex
```

If unsure which commit you are using have a look in the `info.txt` file in the root directory:

```shell
docker run --rm -it leifg/elixir:edge cat /info.txt

ERLANG_BUILD=cdc5545536ddeedf9ae4db20464afa6565f4327d
ERLANG_VERSION=20.0-rc2
ELIXIR_BUILD=d9f11dd3ff68246765ff7be3c779df0d4bd20eeb
ELIXIR_VERSION=1.5.0-dev
```

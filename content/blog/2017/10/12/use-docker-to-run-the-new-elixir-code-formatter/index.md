---
title: Use docker to run the new Elixir Code Formatter
date: 2017-10-12T15:47:33+00:00
draft: false
tags: [elixir]
categories: [programming]
---

*TL;DR:* Run this to format your code:

```shell
docker run --rm -it -v $(pwd):/app -w /app leifg/elixir:edge mix format
```


The community has been very excited in the last couple of days about the [Elixir 1.6 Code Formatter Announcement](http://devonestes.herokuapp.com/everything-you-need-to-know-about-elixirs-new-formatter).

Of course you can use one of the many [Elixir](https://github.com/mururu/exenv)[Version](https://github.com/asdf-vm/asdf)[Management](https://github.com/robisonsantos/evm)[Tools](https://github.com/taylor/kiex) to try out the formatter. But if you don't want to switch around between versions or if you (like me) stick to system Elixir, there is an easier way: Docker.

I already wrote about how to try out the [latest Elixir in a Docker Container](__GHOST_URL__/continuous-elixir-builds-with-docker/). The same principle applies here.

So here is how you format your code:

**Update your edge Elixir image**

```shell
docker pull leifg/elixir:edge
```


**Setup your formatter options**

Create a `.formatter.exs` file:

```elixir
[
  inputs: [
    "lib/**/*.{ex,exs}",
    "test/**/*.{ex,exs}",
    "mix.exs"
  ]
]
```

**Run the formatter in Docker**

```shell
docker run --rm -it -v $(pwd):/app -w /app leifg/elixir:edge mix format
```

Explanation: you are going to mount your current directory in the docker container and then pass in the format command.

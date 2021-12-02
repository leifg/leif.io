---
title: Deploying Elixir with Docker Part 1
date: 2017-08-11T17:37:45+00:00
draft: false
tags: [elixir]
categories: [programming]
---

This is a multi part article about deployment of an Elixir application with Docker.

This part will be about building a distillery release for a Phoenix Application.

[Part 2](/blog/2017/08/17/deploying-elixir-with-docker-part-2/) will discuss packaging this release into a Docker container

[Part 3](/blog/2017/08/25/deploying-elixir-with-docker-part-3/) will show you how to deploy this container to a container runtime.

[Part 4](/blog/2017/09/01/deploying-elixir-with-docker-part-4/) will wrap it all up and show you how to integrate all if this into a Continuous Delivery Workflow

## Situation

I developed a [Phoenix](phoenixframework.org) application that helps me with my everyday freelance time tracking. I use [toggl](https://toggl.com) for all my time tracking at my clients but I use [Fastbill](https://fastbill.com) for all my invoicing.

As there is no direct integration, I had to build a project myself. Phoenix might be a little overkill for such a task but it was a good learning at the time. This tool saves my hours of work and I use it on a daily basis.

It's pretty simple. I use [Zapier](https://zapier.com) to issue a webhook for every new toggl entry and the Phoenix app will call the Fastbill API to create a time slot. No state, very low maintenance. I have not released a new version of the project for over a year. You can see the version that is deployed on Heroku in the [GitHub history](https://github.com/leifg/time_tracking/tree/043d5b133ea52c6d4a851d27a91d6423f25d595f).

To sum up the application:

- Phoenix App, API only
- Continuous Delivery via [CircleCI](https://circleci.com) (v1)
- Semantic Release with [node.js package](https://github.com/semantic-release/semantic-release)
- Deployed on Heroku

As I have not touched it for a year I thought: Why not get my hands dirty and change something with the deployment.

I really like [Docker](https://www.docker.com/) and [Distillery](https://github.com/bitwalker/distillery) so I wanted to try out how that works with Elixir projects. Also I stumbled upon [hyper.sh](https://hyper.sh) so why not give that a try.

## Adding Distillery

The first task is to setup distillery to compile the app into a release.

First step here: add [distillery](https://github.com/bitwalker/distillery) to the `mix.exs` file:

```elixir
{:distillery, "~> 1.4"}
```


After that: create the necessary release configuration. You can use the bundled mix task for that:

```shell
mix release.init
```

After that you should see something like this:

```shell
An example config file has been placed in rel/config.exs, review it,
make edits as needed/desired, and then run `mix release` to build the release
```


The default options are good enough for us now.

## Configuration

In theory a simple `MIX_ENV=prod mix release --env=prod` will build the release and we can proceed deploying it, but in practice this will likely fail due to how the configuration works. So let's have a look on what the problem is.

My `prod.secret.exs` looks like this:

```elixir
config :time_tracking, TimeTracking.Endpoint,
  secret_key_base: System.get_env("SECRET_KEY_BASE")

config :time_tracking,
  fastbill_email: System.get_env("FASTBILL_EMAIL"),
  fastbill_token: System.get_env("FASTBILL_TOKEN"),
  fastbill_timezone: System.get_env("FASTBILL_TIMEZONE")
```


This is a fairly common pattern in Elixir projects. Make sure the environment variables will be set on the production system, and then just start the application.

As Distillery will convert all your `config/*` files into an Erlang sys.config file, all your dynamic fragments will be evaluated at build time.

So unless you have all your environment variables ready at **build time** your app will not behave correctly. Read more about configuration in the [distillery documentation](https://hexdocs.pm/distillery/runtime-configuration.html#config-exs-sys-config)

So you'll need to find another way. There are several options but the one that worked best for me was the `REPLACE_OS_VARS` feature provided by Distillery. This is how it works: You replace all your values in the config file with `${ENV_NAME}`. They will be replaced upon startup of the app.

After this adjustment my `prod.secret.exs` looks like this:

```elixir
config :time_tracking, TimeTracking.Endpoint,
  secret_key_base: "${SECRET_KEY_BASE}"

config :time_tracking,
  fastbill_email: "${FASTBILL_EMAIL}",
  fastbill_token: "${FASTBILL_TOKEN}",
  fastbill_timezone: "${FASTBILL_TIMEZONE}"
```


In addition I used this syntax for the production cookie (which is needed when you want to connect to a running Erlang VM) in `rel/config.exs`.

```elixir
environment :prod do
  set include_erts: true
  set include_src: false
  set cookie: :"${PRODUCTION_COOKIE}"
end
```


Furthermore it never hurts to configure the port from the outside:

Also make sure you set `server` to `true` so that phoenix will start with the release.

```elixir
config :time_tracking, TimeTrackingWeb.Endpoint,
  http: [port: "${PORT}"],
  url: [host: "localhost", port: "${PORT}"],
  server: true
```


As I don't have any assets to compile, we are done here but additional information can be found in the [Distillery Documentation](https://hexdocs.pm/distillery/use-with-phoenix.html)

That was the first part of deploying an Elixir application. The next part will talk about integrating the built release with Docker.

*Continue with [part 2](/blog/2017/08/17/deploying-elixir-with-docker-part-2/) of this post*

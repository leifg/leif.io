---
title: Deploying Elixir with Docker Part 2
date: 2017-08-17T16:20:26+00:00
draft: false
tags: [elixir]
categories: [programming]
---

*This is a continuation of the [first part](/blog/2017/08/11/deploying-elixir-projects-with-docker-and-distillery/) of the post where we created a release.*

Now that we have a release, let's pack it into a docker container.

We will use a [multi stage container](https://docs.docker.com/engine/userguide/eng-image/multistage-build/) to create the container.

First let's focus on the build part. A base container will come in handy as we need to run several commands. We need Erlang and Elixir installed (obviously) but I also need a tool to calculate the version number. I use [Semantic Release](https://github.com/semantic-release) for that. I decided to switch from the [JavaScript version](https://github.com/semantic-release/semantic-release) to the [Go version](https://github.com/semantic-release/go-semantic-release).

## Building

I created a base image called `leifg/time_tracking-base`. Head on over to [Github](https://github.com/leifg/time_tracking-base/blob/master/Dockerfile) to have a detailed look.

The base image is used to build the container that we will then deploy. Because we are using a multi stage container, we package multiple Dockerfiles into one.

```dockerfile
FROM leifg/time_tracking-base as builder
MAINTAINER Leif Gensert <leif@leif.io>

ENV MIX_ENV=prod
ENV REPLACE_OS_VARS=true

RUN apk add --no-cache build-base

COPY . /app

WORKDIR /app

# Read version from mix.exs and store it in .version
RUN echo $(cat mix.exs| grep version: | head -n1 | awk -F: '{print $2}' | sed 's/[\",]//g' | tr -d '[[:space:]]') > .version
RUN mix deps.get
RUN mix compile
RUN ls -lha /app
RUN mix release --env=prod
RUN mkdir -p /app/target
RUN tar xzf /app/_build/prod/rel/time_tracking/releases/$(cat .version)/time_tracking.tar.gz -C /app/target/
```


This build script will read the version from our `mix.exs` file and write it to a file. Later we can read this file to find the compressed file which includes all the files for the release.

We will change this later to calculate the version automatically via a semantic-release script.

## Runtime Container

The build container is of much use for running our application. That's why we need the runtime container. It looks pretty simple:

```dockerfile
FROM alpine:3.6
MAINTAINER Leif Gensert <leif@leif.io>

RUN apk add --no-cache ncurses-libs openssl

COPY --from=builder /app/target /app
COPY --from=builder /app/.version /app/

ENTRYPOINT ["app/bin/time_tracking"]
CMD ["foreground"]
```


**Note:** these are not two Dockerfiles. Both of these snippets are contained in one file.

All it does is it copies the built version from the other image and sets the start command. Because we're using Docker, running the app in the foreground is fine.

We need the version file to properly tag the version.

To run all of this let's wrap all of this in a little build script:

```shell
#!/bin/sh
# build.sh
set -e

docker build -t leifg/time_tracking .

export VERSION=$(docker run --rm --entrypoint="" leifg/time_tracking cat /app/.version)
docker tag leifg/time_tracking:latest leifg/time_tracking:${VERSION}
```

In order to get the version for tagging, it is necessary to run the container and read the `.version` file. Later we will see how to get around this.

After running the build script you will see 2 images:

```shell
docker ps
REPOSITORY                    TAG                 IMAGE ID            CREATED             SIZE
leifg/time_tracking           1.8.3               5f5ccec06dda        About a minute ago   37.3MB
leifg/time_tracking           latest              5f5ccec06dda        About a minute ago   37.3MB
```


For any service to reference these containers, we need to publish it to a remote registry:

The easiest one is to just [push it to Docke Hub](https://docs.docker.com/docker-cloud/builds/push-images/)

```shell
docker push leifg/time_tracking:${VERSION}
docker push leifg/time_tracking:latest
```


That's it, we have a fully functional version that we can run on any machine that has the docker engine installed.

In the [next part](/blog/2017/08/25/deploying-elixir-with-docker-part-3/) we will go ahead and deploy this container.

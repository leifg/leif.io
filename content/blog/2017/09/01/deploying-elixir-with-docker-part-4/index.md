---
title: Deploying Elixir with Docker Part 4
date: 2017-09-01T15:36:28+00:00
draft: false
tags: [elixir]
categories: [programming]
---

This last post is about bringing it all together.

Right now we are at a point where we have random script snippets that executed in the right order will launch a service in the cloud.

But we need to get this in a more structured way on a build server. As a CI provider I use [CircleCI](https://circleci.com) and I've been waiting to try out their [2.0 version](https://circleci.com/docs/2.0/) including [workflows](https://circleci.com/docs/2.0/workflows/).

As CircleCI heavily relies on Docker, we can just go ahead and use our [base image](https://hub.docker.com/r/leifg/time_tracking-base/) for building.

CircleCI lets you build Docker images inside a Docker container, so we can use this to our advantage. We don't need the build container anymore and just provide a Dockerfile for the run container.

The result is this:

```dockerfile
FROM alpine:3.6
MAINTAINER Leif Gensert <leif@leif.io>

RUN apk add --no-cache ncurses-libs openssl

ARG VERSION

ADD _build/prod/rel/time_tracking/releases/${VERSION}/time_tracking.tar.gz /app

ENTRYPOINT ["app/bin/time_tracking"]
CMD ["foreground"]
```


We need to provide the version on build time to find the correct archive to use but more on that later.

For the build to work we need a couple of environment variables namely:

- `DOCKER_USER`
- `DOCKER_PASS`
- `FASTBILL_EMAIL`
- `FASTBILL_TIMEZONE`
- `FASTBILL_TOKEN`
- `GH_TOKEN`
- `HYPER_ACCESS`
- `HYPER_SECRET`
- `PRODUCTION_COOKIE`
- `SECRET_KEY_BASE`

Exposing that many secrets to the CI system is not ideal. But as we need to start our container from the CI system and hyper.sh has no way of storing configuring variables there is no way around it.

The deployment is split up in 3 parts: build, test and deploy. Build and test are pretty straight forward. They can actually be put in one step but for the sake of the challenge I separated them.

Have a look at the [circle config](https://github.com/leifg/time_tracking/blob/32c9d4b45c3a336f69011f4db00a83aebb2da7e4/.circleci/config.yml) if you're interested in the details.

The interesting part is the deployment workflow so we'll focus on this. The name "deploy" is not 100% correct because we are also building the release for the production in this step as well, but let's go through it one by one.

Before we start building we need to calculate our version number. This step is completely optional. For our process we use the [Go version of semantic release](https://github.com/semantic-release/go-semantic-release) which basically evaluates the commits since the last release calculates the new version number (based on patch, minor or major changes) and in the end bump up the version number. For more information see the [docs in the Github repo](https://github.com/semantic-release/semantic-release).

The command is: `semantic-release -vf -slug leifg/time_tracking -noci || true`. If the command succeeds the version will be written to the `.version` file. If it fails the process will stop here and the deployment will be stopped (but returning a zero return code).

After that the [deployment script](https://github.com/leifg/time_tracking/blob/4eb0bb87ecb1966d8538bcbe6deebc9e9094c7e0/script/ci/deploy.sh) will run. These are steps that are happening:

- [Replace the version in the mix.exs file](https://github.com/leifg/time_tracking/blob/4eb0bb87ecb1966d8538bcbe6deebc9e9094c7e0/script/ci/steps/replace_version.sh)
- [Build the release with Distillery](https://github.com/leifg/time_tracking/blob/4eb0bb87ecb1966d8538bcbe6deebc9e9094c7e0/script/ci/steps/build_release.sh)
- [Package Release in a run container](https://github.com/leifg/time_tracking/blob/4eb0bb87ecb1966d8538bcbe6deebc9e9094c7e0/script/ci/steps/build_container.sh)
- [Push Container to Docker Hub](https://github.com/leifg/time_tracking/blob/4eb0bb87ecb1966d8538bcbe6deebc9e9094c7e0/script/ci/steps/push_to_docker_hub.sh)
- [Start container on hyper.sh](https://github.com/leifg/time_tracking/blob/4eb0bb87ecb1966d8538bcbe6deebc9e9094c7e0/script/ci/steps/push_to_hyper.sh)

The last step will bring up a new container, switch the [FIP](https://docs.hyper.sh/Feature/network/fip.html) to the new container and then stop the old container to enable (almost) zero downtime deployment.

## Conclusion

It goes without saying that this an advanced deployment process. I hope you got some learnings from it and can reuse some of the code snippets provided. After all I'm still a big proponent of Docker and will adapt this deployment for future projects.

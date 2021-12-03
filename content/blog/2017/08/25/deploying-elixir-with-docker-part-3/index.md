---
title: Deploying Elixir with Docker Part 3
date: 2017-08-25T09:51:33+02:00
draft: false
tags: [elixir]
categories: [programming]
---

*This is the third part of the Docker Elixir deployment adventure. Read [part 1](/blog/2017/08/11/deploying-elixir-projects-with-docker-and-distillery/) and [part 2](/blog/2017/08/17/deploying-elixir-with-docker-part-2/) first.*

In this part we are going to deploy our Docker container to [hyper.sh](https://console.hyper.sh/register/invite/j6lwdRzl5duM1ar7jM4Ktgzj8rae9xIj) (Affiliate Link). It's a relatively new platform that makes it very easy to deploy containers.

You will need the hyper cli to get started. Refer to the [official documentation](https://docs.hyper.sh/GettingStarted/install.html) for details.

We will start by starting an instance of our container. By the time of writing this blog post, the latest version of time_tracking is `1.8.3`:

```shell
hyper run -d --size=s2 -e PORT=8080 -e PRODUCTION_COOKIE=secret -e REPLACE_OS_VARS=true -p 8080:8080 --name timetracking leifg/time_tracking:1.8.3
```


Now our app is technically running. There is just no way to access it. For outside access you need to assign and IP address. Hyper has something called  [floating IP](https://docs.hyper.sh/Feature/network/fip.html). You will get an IP that you can then assign to single containers.

```shell
hyper fip allocate 1
6.6.6.6
```


In addition to that we will assign a name to our created ip:

```shell
hyper fip name 6.6.6.6 timetrackingip
```


The last step is to attach our running container.

```shell
hyper fip attach timetrackingip timetracking
```


Now the container is accessible from the internet. Let's test it:

```shell
$ curl -I 6.6.6.6:8080
HTTP/1.1 401 Unauthorized
server: Cowboy
date: Sun, 06 Aug 2017 19:22:27 GMT
content-length: 0
cache-control: max-age=0, private, must-revalidate
x-request-id: rpo580p0hg64g7cbrkg97o3b5amsiacv
www-authenticate: Basic realm="Private Area"
```


This is a very simple solution, as all the HTTP handling is done directly by Cowboy. In a real world scenario you probably want to have an nginx in front of your application server. You also probably want to have some kind of load balancing. [Hyper's Service Solution](https://docs.hyper.sh/Feature/container/service.html) is something to consider for that.

For now we will stick with a static IP addriss exposed via HTTP.

Continue reading in the [last part](/blog/2017/09/01/deploying-elixir-with-docker-part-4/) on how to bring this all together on [CircleCI](https://circleci.com).

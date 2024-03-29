---
title: Implement a GIT Branch Checkout History
date: 2021-02-22T16:11:46-08:00
draft: false
tags: [git]
categories: [programming]
---

Take this alias

```shell
# .gitconfig

[alias]
    hist = "!f() { for i in $(seq 9 $END); do echo "@{-$i}: `git rev-parse --abbrev-ref @{-$i}`"; done }; f "
```

This will show the last 9 branches you have checked out with the abbreviation to switch to it.

``` shell
❯ git hist
@{-1}: main
@{-2}: add-healthchecks-io
@{-3}: main
@{-4}: fix-visible-flag
@{-5}: main
@{-6}: implement-join-code
@{-7}: main
@{-8}: fix-visible-flag
@{-9}: main
```

You can of course use the branch name to check it out, or use the abbreviation in front of it `git checkout @{-6}` will check out `implement-join-code`.

*Attribution: [Trees Avenue Road](https://pixabay.com/photos/trees-avenue-road-the-dark-hedges-3464777/) by [DarkmoonArt_de](https://pixabay.com/users/darkmoonart_de-1664300)*

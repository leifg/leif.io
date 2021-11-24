---
title: "Morf Hashes Into Hashes"
date: 2013-12-21T15:14:33+00:00
draft: false
tags: [projects,ruby]
categories: [programming]
---

In the last few months I did a lot of work concerning imports.

Using the [Sequel Toolokit](http://sequel.jeremyevans.net/) I was able to treat every query row as a hash and the whole thing has been working out pretty good so far.

However I always needed to do conversions on the hashes (map keys to a different name, concatenate values etc....). Therefore I implemented several mapping classes that helped me with that but was never quite satisfied with the implementation.

Then I stumbled upon [ActiveImporter](https://github.com/continuum/active_importer) and I knew: "That's exactly what I need".

Unfortunately ActiveImporter is designed to import table data into models.

I need to transform array of hashes into other array of hashes.

That's why I built [morfo](https://github.com/leifg/morfo). It uses a similar DSL as ActiveImporter to do just this.

It is at a very early stage and currently only supports [simple mappings](https://github.com/leifg/morfo/blob/d80998ff37b5614233c4458060af66eeee1623e9/README.md#usage), [nested mappings](https://github.com/leifg/morfo/blob/d80998ff37b5614233c4458060af66eeee1623e9/README.md#nested-values) and [transformations](https://github.com/leifg/morfo/blob/d80998ff37b5614233c4458060af66eeee1623e9/README.md#transformations).

But I will continue to use it and implement new features on the way.

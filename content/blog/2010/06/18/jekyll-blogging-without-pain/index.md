---
title: "Jekyll: Blogging Without Pain"
date: 2010-06-18T02:21:00+02:00
draft: false
tags: [java,play]
categories: [programming]
---

A long time hast passed since my last blog post. But I did a complete redesign of my blog. Not only is the frontend completely different. The underlying backend has changed as well. I completely freed myself from [Wordpress](http://wordpress.com) and changed to an engine that fits my workflow much better: [jekyll](http://wiki.github.com/mojombo/jekyll/).

To call jekyll a blogging-engine is (IMHO) not quite right. It's just a generator for static contents. The general idea behind it is that you write all your articles in a markup language (e.g. [HTML](http://www.w3.org/MarkUp/), [Markdown](http://daringfireball.net/projects/markdown/) or [Textile](http://textile.thresholdstate.com/)), define the layout via the [Liquid Templating engine](http://www.liquidmarkup.org/), run the jekyll generator and end up with a complete directory structure containing HTML/CSS and JavaScript files which can be used as the actual site.

There is this one [blog post](http://tom.preston-werner.com/2008/11/17/blogging-like-a-hacker.html) which refers to jekyll as "Blogging Like a Hacker". Which describes it pretty well. There are some things about jekyll that support this statement:

## reasons why jekyll makes you feel like a hacker

### website is a github repository

Instead of having an official web-site with screenshots, feature list and downloads, the main resource for jekyll is [this github repository](http://github.com/mojombo/jekyll). Which is not a bad thing at all, because the infrastructure github provides is totally sufficient for hosting application websites (you have a built-in downloads-section, a wiki and even an issue tracker).

### no WYSIWYG-Editor

Every major blogging engine out there comes with a built-in Richt-Text Editor. I always hated it to create blog posts using this online editors. I never got to make a blog post look like I wanted to. Furthermore the copy&paste never worked as expected and I had to be concerned about data loss (clicking the wrong button or browser crash could lead to instant loss). Jekyll is basically editing text files on your hard drive in your preferred markup-language, that's what solved most of the problems described (at least for me).

### lots of examples to copy from

In addition to the [documentation in the wiki](http://wiki.github.com/mojombo/jekyll/) there is a [list of sites](http://wiki.github.com/mojombo/jekyll/sites) that are already using jekyll for their site. Most of them grant access to their complete file infrastructure as well. So if you try to find out how to do certain things (integrate an RSS-Feed, integrate Google Analytics, integrate a JavaScript based commenting system) you can just look through the sites and see how it's done (nice bonus: you stumble upon some nice blogs).

## how I use jekyll

The second I saw the tutorial on how to integrate [jekyll and git](http://matedriven.com.ar/2009/04/28/using-git-to-maintain-your-blog.html), I knew that this was the way I wanted to use it. A simple git push publishes my blog on my vServer.
Furthermore I put all the blog files in my [Dropbox](http://www.dropbox.com), so that I can edit any article on all my devices.
Then I stumbled upon the `--server` flag and was blown away. A simple `jekyll --server --auto` binds the output of the generator to my local ip-address, so I can see my changes right away. I can even go one step further and do a `jekyll --auto <dir>` to write the static content to my public Dropbox folder and pass the public link on to a friend for a review.

## conclusion

This process of publishing works surprisingly well for me. You'll loose a lot of feature the majority of dynamic blogging engines have, but you'll have the whole progress in your control. You have to bring in a certain knowledge about HTML, markup languages and a general understanding of templating but after that using jekyll is just fun.

picture taken by [ell-r-brown](http://www.flickr.com/photos/ell-r-brown/4360911760/)/[CC BY 2.0 ](http://creativecommons.org/licenses/by/2.0/deed.en)

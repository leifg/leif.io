---
title: "Overengineering My Blog for Fun and Definitely not Profit"
date: 2021-12-07T17:08:09-08:00
draft: false
tags: [blog]
categories: [programming]
---

![New Blog](header.jpg)

This publication has been around a while. According to my [first article](/blog/2010/01/04/what-i-like-about-the-play-framework/) it goes back all the way to January 2010 and was hosted on Wordpress. In the meantime I switched from there to [Jekyll](/blog/2010/06/18/jekyll-blogging-without-pain/) until I switched to [ghost](/blog/2013/12/13/im-blogging-again/) in late 2013.

This is where the blog spent most of its time, and even thought I had [some](https://news.ycombinator.com/item?id=15909870) [stories](https://news.ycombinator.com/item?id=27210604) reach the front page of Hacker News it was mostly quiet around here and infrequently updated (I did not write a single post in all of 2016).

Like a lot of computer enthusiasts I always found it more rewarding to tinker with technology than write about it. So naturally I came to the point where I wanted to change the underlying blogging engine once again. I really like the idea of static site generators. In my experience a (personal) blog does not really benefit from interactivity, so having a bunch of html files fulfills 100% of my use cases. Even comments these days are outsourced to Twitter or Hacker News.

I mostly chose [ghost](https://ghost.org) for its markdown support because I really like that format for writing. But I always felt a little uneasy that I didn't have total control over my content. This is less an idealistic view as a matter of reliability. Sometimes the internet is down or inaccessible and I still want to write something. In addition to that growing up in the early 2000s I still have this fear of content being lost if you type it into a web form and close the browser. Furthermore if I chose to move platforms again I can [automate a lot of the transformation](https://xkcd.com/1319/).

After a small amount of research I decided on [Hugo](https://gohugo.io) as my static site generator. I decided to publish all the source code on [Github](http://github.com/leifg/leif.io) because I always appreciate learning from other people's code and I hope some of the things I achieved with my blog are useful.

I set up a deployment system with [netlify](https://netlify.com) and even wrote [a script](https://github.com/leifg/leif.io/blob/main/update_time_in_article.rb) to move articles to a different day.

I'm still struggling with finding a good solutions for drafts because I don't want to publicize my articles until I am happy with them. So for now I am pushing all my drafts to a private copy of the repo and moving them over shortly before publishing.

All of this took me about 3 weeks of on and off tinkering to set it up and converting all my articles but I'm quite happy with the result. This would probably a completely unacceptable timeline for any professional blogger or marketing department but because this is a side project and can do what I want.

From time to time I went a [little overboard](https://github.com/leifg/leif.io/pull/12) but I did enjoy the journey, after all tinkering with software is what I love :heart:.



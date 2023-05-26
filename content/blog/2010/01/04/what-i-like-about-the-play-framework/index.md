---
title: "What I Like About the Play Framework"
date: 2010-01-04T23:28:00+01:00
tags: [java,scala,play!]
draft: false
---

Recently I stumbled upon the [play! framework](http://playframework.org). Being a fan of [Ruby on Rails](http://rubyonrails.org) my [first thought](http://twitter.com/leifg/status/5070708645) was: 'It's like Ruby on Rails, except that it's Java'. But I had to find out for myself. And I have to say: I really like it. In detail I would like to point out 4 things I like the most.

## 1. Ships with everything you need

Everything you could wish for, it's there: [ORM]( g/documentation/1.0/model), [Testing](http://www.playframework.org/documentation/1.0/test), [Job Scheduling](http://www.playframework.org/documentation/1.0/jobs), [Mailing](http://www.playframework.org/documentation/1.0/emails), [extended CSS](http://www.playframework.org/documentation/1.0/ecss), [Captchas](http://www.playframework.org/documentation/1.0/guide5) and even [OpenID](http://www.playframework.org/documentation/1.0/guide5). All of it is delivered with the default distribution.
Furthermore, it is a piece of cake to develop in the IDE of your choice (e.g. a simple `play eclipsify` creates all the necessary workspace files you'll need to develop your project in Eclipse).
I hope there will be 3rd party extensions to include even more stuff.

## 2. Lots of documentation

One thing that got me involved very quickly was the great documentation. I looked through most of features on a 3h train ride. Not only is there sufficient documentation of all the features available. You also get a step by step guide for a simple blogging engine (which, by the way contains most of the features). Such a guide is helpful to first learn the framework. If you want to dig deeper, there's always the reference. And if that's not enough the JavaDoc for the framework is just waiting around the corner.

## 3. Multi language support

By multi language support I don't mean that the template engine is using [Groovy](http://groovy.codehaus.org) for all the dynamic stuff in the frontend. I mean that it is possible to write the backend in something else than Java. Since version 1.1. play! is supporting [Scala](http://vimeo.com/7731173).

## 4. No getters and setters

Let's face it. The most annoying thing when writing Java code is having to generate large amounts of getters and setters. And even if you get around that, you still need to touch 4 different locations if you want to change the name of a member (name of attribute, name of getter, name of setter, name of parameter for the setter).
play! takes a different approach. You just declare all the member you want to have access to as `public`. I know that this technique is adressed in your first lesson of Java. You were told that you must not under any circumstance ever use public members. But the public declaration is only done for one reason: to fool the compiler. The play! framework will set the members to ´private´ and generate the getters and setters on runtime (if they're not already there).

## What I would like to see

As much as I like the framework there are several features I would like to see:

### Database migration

For now it is a huge pain to make changes to the data model after you have your application up and running. The only way to make changes to a date model is to discard the **complete model** (including already existing data) or to write migration scripts manually. I would really like to see a migration concept like [the one in Rails](http://guides.rubyonrails.org/getting_started.html#running-a-migration).

### More language support

As play! is using the JVM I would like to see more languages integrated that are already present on the JVM (especially [JRuby](http://jruby.org/)).

### Integration of alternative data structures

Being a fan of document-oriented databases (such as [CouchDB](http://couchdb.apache.org/) and [MongoDB](http://www.mongodb.org/)) I really would like to use these data structures in my web-application.

### Hosting services

I want to run my applications on a remote server without buying a root server.

## Conclusion

play! is a nice little framework, easy to set up and fun to use. So please use it as much as you can, so that the community grows and we'll see much more features be included.

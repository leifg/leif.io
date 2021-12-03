---
title: "Get Yourself a Simple Project for Explaining Stuff"
date: 2013-12-16T00:56:35+01:00
draft: false
tags: [ruby,advice,teaching]
categories: [programming]
---

A while ago I spent some time at home, working on a Rails project. I was very passionate about it and at one point I shouted out: "Finally! The tests are running".

That was the point when my dad got curious about what I was doing and asked me something like "What tests are you talking about?". I tried to showed him my specs. Unfortunately in order to explain the whole specs I also needed to explain ORM, mocking, factories and a couple of other stuff, because it was a Rails project and gotten pretty far by that point of time.
That got me thinking: "If it had been a simple class without any dependencies it would have been a lot easier to explain the tests."

The next logical step for me was: "Just write something simple and explain it next time".

But the most examples out there either include cars or animals. And I didn't want to write classes that are mutable (car that increases speed) or introduce inheritance (penguin inherits from bird).

I created are more abstract but still understandable example: a fraction.

So [check it out](http://github.com/leifg/riese) and [let me know](http://twitter.com/leifg) what you think.

---
title: How Playing Around With Experimental Technologies Landed Me A 6-Month Freelance Gig
slug: how-playing-around-with-experimental-technologies-landed-me-a-6-month-freelance-gig
date: 2017-12-12T21:52:28+00:00
date_updated: 2018-08-22T10:52:53+00:00
---

![compass](cover.jpg)

If you need to build an "Uber for X" product there is a simple path that gets the job done: Build an MVP with well-established technologies. Start with [Google Sheets](https://www.google.com/sheets/about/), [Typeform](https://www.typeform.com/) and a lot of Trello. Use Rails with a little bit of jQuery for a more custom solution. Capture as much feedback as possible and focus on iterating your MVP. This approach usually is referred to as the [The Lean Startup](http://theleanstartup.com/).

But what happens when you choose the exact opposite approach?

Rather than focus on quick outcome embrace over-engineering and the latest technologies. Instead of using technologies that get the job done, choose the technologies that you always wanted to use even if they might not be the best fit.

This is where the story of landing a 6-month freelance gig begins.

## How it started

Attending a lot of tech conferences I found myself with a 6 month free trial of [IBM's Cloud Platform](https://www.ibm.com/cloud/). I like free stuff so I thought: "I could probably build something cool in 6 months". I settled on building a podcast transcription service based on the [Watson Speech to Text API](https://www.ibm.com/watson/services/speech-to-text/).

They have a great integration with Docker so it was clear that this is going to be my choice of deployment. I also love [Elixir](https://elixir-lang.org/) and its web framework [Phoenix](http://phoenixframework.org). Having learned about [Event Sourcing](https://martinfowler.com/eaaDev/EventSourcing.html) shortly before this was also a given to me. The only choice left was what data storage to use. I am a big proponent of [PostgreSQL](https://www.postgresql.org/) but in this case, I couldn't find a great integration with the IBM platform so I took another leap. IBM cloud easily integrates with their own database [Cloudant](https://www.ibm.com/cloud/cloudant). Later in the project, I decided on [ELM](http://elm-lang.org/) as the frontend technology.

So to wrap up we have the following stack:

- Designing an Event Sourced System
- Running on  [IBM Cloud ](https://www.ibm.com/cloud/)
- Cloundant database layer
- Elixir Phoenix as the application layer
- ELM in the frontend
- All deployed by Docker

This stack is a pretty hard sell to management. But as I am my own boss in this scenario I can do whatever I want.

## The Road Ahead

Because I lacked experience in any of these technologies a lot of learning was involved. I took an [online course on ELM](https://pragmaticstudio.com/elm), read through the [IBM Cloud Docs](https://console.bluemix.net/docs/), built my own Docker-based CI pipeline to get my project deployed and of course, had to gather more knowledge in Event Sourcing and Phoenix. The toughest part, however, was getting Elixir to work together with Cloudant. There are no dedicated libraries for available but luckily Cloudant is API compatible with [Apache CouchDB](http://couchdb.apache.org/).

## Open Source Contributions necessary

There were a handful of libraries available for CouchDB. Luckily CouchDB (and Cloudant) provide an HTTP based API, so it would have been pretty simple to refrain from using a library. Nevertheless I decided to go with [mkrogemann/couchdb_connector](https://github.com/mkrogemann/couchdb_connector).

I found out pretty quickly though that the library was lacking features I desperately needed. So here is where had to make another decision. Will I amend the library, build my own data layer or give up on Cloudant completely?

I decided to go with option 1 and provide [a pull request](https://github.com/mkrogemann/couchdb_connector/pull/35) to the existing library. I was lucky and after some back and forth my PR was accepted and I could continue to tinker with my project.

## The End

In the end, my side project failed for several reasons:

- IBM's clumsy interface had me frustrated
- I designed myself into a corner (vaguely related to the fact that CouchDB views are not as versatile as I had hoped them to be)
- Most importantly: I lost interest

Continuing from here would have been very frustrating so I stopped the project.

## So...

Was it a waste of time? I don't think so.

- I learned to appreciate ELM
- I strengthened my knowledge in Docker, Event Sourcing
- I got to experience the limits of CouchDB views
- I got a great insight into IBM Cloud Platform

And on top of that:

Halfway through abandoning the project, I received an email from the maintainer of the [CouchDB library](https://github.com/mkrogemann/couchdb_connector). It turned out that he was living in the same city as I was. We met for coffee and got along great. I learned he just started as the CTO of freshly founded startup.

We kept in contact and after some back and forth I was able to come on board as a freelancer. I worked for 6 months in the development team using Elixir.

## In Conclusion

Of course, you can't expect to get clients just based on Open Source contributions.

My point here is: **There are advantages to starting a side project even if it never sees the light of the day.** If you are able to invest the time there is almost no downside to building a side project.

Often times the journey is the reward.

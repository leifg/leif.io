---
title: "Real World Ownership Is Not a Use Case for Blockchain"
date: 2021-05-16T15:36:39-07:00
draft: false
tags: [blockchain]
categories: [culture]
---

The "blockchain beyond cryptocurrency"-world is full of potential use cases that would supposedly change the game. I touched on it in my [last post](/blog/2021/05/03/the-convenient-problem-space-of-blockchain/) with a supply chain management example. But the use case proposals go much further than that.

Beyond the supply chain a lot of startups try to implement a use case around recording and transferring ownership of something. After all that's what cryptocurrencies are all about. So why can't we do that for anything? One example I've seen multiple times is recording ownership of art or luxury goods.

Let's think this through with an extreme example. Assume we have a globally accepted blockchain that records all art transaction. The whole world went through a rigorous process and we recorded all past transaction and issued keys to the rightful owners. The French state now has a private key with which they can prove that they own the Mona Lisa and they also recorded on the blockchain that the piece is currently on display in the Louvre. Within this process we avoided silly scenarios like [some rando suddenly owning the Mona Lisa](https://icoexaminer.com/ico-news/the-man-who-used-the-blockchain-to-lay-claim-to-the-mona-lisa/). The initial migration was a success.

I personally believe that is already a pipedream but bear with me.

Think of this scenario. The French government has a top notch security protocol in place to secure the private key to the ownership of the Mona Lisa. But we have a change of government and some high ranking government official gets corrupted. They have access to the keys and he uses them to transfer the Mona Lisa to one of his rich buddies Joe Shmoe.

What happens now? According to the blockchain Joe Shmoe is the rightful owner. Can he just enforce that ownership against the French government and force the Louvre to move the Mona Lisa to his beach house in St. Tropez? Or can the French government force him to reverse the transaction. But what if he is smart enough to destroy the private key? Transferring ownership at this point becomes virtually impossible.

This is an extreme example and I think no one would argue for a Big Bang introduction of an art blockchain. But it highlights the core problem of using blockchain for the real world. For every transfer of ownership you have 2 operations - one on the blockchain and one in the real world. These have to be in sync at all times to work properly. In Computer Science this is called an [atomic transaction](https://en.wikipedia.org/wiki/Atomicity_(database_systems)). You either execute all of the operations or none of them. This is already hard in a single system, it is near impossible within 2 systems and is essentially impossible if one of the systems is the real world.

One approach of solving this is defining one of the systems the source of truth. Blockchain enthusiasts would love the blockchain to be the source of truth for so many things but this is exactly where you run in silly problems as I described before (essentially the French state having to give up ownership of the Mona Lisa because the blockchain says so).

In reality the source of truth would most likely be the courts of the world. And we already have that. Unless the French state is OK with giving up ownership of the Mona Lisa (which would most certainly go through a complicated legal process), it will never change owners. And if it does, this is what we call theft and the French state has a legal mandate to take ownership back.

All in all: when your source of truth is the legal system, there is absolutely no point for a blockchain and you might as well record ownership in a database.

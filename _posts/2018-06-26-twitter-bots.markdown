---
layout: post
title: Twitter bots
date: 2018-06-03
preview: I do not like Twitter for communication. But it's an interesting platform for (mostly) free publication.
---

Advertisements line the highways in Mexico City. Drivers and passengers zoom by the brightly painted highway walls in heavy traffic, sometimes, I guess, actually reading a call-out and cognizing its message. I think of Twitter as the same kind of attention overload.

That's why I do not use Twitter as a communication tool. I don't bother reading the Twitter feed as it's usually emotionally dangerous. But I have recently created a collection of Twitter bots to publish my recently read content and my recently written blog posts.

The bots use AWS Lambda to parse my Pocket and blog RSS feeds then post to Twitter. I wrote the lambda functions in Go following [Vicky Lai's tutorial](https://vickylai.com/verbose/free-twitter-bot-aws-lambda/); the cost of running these bots -- which simply post from the feeds into Twitter and remove old tweets -- actually is free. The benefit has been learning how to configure, build, and deploy to AWS lambda. And I suppose scrawling my content into the tweet stream.
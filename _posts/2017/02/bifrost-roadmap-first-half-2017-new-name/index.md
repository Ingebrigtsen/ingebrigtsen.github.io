---
title: "Bifrost roadmap first half 2017 (new name)"
date: "2017-02-20"
categories: 
  - "bifrost"
  - "csharp"
  - "cloud"
  - "cqrs"
---

This type of post is the first of its kind, which is funnny enough seeing that [Bifrost](https://github.com/dolittle/bifrost) has been in development since late 2008. Recently development has moved forward quite a bit and I figured it was time to jot down whats cooking and what the plan is for the next six months - or perhaps longer.

First of all, its hard to commit to any real dates - so the roadmap is more a “this is the order in which we’re going to develop”, rather than a budget of time.

We’ve also set up a community standup that we do every so often - not on a fixed schedule, but rather when we feel we have something new to talk about. You can find it [here](https://www.youtube.com/channel/UCO54aeNeVzKFYVo7sVsXlAA).

# 1.1.3

One of the things we never really had the need for was to scale Bifrost out. This release is focusing on bringing this back. At the beginning of the project we had a naïve way of scaling out - basically supporting a 2 node scale out, no consideration for partitioning or actually checking if events had been processed or not. With this release we’re revisiting this whole thing and at the same time setting up for success moving forward. One of the legacies we’ve been dragging behind us is the that all events where identified by their CLR types, maintaining the different event processors was linked to this - making it fragile if one where to move things around. This is being fixed by identifying application structure rather than the CLR structure in which the event exist in. This will become convention based and configurable. With this we will enable RabbitMQ as the first supported scale out mechanism. First implementation will not include all partitioning, but enabling us to move forward and get that in place quite easily. It will also set up for a more successful way of storing events in an event store. All of this is in the middle of development right now. In addition there are minor details related to the build pipeline and automating everything. Its a sound investment getting all versioning and build details automated. This is also related to the automatic building and deployment of documentation, which is crucial for the future of the project. We’ll also get an Azure Table Storage event store in place for this release, which should be fairly straight forward.

# 1.1.4

Code quality has been set as the focus for this release. Re-enabling things like NDepend, static code analysis.

# 1.1.5

Theme of this version is to get the Web frontend sorted. Bifrost has a “legacy” ES5 implementation of all its JavaScript. In addition it is very coupled to Knockout, making it hard to use things like Angular, Aurelia or React. The purpose of this release is to decouple the things that Bifrost bring to the table; proxy generation and frontend helpers such as regions, operations and more. Also start the work of modernizing the code to ES2015 and newer by using BabelJS. Also move away from Forseti, our proprietary JavaScript test runner over to more commonly used runners.

  

# Inbetween minor releases

From this point to the next major - it is a bit fuzzy. In fact, we might prioritize to push the 2.0.0 version rather than do anything inbetween. We’ve defined a version 1.2.0 and 1.3.0 with issues we want to deal with, but might decide to move these to 2.0.0 instead. The sooner we get to 2.0.0, the better in many ways.

  

# 2.0.0

Version 2.0.0 is as indicated; breaking changes. First major breaking change; new name. The project will transition over to be called Dolittle as the GitHub organization we already have for it. Besides this, the biggest breaking change is that it will be broken up into a bunch of smaller projects - all separated and decoupled. We will try to independently version them - meaning they will take on a life of their own. Of course, this is a very different strategy than before - so it might not be a good idea and we might need to change the strategy. But for now, thats the idea and we might keep major releases in sync.

The brand Dolittle is something I’ve had since 1997 and own domains such as dolittle.com, dolittle.io and more related to it. These will be activated and be the landing page for the project.

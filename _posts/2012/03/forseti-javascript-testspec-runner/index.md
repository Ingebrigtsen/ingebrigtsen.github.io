---
title: "Forseti - JavaScript Test/Spec runner"
date: "2012-03-18"
categories: 
  - "javascript"
---

A couple of months ago, [Pavneet Singh Saund](http://pavsaund.wordpress.com/) and me decided to go down the road of creating our own test/spec runner for JavaScript. The rationale behind creating our own was basically that we had been having trouble getting existing solutions working, and the feedback loop also being higher than one should expect. Also, we felt that running all tests / specs in a through real browsers was more of integration rather than doing it every time we need to run.

Another aspect was that we had this idea of creating a better developer experience for these kind of runners. Integrate better with IDEs and also have a tool that does not sit in the terminal window. Even though all the cool kids are having their terminal windows real close, we still feel there is room for abstracting that away and create a very slick and simple UI sitting on top.

The runner we came up with is called [Forseti](http://en.wikipedia.org/wiki/Forseti), it is open sourced and can be found on GitHub [here](http://www.github.com/dolittlestudios/forseti). The first release we have out at this point is a simple console app, but we will be moving forward on it as much as we can and hopefully bring all the goodness to it that we have in mind as soon as possible.

In the meantime, we'd love your input on it, anything from getting it up and running as is now, to building it, feature requests and bugs you might find. Please let us know what you think and how you experience it!

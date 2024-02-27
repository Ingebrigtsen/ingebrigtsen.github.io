---
title: "Philosophy of Bifrost"
date: "2012-06-05"
categories: 
  - "bifrost"
---

Back in 2008 I started as a consultant after having worked at different ISVs since I started my career back in 1994. In the beginning my employer back then sent me to short contracts to get the consultant life under my skin. Moving around from client to client like that I realized something; I am rinsing and repeating a lot of mundane tasks, things I quickly realized that I really didn't want to be repeating. This is probably a realization most consultants do, but nevertheless I felt I had to do something about it; out came the idea of Bifrost, an open-source library that I would be able to reuse at clients if the client permits. 

**The philosophy  
**At the core of Bifrost and its philosophy lies an theory that although different domains have in general different needs, the abstract concepts that sits as pillars supporting a domain are the same. Bifrost would therefor be the provider of these abstractions. The abstractions should be very lightweight and focused and just support the concepts Bifrost is promoting.

The things that Bifrost aims at doing is to make things simpler, both on the backend as well as the frontend. There are so many things out there that we're repeating, Bifrost aims to either take away tasks or expose APIs that will make it a lot easier to accomplish things. I will not go into details about all the aspects of Bifrost in this post, as we're on a constant move and have incorporated quite a lot just the last 6 months. 

With that being said, you're probably already thinking; geez that must a bloated framework. No! It is not. The reason for it not being bloated in my opinion, is just because of the fact that the different APIs are really focused and are not generalized to support all scenarios out there. Bifrost is opinionated, and will remain so. It is not a one size fits all necessarily. If you want to apply it, you will have to adjust to the philosophy behind it. This does not mean we're not open for suggestions, improvements and so forth. But it means we're keeping an eye on the road and we want it not blow up.

One aspect that was really important is to follow good development practices. Creating highly flexible, maintainable code and also highly testable to achieve the best possible quality.

**The Evolution  
**Late 2010, when working for [Komplett ASA](http://www.komplett.com) we revitalized the project as a joint venture between Komplett and my own company; DoLittle Studios. Re-focusing some of the effort and changing around some of the core principles applied to it. For one we wanted it to be more focused around separation and more specifically implement and support CQRS as the preferred backend solution. We had already done an internal project using Commands to express behaviors in the system, but didn't do the entire CQRS stack at that point, but rather had the commands chained up and replayed whenever we wanted to achieve a state, leaving events out of the equation at that point. What was great about that is that we got a chance to dive into the concept, get our hands dirty without applying the entire stack; get some experience, basically.  

**CQRS**  
[Command Query Responsibility Segregation](http://en.wikipedia.org/wiki/Command-query_separation) Coined by [Greg Young](http://codebetter.com/gregyoung/) a few years back was something we saw quite a lot of benefits in applying. Although, we now see a bunch of different benefits from doing CQRS; the road leading up to CQRS and what followed, the product we ended up with forced us to learn so much. Everything became much clearer when it comes to identifying the different concerns and responsibilities in the code. The basics of CQRS states that you keep your read side optimized for that purpose only, and the execution is behavioral in nature and expresses in a verbose and explicit way what is to happen to the system, the read side will then be flattened or specialized as a consequence of whatever behavior has been applied.

Once we had it applied we started realizing the power of the concepts that we applied. We started seeing that applications are not about data, but rather have a very rich domain that expresses the behavior and that data might not even exist at all, but it might be as crazy as statically generated HTML files for our Web views, or at least statically generated JSON files we could pull directly from a CDN into our JavaScript code. It basically provided us with the scalability, flexibility and fueled us as developer with a set of mindsets that are really powerful.

**MVVM**  
Back when I originally started the project, I always kept a very open eye on bridging the gap between the backend and the frontend. A pattern I've been loving for a few years now is [Model View ViewModel](http://en.wikipedia.org/wiki/MVVM). Modern Web applications are doing more and more on the client using JavaScript. Combine that with the growing popularity of single page web applications, MVVM seems to be a perfect fit. Bifrost has been built on top of [Knockout JS](http://knockoutjs.com), extending and formalizing a few things. 

**Much much more..**  
There is quite a few more things related to Bifrost. But I'm not going to take on the task of going through it all in this post. But on the official [site](http://bifrost.dolittle.com). The site is really a work in progress some of the elements of Bifrost are documented, but for the most part not at this moment in time. Stay tuned and we'll get more of documentation up and running. We're also focusing on an API documentation that goes into detail.

**Our conclusion**

Although we jump-started the framework again and wanted to focus on the CQRS parts, we quickly realized that Bifrost was not just a CQRS library, it was something else. Its place in life is to facilitate any line-of-business application development. We see great opportunities to simplify a lot of the everyday developers life and is also something we would love to hear from you about. Don't hesitate to engage in a conversation with us at our [GitHub site](http://github.com/dolittlestudios/bifrost) or our [Google Forum](https://groups.google.com/group/bifrostproject).

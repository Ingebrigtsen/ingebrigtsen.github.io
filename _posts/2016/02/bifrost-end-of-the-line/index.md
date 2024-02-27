---
title: "Bifrost - end of the line"
date: "2016-02-11"
categories: 
  - "bifrost"
---

Prior to 2008 I had only worked at ISVs (Independent Software Vendors) and game companies going back to 1994. At this point I decided I needed to get a change of scenery and become a consultant - try something completely different. In the beginning, since I had no experience with being a consultant - my boss and me figured it would be best to have a few small projects to get the gist of things. After a couple of these small projects I started feeling some pain; I was rince-repeating a lot of the things. I’m not entirely sure how other consultants do things, but I decided it was time to gather the things that I was constantly doing into an open-source library; a collection of tools that would speed up the process when onboarding into projects. From this [Bifrost](http://github.com/dolittle/bifrost) was born.

It grew from over a couple of years and at the time had no true vision other than make my everyday easier. Back in 2009 I got hired as a consultant @ the largest eCommerce in Norway; [Komplett](http://www.komplett.no). At Komplett I was tasked at first with working on some integration and establishing a new object model, or as we liked to call it back then; a domain model. It was pretty much an anemic domain model, something representing the data in C#. An approach I had done a number of times over the course of my career at this point. In the middle of this work, someone had discovered a missing feature in the system which was a critical feature for a company being merged into the Komplett group. I was asked to head development of this feature and I could bring 2 more devs. We decided to make this a learning experience in addition to concretely implement the feature. In the learning we wanted to pick up on new ways of thinking and also some new tech, amongst it ASP.NET MVC. The team ended up being Michael Smith, Pavneet Singh Saund and myself, plus a dedicated product owner. We did quite a few discoveries in this project and by far the most important being the discovery of commands. We also discovered how domain models as we knew at this point in time didn’t really work. Worth mentioning is also how we started seeing patterns of how we should not do things. This lead to larger project, a rewrite of the core web. Midway through this, I gave a talk @ NDC 2011 about our experience with applying CQRS, which was the conclusion we were closing in on. From this I was contacted by a representative of Statoil a few months later. They found the topic interesting and also the platform; Bifrost (yes we got pretentious and dropped the library and framework label and called it a platform - it kinda grew :) ). We were onboarded in the beginning of 2012, and I mean we - Michael joined and later also Pavneet. Kept the team together, all as individual independent consultants. This was a huge part of our progress in learning; the team. We knew each other well, had concrete focus areas and managed to move and learn fast.

At this stage we found ourselves in a position of having gone through a sort of knowledge transition. To me it felt like I had gone back quite a few years from 2008 and created a fork in my knowledge bank. It felt at times like this fork was diverging more and more from what was commonly being done on projects around us. Not claiming that our fork was better or anything, but made more sense to us - with our history together and our shift in mindset that we decided to do. From my experience, comparing before and after - I conclude with we managed to write better and more predictable software. But it came with a certain amount of friction. The stuff we were talking about was not as Google-friendly. Less resources to refer to, which is a very important aspect when you have for instance a team of 20+ developers that you’re trying to convince that your thing is better; not to be underestimated at all! Something we were quite aware of and made us a bit hesitant to push through, but had confidence from key persons on the projects we were on to push forward. The huge disadvantage I’m seeing today of having pushed on in this fork and having to spend a lot of time maintaining and convincing others, left us blind to what was going on outside and we became an echo-chamber for a lot of things, not realizing that some of the concepts we had discovered and if I dare; maybe even pioneered (without letting anyone know) has surfaced in elsewhere and are now becoming part of how we all do things. Which is just truly great.

 

## The future

 

Its now been 7-8 years since the project was started, where is it today. Well, it still exists, sits on GitHub. Thus far the project has moved forward because of the maintainers needing it to. We were using it for the projects we were on. This has also been the key reason why we’ve implemented things; if it had a real world scenario - we could identify it and develop it. We’ve always kept a close eye on the real world, not making anything for its own purpose - but fill a need. Fast forwarding to today, February 2016, our team is no longer a team and skattered in different companies. We are no longer working together, and none of us really using Bifrost for our day to day work - this represents a problem for moving things forward, given the history of how things have moved. Take me for instance, I’m no longer actively working on a real world project - although I’m working on changing that somewhat. To keep my knowledge fresh in the type of role I have now, I’m dedicating time to build a project I’ve been thinking of for a couple of years and something I need myself. But it turns out, this is not enough of a reason for me. I have decided to go a slightly different route to build relevant knowledge to what I do.

One of the goals of Bifrost was to tackle things we believed would provide better quality software, one of them being to decouple and not build monoliths. Today, I see Bifrost as a bit of a monolith. There are too many things inside the core framework. It should have been broken up. On top of this there also are some logical couplings we never intended. There are also things I’d like to do differently in how its been architected, and basically learn from mistakes and correct them. Worth mentioning is also complexity that was put in there for imaginary problems that turned out to not be anything that would happen any time soon. For those using Bifrost, it would be too much work moving forward with the amount of refactoring that I’m looking for, plus too much work for me or anyone else maintaining it all. Although difficult, I see no other way around it but to just admit that I will not be able to set aside time to do this properly and therefor I will not continue the maintenance of it, nor maintain any pull requests at this point. When I can’t guarantee a feedback loop, it only looks bad in the repository. I’m truly proud of what we have accomplished with the project. It is by far the cleanest code I’ve ever written, adhering to the principles that I believe in. With more than 2000 automated specifications (BDD style), it has proven to be easy to refactor and as far as we know; very stable code - thoroughly tested. There are of course things I’d love to have done differently. Blogging more actively about the things we did in Bifrost, creating awareness - because as I said, I’m truly proud of what we have done. Actively maintaining documentation is a second thing - making it easier to figure out what things do. We did put in XML documentation into all C# code, but never really did anything proper with it. I’d also do WebCasts to cover topics, create tutorials and more. Who knows, maybe Bifrost could have been a business on its own. The luxury of looking back :).

 

## Harvesting

The last couple of months has been a retrospective going on inside my head with the purpose of figuring out what I think was good and not. In combination with this, Pavneet, Michael and myself has had a few discussions between ourselves about the same topic. Gaining the distance from everyday maintenance and implementation has really helped and has made things a lot clearer.

From this I want to start harvesting from the experience. Primarily I want to harvest in the term of learning, take the knowledge and bring it forward - modernize it - keep it fresh. Then I have a hope, not willing to call it a goal yet, to turn this knowledge into something more concrete. I’m not entirely sure what this concrete thing is yet. If it appears in the wild in terms of an open-source project representing this or not, I’m not sure. I’d love to, but only if I find it viable.

What I do concretely want to do is to start braindumping some of the things we learned, the things we really enjoyed and we found useful. The braindumping will be in the form of posts here.

Below is a list of topics from the top of my head that I see as key points for the kind of harvesting I’m talking about. I have no idea what format things will take and what will end up where, so lets see.

 

1. Core Principles - SOLID, SOC, DRY
2. Productivity and true meaning
3. Discovery mechanisms and Conventions
4. Cross cutting concerns
5. Domain Models
6. Commands
7. Events + EventSourcing
8. Domain Driven Design
9. Eventual Consistency
10. Low Coupling, High Cohesion
11. The importance of the clientside
12. Validation != Business rules
13. Operations
14. MVVM - the building blocks
15. Regions in the client
16. Coding style
17. BDD - Specifications by example style of testing
18. Feedback loop
19. Declarative
20. Compositional software
21. How inheritance creates coupled software
22. Don’t be afraid of duplication in data - persistence polyglotism
23. Bounded Contexts and their relationship to MicroServices

 

 

# Conclusion

Being realistic can sometimes be hard. I must admit I have not been honest with myself nor with others. Its hard when its your own brainchild to let go, but the place I am in my life right now has little room for maintaining a project the size of Bifrost. I have a job that is different and demanding in its own way, I have 2 kids thats growing up and I must prioritize being there more for them before its too late! I have neglegted hobbies that I’m trying to get in touch with; my IOT devices, writing more blogposts, attending user groups. I have a house that I want to do some work on and tons of tools to do it with that’s screaming for my attention. I’m also active in the school, in something similar to PTA here in Norway. The only correct and honest thing to do is to tell everyone; I’m not going to maintain Bifrost anymore - nor maintain pull requests. Thanks to everyone that believed in the project, the guys maintaining it and fellow journeymen; Michael, Pavneet. A big shoutout and thanks to Børge Nordli who is on a project using Bifrost and has the last year contributed quite a bit back.

PS: Project will still sit on GitHub

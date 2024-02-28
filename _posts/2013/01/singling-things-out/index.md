---
title: "Singling things out..."
date: "2013-01-20"
categories: 
  - "code-quality"
  - "cqrs"
tags: 
  - "agile"
---

I was at a client a while back and was given the task to asses their code and architecture and provide a report of whatever findings I had. The first thing that jumped out was that things did more than one thing, the second thing being things concerning itself with things it should not concern itself about. When reading my report, the client recognised what it said and wanted me to join in and show how to rectify things; in good spirit I said:

![NewImage](images/makeitso1.png "MakeItSo.png")

We approached one specific class and I remember breaking it down into what its responsibilities were and fleshed it all out into multiple classes with good naming telling exactly what it was supposed to do. When we were done after a couple of hours, the developer I sat with was very surprised and said something to the effect of; ".. so, single responsibility really means only one thing..". Yes, it actually does. A class / type should have the responsibility for doing only one thing, likewise a method within that class should only do one thing. Then you might be asking; does that mean classes with only one methods in them. No, it means that the class should have one subject at a time and each and every method should only do work related to that subject and every method should just have the responsibility of solving one problem. Still, you might be wondering how to identify this.

Lets start with a simple example.

Say you have a system were you have Employees and each and every one of these have a WorkPosition related to it enabling a person to have different positions with the same employer (Yes, it is a real business case. :) ).

The employee could be something like this :

```csharp public class Employee { public int Id { get; set; } public string FirstName { get; set; } public string LastName { get; set; } } ```

A fairly simple class representing an [aggregate root](http://en.wikipedia.org/wiki/Domain-driven_design).

Then go and add this other thing in our domain; a WorkPosition, a value type that refers to the aggregate:

```csharp public class WorkPosition { public int Id { get; set; } public int EmployeeId { get; set; } public double PositionSize { get; set; } } ```

One could argue these represent entities that you might want to get from a database and you might want to call them entities and DRY up your code, since they both have an Id:

```csharp public class Entity { public int Id { get; set; } }

public class Employee : Entity { public string FirstName { get; set; } public string LastName { get; set; } }

public class WorkPosition : Entity { pubic int EmployeeId { get; set; } public double PositionSize { get; set; } } ```

Nice, now we've dried it all up and the Id **property** can be **reused**.

The Id property is a classic pattern, but in [domain driven design](http://en.wikipedia.org/wiki/Domain-driven_design) you would probably not use an integer as Id but rather a natural key that describes the aggregate better. For an Employee this could be the persons social security number. This means that an integer won't do, but something that can tackle the needs of a social security number. For simplicity in this post, I'll stick to primitives and do a string, normally I would introduce a domain concept for this; a type representing the concept instead of using generic primitives - more on that in another post.

We want to introduce this, but we'd love to keep the Entity base class, so we can stick common things into it, things like auditing maybe. But now we are changing the type of what identifies an Employee, and it's not the same as for a WorkPosition; C# generics to the rescue:

```csharp public class Entity<T> { public T Id { get; set; } public DateTime ModifiedAt { get; set; } public string ModifiedBy { get; set; } }

public class Employee : Entity<string> { public string FirstName { get; set; } public string LastName { get; set; } }

public class WorkPosition : Entity { public string EmployeeId { get; set; } public double PositionSize { get; set; } } ```

Great, now we have a generic approach to it and get auditing all in one go.

![NewImage](images/houston1.png "Houston.png")

We've just created a nightmare waiting to happen. We've made something generic, lost a lot from the domain already just to save typing in one property; Id (yeah I know, there are some auditing there - I'll get back to that soon). We've lost completely what the intent of the Employees identification really is, which was a social security number. At least the name of the property should reflect that; Id doesn't say anything about what kind of identification it is. A better solution would be going back to the original code and just make it a little bit more explicit:

```csharp public class Employee { public string SocialSecurityNumber { get; set; } public string FirstName { get; set; } public string LastName { get; set; } }

public class WorkPosition { public int Id { get; set; } public string SocialSecurityNumber { get; set; } public double PositionSize { get; set; } } ```

That made it a lot more readable, we can see what is expected, and in fact we've also decoupled Employee and WorkPosition in one go - they weren't coupled directly before, but the property named EmployeeId made a logical coupling between the two - which we might not need.

Another aspect of this would be bounded contexts; different representations of domain entities depending on the context they are in. In many cases an entity would even have different things that identifies it, depending on the context you're in. Then Id would be a really bad name of a property and also having a generic representation of it would just make the whole thing so hard to read and understand. Normally what you would have is an underlying identifier that is shared amongst them, but you wouldn't necessarily expose it in the different bounded contexts. Instead you would introduce a context map that would map from the concepts in the different bounded context to the underlying one.

Back to auditing - don't we want to have that? Sure. But let's think about that for a second. Auditing sounds like something you'd love to have for anything in a system, or in a particular bounded context, one could argue its cross cutting. It is a concern of every entity, but I would argue it is probably not something you need to show all over the place; in fact I'll put forward the statement that auditing probably is an edge case when showing the entities on any dialog. So that means we probably don't need them on the entities themselves, but rather make sure that we just get that information updated correctly in the database; this could be something we could do directly in the database as triggers or similar, or make sure everything goes through a well-defined common data context that can append this information. Then, for the edge cases were you need the auditing information, model only that and an auditing service of some kind that can get that information for the entities you need.

# Fess up

Ok. So I have sinned, I've broken the [Single Responsibility Principle](http://en.wikipedia.org/wiki/Single_responsibility_principle) myself many times, and I will guarantee you that I will break it in the future as well. In fact, let me show you code I wrote that I came across in [Bifrost](http://github.com/dolittle/bifrost) a few weeks back that got the hairs on my back rising, a system called [EventStore](https://github.com/dolittle/Bifrost/blob/d70844e94ee441ed7c6e72975f3117f4b559a06f/Source/Bifrost/Events/EventStore.cs):

```csharp public class EventStore : IEventStore { public EventStore(IEventRepository eventRepository, IEventStoreChangeManager eventStoreChangeManager, IEventSubscriptionManager eventSubscriptionManager, ILocalizer localizer) { // Non vital code for this sample... }

public void Save(UncommittedEventStream eventsToSave) { using(\_localizer.BeginScope()) { \_repository.Insert(eventsToSave); \_eventSubscriptionManager.Process(eventsToSave); \_eventStoreChangeManager.NotifyChanges(this, eventsToSave); } } } ```

I've stripped away some parts that aren't vital for this post, but the original class some 60 lines. But looking at the little code above tells me a couple of things:

- Its doing more than one thing without having a name reflecting it should do that
- The EventStore sounds like something that holds events, similar to a repository - but it deals with other things as well, so…
- The API is wrong; it takes something that is uncommitted and it saves it - normally you'd expect a system to take something uncommitted and commit it

The solution to this particular problem was very simple. EventStore needed to do just what it promises to do in its name, all the other stuff is coordination and by the looks of it, it is coordinating streams of uncommitted events. So I introduced just that; UncommittedEventStreamCoordinator with a method of Commit() on it. Its job is then to coordinate the stuff we see above and the EventStore can then take on the real responsibility of dealing with storing things, and in fact I realised that the EventRepository could go at this point because I had tried to solve it all in a generic manner and realised that specialised EventStores for the different databases / storage types we support would be a lot better and not a lot of work to actually do.

Another thing the refactoring did for us was the ability to now turn of saving of events, but still get things published. By binding the IEventStore that we have to an implementation called NullEventStore - we don't have to change any code, but it won't save. Also what we also can do is to introduce the ability the EventStore itself to by asynchronous, we can then create something like AsyncEventStore that just chains back to the original EventStore, but does so asynchronously. All in all it adds more flexibility and readability.

# Behaviors to the rescue

All good you might think, but how do you really figure out when to separate things out. I'll be the first to admit, it can be hard sometimes, and also one of them things one can't just be asked and necessarily be able to identify it within a heartbeat - sometimes it is a process getting to the result. But I would argue that thinking in behaviors makes it simpler, just for the simple fact that you can't do two behaviors at the same time. Thinking from a testing perspective and going for BDD style testing with a [gherkin](https://github.com/cucumber/cucumber/wiki/Given-When-Then) (given, when, then) also gives this away more clearly; the second you write a specification that has _and_ in it, you're doing two things.

# Why care?

Took a while getting to the why part. It is important to have the right motivation for wanting to do this. [Single Responsibility Principle](http://en.wikipedia.org/wiki/Single_responsibility_principle) and [Seperation of Concerns](http://en.wikipedia.org/wiki/Separation_of_concerns) are principles that have saved me time and time again. It has helped me decouple my code and get my applications cleaner. Responsibility separated out gives you a great opportunity to get to Lego pieces that you can stitch together and really get to a better [DRY model](http://blog.dolittle.com/2012/08/13/dry-going-the-whole-way/). It also makes testing easier, testing interaction between systems and more focused and simpler tests. Also, separating out the responsibility produces in my opinion simpler code in the systems as well, simpler means easier to read. Sure, it leaves a trail of more files / types, but applying proper naming and good structure, it should be a problem - rather a bonus. It is very different from procedural code, you can't read a system start to finish - but I would argue you probably don't want to that, it is in my opinion practically impossible to keep an entire system these days in your head. Instead one should practice focusing on smaller bits, make them specialised; great at doing one thing. Its so much better being great at one thing than do a half good job at many things.

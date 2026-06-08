---
title: "The Cratis Philosophy: Simplicity Through Layers"
date: "2026-06-08"
categories: 
  - "net"
  - "architecture"
  - "cratis"
tags: 
  - "c#"
  - "event sourcing"
  - "ddd"
  - "philosophy"
---

## Come for the simplicity, stay for the capabilities

That's the tagline I've settled on for Cratis. But to understand why, we need to go back to where this all started.

## The burden of helping other developers

Back in 1994, I started in games development, working mostly on the 2D/3D engine and tooling side of things. That's where I found my love and lot in life: creating things that help other developers. It's a problem space that's incredibly interesting to me, but it also comes with a heavy burden on your shoulders — you're carrying the problems of others. If my stuff didn't work, nothing worked and we would destroy productivity for all the developers building the games.

This is where I started falling in love with structure, patterns, practices, and automated testing to prevent regressions. It had to work. Every time. For everyone.

## The SQL problem

In 2001 I started doing line of business software and never became friends with SQL. After having spent a few years building software with crude actor models and messaging/events, the whole relational model felt wrong and not optimal. But it took almost another decade before I started seeing the light: event sourcing.

We introduced Bifrost, our first attempt at an application framework geared towards CQRS and Event Sourcing. We had success getting people on board with CQRS and some of the concepts we introduced, but event sourcing was hard for people. For all my own projects I continued thinking this way, but stopped at one point preaching it in the context of Bifrost.

## The startup years

In late 2017 we got the opportunity to do a startup around these concepts. Basically for me, going back to doing what I love: empowering other devs.

We kept at it for 4-5 years. But struggled with adoption. I left the company in 2022, mostly because I was burned out and things were shifting away from my vision of what this could be.

But I never gave up.

## The reboot

Back in 2015/16 I started a parallel track called Cratis. I wanted to modernize some of the thoughts. And refocus. In late 2022 I brushed the dust off this project after having a couple of epiphanies.

We knew already in late 2019 that the reason we were struggling with adoption was the focus we had on bringing Domain Driven Design to life with its building blocks.

Not only were things like AggregateRoot foreign concepts for a lot of people, but in the context of Event Sourcing, it becomes even more foreign — having to build its state from events.

## Starting from scratch

When I rebooted Cratis, I wanted to do things a different way. I wanted to drop all the baggage and see how event sourcing would be without all this. I quite deliberately started from scratch in thinking. Cleared my head for all previous ideas and notions. Deliberately didn't look at how others were doing things or talking about it.

This is where I started establishing the core philosophy:

- **It should be super simple doing event sourcing**
- **It should be possible for people with experience in event sourcing to be able to do exactly what they want**
- **Cater to higher level abstractions**
- **Focus on making the things you do the most, easy — build this first!**
- **Stay idiomatic and close to familiarity**
- **Create the tools that are expected for a full event sourced ecosystem**

## Building in layers: The projection story

With this philosophy in place, we build things in a particular way. Take projections as an example.

I was convinced that doing a declarative projection engine where one described how to map from events to a read model was the first thing we needed. This would cover the 90% or more of data-centric scenarios.

I built it to handle very complex tasks like joining disparate streams with joins or children. And it should be able to do things out-of-order.

### Layer 1: The engine

The first implementation was the engine itself. It had an object model representing how the projection definition looked like.

### Layer 2: Fluent interface

From this I built a fluent interface that looked better and could configure the projection. Now it felt like something you'd see in FluentValidation or Fluent mappings in ORMs.

### Layer 3: Attributes

But we didn't stop there. Fluent interfaces are awkward at times and not always the simplest. So we decided to add what we call a model-bound approach: attributes.

This lowered the threshold significantly.

### Layer 4: The visual tool

But we had the last piece of the puzzle left. We knew from experience that tooling was a make or break for adoption. And we decided from the start to make a web-based tool for seeing what's going on and being able to browse the event sourcing server. We called it Workbench. This is your vanilla average UI tool, just to be of assistance.

In it, we wanted to be able to query the events to both be able to see how to shape read models, but also just for ad hoc queries.

In November 2025 we started formalizing a query language that could do this. Sitting on top of the projection engine, it reads and writes very similar to the declarative approach, only cleaner since there are no disturbing C# artifacts.

## The itch

In February I got an itch. I normally use Event Modeling in projects, but always found generic tools like Miro very tedious to use. I started dabbling with the idea of creating a focused tool. But I wanted more than just drawing capabilities. I wanted something for rapid prototyping that was more deterministic than using AI.

With the rich Arc application model, we have set ourselves up for success with vertical slices and focused on Event Modeling. We could then do a sort of "low code" tool. Only difference being that we could deterministically generate the code.

### Layer 5: Cratis Studio

Meet the fifth level of abstraction: the visual tool for defining a projection. Combining with visual editors for commands, events, and read models and a few other building blocks and a simple editor for creating UIs, you can create the MVP of a product live and be ready in minutes into a workshop.

## Subjective simplicity

This summarizes how we think: **simple means simple in use — and that is subjective.**

A person with years of experience in event sourcing has other expectations than one without the experience. An expert might want to use the raw engine APIs for full control. Someone comfortable with C# might prefer the fluent interface. A developer new to event sourcing might find attributes the easiest entry point. And someone in a workshop, trying to rapidly prototype an idea, might want the visual tool.

We don't force you to choose just one. We let you pick the level of abstraction that fits your skill level, your context, and your needs. That's what makes it simple for you.

By bringing it to the workshop level with Cratis Studio, where people have all different skills, we lower the barrier even more.

## The philosophy in practice

This layered approach applies across Cratis:

- **Constraints**: Define them in code, or let the system infer them
- **Concurrency scopes**: Use raw APIs for precise control, or declare intent with attributes
- **Read models**: Wire them manually, or let Arc inject them automatically
- **Commands**: Full control with handlers, or simplified with record-based commands

Every layer sits on top of a solid foundation. You can drop down when you need more control. You can stay high-level when you don't.

## Why this matters

Most frameworks pick a level of abstraction and force everyone to live there. Too low-level and beginners struggle. Too high-level and experts hit walls.

We refused to make that choice. Instead, we built multiple layers, each one adding convenience without removing capability.

This is harder to build. Much harder. But it's the only way to serve both the developer learning event sourcing for the first time and the expert who's been doing this for a decade.

## Come for the simplicity, stay for the capabilities

When you first encounter Cratis, you might start with attributes or the visual tool. It feels simple. It works. You ship something.

Later, you hit a case that needs more control. You discover the fluent API or the engine itself. You realize the simple thing you were using was sitting on top of a powerful foundation the whole time.

You didn't have to rewrite. You didn't hit a wall. You just went one layer deeper.

That's the philosophy. That's what we're building.

Simple for those who need simple. Powerful for those who need power. And a smooth path from one to the other.

## What's next

We're not done. The philosophy guides every decision:

- Should this be easier to use?
- Are we forcing a specific level of abstraction?
- Can an expert still do what they need?
- Does the tool feel familiar to people coming from other ecosystems?

These questions shape everything from API design to documentation to tooling.

If you want to see this philosophy in action, check out [Cratis](https://cratis.io). Start at whatever level makes sense for you. Drop down when you need to. Rise up when you don't.

That's the whole point.

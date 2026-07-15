# Talk Abstract — Build Stuff 2026

**Conference:** Build Stuff 2026, Vilnius, Lithuania — December 2–4, 2026
**Submission URL:** https://buildstuff.events

---

## Title

**Your system is a timeline. Start treating it like one.**

---

## Elevator Pitch (300 characters)

Most software forgets its own history the moment it writes to a database. Event Sourcing fixes that — but the real unlock is combining it with Event Modeling to align design and code before a single line is written. This talk shows you what that looks like end to end.

---

## Abstract

Every system has a story. A thing happened. Then another thing happened. Then a user reacted. Then the system responded. It's a timeline — but most architectures throw that timeline away the moment they overwrite a row in a database.

Event Sourcing is the idea that you stop throwing it away. You record what happened, immutably, in order. Your state becomes a consequence of your history, not a replacement for it. You get time travel. You get a full audit log. You get the ability to build an entirely new view of your data from events that already exist.

But here's the part most teams miss: Event Sourcing doesn't automatically make your system understandable. The gap between business intent and technical implementation is still there — and it's still expensive.

That's where Event Modeling comes in.

Event Modeling gives your entire team — developers, domain experts, product owners — a shared visual language to describe how a system behaves before anyone writes a line of code. It uses exactly three building blocks: commands, events, and read models. It uses exactly four patterns. That's it. You can explain the whole approach in ten minutes. The rest you learn by building.

In this talk, I'll walk through what it actually looks like to go from a domain brainstorm to a running, event-sourced application — using Cratis, an open-source event sourcing platform for .NET, and Cratis Studio, a collaborative modeling tool that takes your event model and generates type-safe C# commands, events, and projections directly from your design.

Design and code that tell the same story. No translation loss. No "it made sense in the meeting" moments two sprints later.

You'll see:

- How Event Modeling forces clarity about what your system actually does
- Why Event Sourcing is the natural implementation layer for a model-first approach
- How code generation from a shared model eliminates the drift between design and reality
- What time-travel debugging and projection replay look like in practice

This isn't a theoretical talk. We'll go from blank canvas to working software — live.

---

## 300-Word Abstract

Most software throws away its own history. Every time you update a row in a database, the previous state vanishes. You know where you are, you have no idea how you got there. That matters more than most teams realise, until it really, really matters.

Event Sourcing changes the fundamental premise: instead of storing current state, you store what happened. Every change is recorded as an immutable event. State becomes a projection of history, not a replacement for it. You get a full audit trail, time-travel debugging, and the ability to build entirely new views of your data without touching the original events.

But Event Sourcing alone doesn't solve the hardest problem in software: making sure everyone on the team; developers, domain experts, product owners is actually building the same thing.

That's the job of Event Modeling. Using just three building blocks (commands, events, and read models) and four patterns, Event Modeling lets teams design an entire system on a shared visual timeline before a single line of code is written. It's not a diagram that lives in Confluence and rots. It's a living model the whole team can read, challenge, and evolve together.

The real breakthrough is when design and implementation stop being separate phases. 

In this session, we go from blank canvas to running software — live. No slides pretending this works. Just the thing itself, working.

---

## Key Takeaways

- A practical mental model for Event Sourcing that makes the "why" obvious, not just the "how"
- How Event Modeling replaces endless specification documents with something everyone can actually read
- A workflow where your design and your codebase stay permanently in sync
- Concrete tooling (Cratis + Cratis Studio) you can use on Monday morning

---

## Format

45-minute session with live demo.

---

## Target Audience

Intermediate to senior developers, architects, and tech leads interested in domain modeling, system design, and building software that's maintainable long after the original team has moved on.

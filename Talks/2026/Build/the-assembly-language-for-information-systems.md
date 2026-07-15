# Talk Abstract — Build Stuff 2026

**Conference:** Build Stuff 2026, Vilnius, Lithuania — December 2–4, 2026
**Submission URL:** https://buildstuff.events

---

## Title

**The assembly language for information systems**

---

## Elevator Pitch (300 characters)

We stopped programming hardware. We stopped racking servers. We stopped babysitting containers. Yet we still hand-craft every application. Screenplay is a new abstraction: describe business outcomes as an event model, and an engine turns it into a running system. Built for an AI world.

---

## Abstract

Every big leap in software has been about letting go of a layer we used to worry about. Operating systems freed us from the hardware. Virtualization freed us from the physical machine. Containers freed us from the environment, and orchestration freed us from the machines entirely.

Hardware → Operating System → Virtualization → Containerization → Orchestration → ?

And yet, at the very top of that ladder, we still hand-craft applications the same way we did decades ago. Controllers, repositories, mappers, wiring, plumbing. The business outcome we're actually trying to achieve is buried in there somewhere, spread across a hundred files. Ask anyone on the team what the system does, and they'll point you to a wiki page that stopped being true two sprints ago.

The thing is, we're now entering a world where AI writes more and more of our code. That changes the question. It's no longer "how fast can we type", it's "how precisely can we describe what we want". What we're missing is a target to compile to. An assembly language for information systems.

That's what Screenplay is. A new abstraction level, the Application Model, that sits on top of the ladder we've been climbing for fifty years. Screenplay is built on Event Modeling and describes systems as vertical slices: commands, events, read models, and the flows that connect them. You describe the business outcomes. An engine turns that description into a running, event-sourced solution. No infrastructure decisions, no plumbing, no drift between the design and what's actually running.

In this talk I'll make the case for why this abstraction is inevitable, show you what Screenplay looks like, and go from a business-level description to a running system. Live, no slides pretending it works. Just the thing itself, working.

You'll see:

- Why the next rung on the abstraction ladder is the application itself, not more infrastructure
- How Event Modeling's building blocks (commands, events, read models) become an executable language
- What it means to describe outcomes instead of implementations, and let an engine do the rest
- Why AI makes a precise, verifiable application model more valuable than the code it generates

---

## 300-Word Abstract

Look at the history of our industry and you'll see the same move repeated: we take a layer everyone worries about and make it something nobody has to think about. Operating systems did it to hardware. Virtualization did it to physical machines. Containers did it to environments, and orchestration did it to fleets of machines.

But the application itself? Still hand-made. We describe business intent in meetings, translate it into tickets, translate those into code, and lose a little truth at every step. The system that ends up in production is a lossy copy of what the business asked for, and nobody can say exactly where the differences crept in.

Now AI is writing more and more of that code, and it inherits the same problem. Generating thousands of lines of plumbing faster doesn't make the plumbing more correct. What's missing is a higher-level target to compile to: a precise, verifiable description of what the system should do. An assembly language for information systems.

This talk introduces Screenplay, a language for exactly that. It's built on Event Modeling and describes systems as vertical slices using commands, events, and read models. You describe the business outcomes. An engine turns the description into a running, event-sourced solution, and you never think about the infrastructure underneath. The design isn't documentation that rots, it's the system itself.

Think of it as the next rung on the ladder: hardware, operating system, virtualization, containerization, orchestration, and now the Application Model.

We'll go from a business-level description to running software, live. No mock-ups, no "imagine this works". Just the thing itself, working.

---

## Key Takeaways

- A mental model for why the next abstraction layer in software is the application model, not more infrastructure
- How Event Modeling's three building blocks become an executable language for vertical sliced, event-sourced systems
- What changes when you describe business outcomes and let an engine handle everything below
- Why AI-driven development needs a precise, verifiable abstraction to compile to, and what that unlocks

---

## Format

45-minute session with live demo.

---

## Target Audience

Developers, architects, and tech leads thinking about where application development is heading: domain modeling, event sourcing, and how AI changes what we should be building by hand.

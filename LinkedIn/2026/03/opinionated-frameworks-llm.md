---
date: "2026-03-20"
title: "Convention-driven development: from Rails to event modeling — and why it makes LLMs exceptional co-pilots"
tags:
  - ruby on rails
  - event modeling
  - cratis
  - llm
  - architecture
  - developer experience
published: false
---

Ruby on Rails was controversial when it landed. The opinionated framework. Convention over configuration. You didn't decide where your models lived, what your routes looked like, or how your database schema evolved — Rails decided. And a lot of developers hated that.

They were wrong.

What Rails actually gave you was a **shared mental model**. Any Rails developer could walk into any Rails project and know where things were, how things connected, what to look for. The conventions weren't limitations — they were a recipe. A clear "this is how you build the next thing" that let you focus entirely on the *what* rather than the *how*.

That recipe-driven approach matters enormously — not just for onboarding, but for a reason Rails never had to think about: **working with LLMs**.

---

We've been building Cratis with a very similar philosophy. Chronicle, our event sourcing database, and our Application Model — an opinionated CQRS layer on top of ASP.NET Core — are deliberately recipe-driven. There's a right way to define a command, a right place for a read model, a clear shape for how events flow through the system. If you're doing it the Cratis way, every piece looks like every other piece.

The correlation to **event modeling** is perfect. Event modeling gives you exactly the same thing at the design level — a visual recipe, slice by slice, aligning business intent with technical structure. Each slice is self-contained: an event, a command, a reaction, a read model. Pick up any slice and you know exactly what it does, what it touches, and how it fits.

The key word: **isolation**.

---

Here's why this matters so much right now.

LLMs are extraordinary at solving focused, well-scoped problems. They struggle, just like human developers, when they have to hold an entire system in their head at once. When the context is broad, the output gets generic. When the context is focused, the output is precise.

A recipe-driven, event-modeled codebase built with Cratis gives LLMs exactly what they need: **a narrow, well-defined slice of work with clear conventions on what a correct solution looks like**. Ask an LLM to implement a command handler following the pattern? It nails it. Ask it to add a read model projection? The conventions tell it exactly what shape the code should take.

You're not giving it the whole system. You're giving it one card on the event model. One slice. That's all it needs.

---

If you want to see what this looks like end to end, we have full guides that walk you through building with Cratis from scratch, following the conventions, slice by slice.

https://www.cratis.io/docs/Guides/index.html

We also have a dedicated repository of Cratis-specific AI instructions and skills (https://github.com/cratis/ai) you can pull straight into your tooling. Give your LLM the context it needs to work *with* Cratis, not just *around* it.

The recipe always mattered. Now it matters more than ever.

#Cratis #EventSourcing #EventModeling #AI #LLM #CQRS

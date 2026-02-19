---
title: "Cratis Major Releases"
date: "2026-02-19"
categories: 
  - "net"
  - "cratis"
  - "chronicle"
tags: 
  - "c#"
  - "react"
  - "event sourcing"
---

I'm excited to announce two major releases in the Cratis ecosystem: **Chronicle v15.0.0** and **Arc v19.0.0**. While these releases went out the door a few weeks ago, we've been too busy shipping features and improvements to properly announce them - until now!
These releases represent a significant milestone in our journey to provide a robust, developer-friendly event sourcing and CQRS platform for .NET.

## Chronicle v15.0.0 - A Major Evolution

[Chronicle v15.0.0](https://github.com/Cratis/Chronicle/releases/tag/v15.0.0) is our biggest release yet, featuring breaking changes that move responsibilities to where they belong, creating a more consistent and maintainable developer experience. This release also lays the groundwork for exciting new capabilities on the horizon.

### Unified Read Model Experience

One of the most significant improvements is the **unified read model API**. We've streamlined the way you work with read models by introducing a single API that automatically delegates to either reducers or projections. This means:

- A consistent `.Watch()` API across all read models for real-time updates
- Unified instance retrieval through `IReadModels` for both projections and reducers
- Support for passive reducers that don't materialize but are available for instant instances or snapshots
- Direct creation and editing of read models from the Workbench UI

This unification eliminates the confusion of working with different APIs for similar concepts and makes your code cleaner and more intuitive.

### Enterprise-Ready Security

Security takes center stage with **full TLS support** for the Kernel. TLS is now enabled by default for both development and production environments, with explicit configuration required when running in production. This gives you the flexibility to disable it if needed while ensuring secure-by-default behavior.

### Performance & Scalability Enhancements

We've made substantial improvements to performance and resource management:

- **Bulk write mode** for replay and catch-up operations, reducing database round trips and significantly improving performance during large-scale operations
- **Job throttling** to prevent CPU exhaustion with configurable, sensible defaults
- **Transactional `AppendMany()`** that ensures all-or-nothing semantics when appending multiple events, with automatic retry on sequence number conflicts

### Developer Experience Improvements

The developer experience has been enhanced in several ways:

- **Static code analysis and code fixes** integrated into the .NET client, helping you catch issues at compile time
- **Webhook-based observers** allowing arbitrary webhook endpoints to receive events
- **Consistent tagging system** for artifacts like Reducers, Projections, ReadModels, Reactions, EventTypes, and appended events
- Strongly typed event content - the `Content` property on `AppendedEvent` is now the actual deserialized type instead of `ExpandoObject`

### Strategic Removals

We've retired some features to focus on what matters most:

- **AggregateRoot support** has moved to Arc, where it belongs architecturally
- **Rules engine** is no longer needed thanks to materialized read models and standard validation approaches like FluentValidation
- Direct Microsoft Orleans support for actor-based aggregate roots

These removals aren't about losing functionality - they're about doing things better with more standard, maintainable approaches.

## Arc v19.0.0 - Staying Aligned

[Arc v19.0.0](https://github.com/Cratis/Arc/releases/tag/v19.0.0) brings version alignment with Chronicle v15.0.0, ensuring you have compatible versions across your Cratis stack. The release also fixes an important issue with the proxy generator handling duplicate type names from different namespaces - now treated as a proper error rather than silently overwriting files.

## What's Next?

Looking at our active development, several exciting capabilities are in the works:

### Seed Data & Testing Support

We're working on a comprehensive **seed data specification system** that will make it easier to set up test data and bootstrap environments. This will be invaluable for development, testing, and demo scenarios.

### Contract Validation & Compatibility

Two major initiatives around API contracts are underway:

- **gRPC API surface validation** to catch breaking changes before they reach production
- **Client-server contract compatibility validation** that ensures clients and servers can safely communicate, preventing runtime failures due to version mismatches

### Compensation & Saga Support

**Event compensation support** is being developed to enable sophisticated saga patterns and complex business process management. This will allow you to define compensating actions for events, making it easier to handle long-running transactions and business processes that span multiple bounded contexts.

### Artifact Activation System

An **automatic dependency injection system for artifacts** is in development, further simplifying how you wire up and activate your projections, reducers, reactions, and other Chronicle artifacts. This will reduce boilerplate and make your applications more maintainable.

## Embracing the Future

These releases represent not just incremental improvements, but a strategic evolution of how we think about event sourcing and CQRS in modern .NET applications. By moving responsibilities to the right places, removing unnecessary abstractions, and focusing on developer experience, we're building a platform that's both powerful and pleasant to use.

The upcoming features around contract validation, compensation support, and seed data management show our commitment to making Chronicle production-ready for the most demanding enterprise scenarios while maintaining the developer-friendly approach that makes it great to work with.

If you're using Chronicle and Arc, I encourage you to upgrade and experience these improvements firsthand. As always, check the [release notes](https://github.com/Cratis/Chronicle/releases/tag/v15.0.0) for detailed migration guidance.

Ready to build better event-sourced systems? Start exploring Chronicle v15.0.0 today!
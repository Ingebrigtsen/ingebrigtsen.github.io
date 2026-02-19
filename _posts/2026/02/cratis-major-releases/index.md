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

Beyond TLS, Chronicle now **requires authenticated clients in production**, ensuring only authorized applications can connect to your event store. The **Workbench also requires authenticated users**, protecting your development and debugging tools from unauthorized access.

We've have our own authority into Chronicle, but you're not locked in - the system supports integration with external identity providers and authorities as well. All server configuration options, including authentication setup, are detailed in the [Chronicle hosting configuration documentation](https://www.cratis.io/docs/Chronicle/hosting/configuration/index.html).

### Performance & Scalability Enhancements

We've made substantial improvements to performance and resource management:

- **Bulk write mode** for replay and catch-up operations, reducing database round trips and significantly improving performance during large-scale operations
- **Job throttling** to prevent CPU exhaustion with configurable, sensible defaults
- **Transactional `AppendMany()`** that ensures all-or-nothing semantics when appending multiple events, with automatic retry on sequence number conflicts

### Developer Experience Improvements

The developer experience has been enhanced in several ways:

- **Static code analysis and code fixes** integrated into both [Chronicle](https://www.cratis.io/docs/Chronicle/code-analysis/index.html) and [Arc](https://www.cratis.io/docs/Arc/backend/code-analysis/index.html) ([Arc + Chronicle](https://www.cratis.io/docs/Arc/backend/chronicle/code-analysis/index.html)), helping you catch issues at compile time and follow best practices
- **Comprehensive documentation** that's been completely revamped to be more consistent and approachable - all available at [cratis.io](https://cratis.io)
- **Webhook-based observers** allowing arbitrary webhook endpoints to receive events
- **Consistent tagging system** for artifacts like Reducers, Projections, ReadModels, Reactions, EventTypes, and appended events
- Strongly typed event content - the `Content` property on `AppendedEvent` is now the actual deserialized type instead of `ExpandoObject`

### Workbench Enhancements

We've invested heavily in the **Chronicle Workbench** to provide the tooling necessary for a great developer experience. The standout feature is the **Time Machine** for debugging read models - allowing you to step through the evolution of your read models and understand exactly how they were built from your event stream. This isn't just a UI feature either; the Time Machine functionality is exposed through a public API in the client, so you can leverage it for your own debugging and testing needs.

![Time Machine](./time-machine.gif)

### Strategic Removals

We've retired some features to focus on what matters most:

- **AggregateRoot support** has moved to Arc, where it belongs architecturally
- **Rules engine** is no longer needed thanks to materialized read models and standard validation approaches like FluentValidation
- Direct Microsoft Orleans support for actor-based aggregate roots

These removals aren't about losing functionality - they're about doing things better with more standard, maintainable approaches.

## Arc v19.0.0 - Staying Aligned

[Arc v19.0.0](https://github.com/Cratis/Arc/releases/tag/v19.0.0) brings version alignment with Chronicle v15.0.0, ensuring you have compatible versions across your Cratis stack. The release also fixes an important issue with the proxy generator handling duplicate type names from different namespaces - now treated as a proper error rather than silently overwriting files.

Like Chronicle, Arc also benefits from [static code analysis support](https://www.cratis.io/docs/Arc/backend/code-analysis/index.html) to help you write better code and catch issues early.

## What's Next?

Our roadmap is laser-focused on one thing: **making event sourcing accessible through exceptional tooling and developer experience**. We firmly believe that great tooling is the key success factor for widespread adoption of event sourcing. It's not enough to have a powerful platform - developers need tools that make them productive, confident, and even joyful in their work.

### Workbench Evolution

We're continuing to invest heavily in the **Chronicle Workbench**, building features that simplify complex scenarios and provide visibility into your event-sourced systems. From the Time Machine for debugging to visualization tools for understanding your event streams, we're committed to making the Workbench an indispensable part of your development workflow.

### AI-Powered Development

We're embracing the AI revolution by building **MCP (Model Context Protocol) servers** that bring Chronicle and modern development patterns directly into your AI-assisted workflows:

- [Chronicle MCP Server](https://github.com/Cratis/Chronicle.Mcp) - bringing Chronicle concepts and patterns to your AI assistant
- [Vertical Slices MCP Server](https://github.com/Cratis/VerticalSlices) - helping you build better architectures with AI guidance

These integrations allow AI assistants to understand your event-sourced architecture and provide context-aware suggestions, making it easier than ever to build and maintain complex systems.

### Continuous Simplification

Every feature we build, every API we design, goes through the lens of developer experience. We're not just adding capabilities - we're continuously simplifying, streamlining, and removing friction. Because at the end of the day, the best tools are the ones that get out of your way and let you focus on solving business problems.

## Embracing the Future

These releases represent not just incremental improvements, but a strategic evolution of how we think about event sourcing and CQRS in modern .NET applications. By moving responsibilities to the right places, removing unnecessary abstractions, and focusing relentlessly on developer experience, we're building a platform that's both powerful and pleasant to use.

Our commitment to exceptional tooling - from static code analysis to the Workbench to AI integration - reflects our belief that event sourcing deserves the same world-class developer experience as any other architectural pattern. Better yet, it should be easier and more enjoyable than traditional approaches.

If you're using Chronicle and Arc, I encourage you to upgrade and experience these improvements firsthand. As always, check the [release notes](https://github.com/Cratis/Chronicle/releases/tag/v15.0.0) for more details.

Ready to build better event-sourced systems? Start exploring Chronicle v15.0.0 today!

# Code Comments and Documentation Style

Guidelines for writing code comments, XML documentation, README files, and technical documentation in Einar's voice.

## Core Principles

1. **Code should be self-explanatory** - Comments should explain "why", not "what"
2. **Documentation should be helpful** - Focus on developer experience
3. **Be concise but complete** - Don't waste words, but don't skip important context
4. **Maintain professionalism** - Less casual than blog posts, but still approachable

## Code Comments

### When to Comment

**DO comment:**

- Complex business logic that needs context
- Non-obvious technical decisions
- Workarounds or temporary solutions
- Public APIs and interfaces
- Trade-offs and why you chose this approach

**DON'T comment:**

- Obvious code (`// Set name to value` is useless)
- What the code does if it's self-evident
- Redundant information already in the code

### Style for Code Comments

**Good Examples:**

```csharp
// We're using ILRepack here instead of assembly merging because it provides
// better control over internalization of types. See docs/internalization.md
// for the full details of why this matters.
```

```csharp
// Todo: This should be moved to a background service once we implement
// the queue-based processing. For now, we handle it synchronously to 
// avoid complexity. See issue #123.
```

```csharp
// Orleans discovery relies on AssemblyPart attributes, but since we merge
// assemblies, these become invalid references. The AssemblyFixer tool
// removes them post-build to prevent runtime errors.
```

**Avoid:**

```csharp
// Get the user
var user = GetUser();

// Loop through items
foreach (var item in items)
{
    // Process the item
    ProcessItem(item);
}
```

### TODO Comments

Format for consistency:

```csharp
// Todo: [Brief description of what needs to be done]
// Context: [Why it needs to be done]
// Related: [Issue number, PR, or document reference]
```

## XML Documentation (C#)

Keep XML docs helpful and practical. Focus on helping developers use the API correctly.

### Summary

**Good:**

```csharp
/// <summary>
/// Creates a client observable that handles WebSocket connections transparently.
/// The observable will automatically serialize data as QueryResult and manage
/// client disconnection cleanup.
/// </summary>
```

**Avoid:**

```csharp
/// <summary>
/// Creates a client observable.
/// </summary>
```

### Parameters and Returns

Be specific about expectations:

```csharp
/// <param name="clientDisconnected">
/// Optional callback invoked when the client closes the WebSocket connection.
/// Use this for cleanup or logging purposes.
/// </param>
/// <returns>
/// A ClientObservable instance configured for the specified type. Call OnNext()
/// to push data to connected clients.
/// </returns>
```

### Remarks

Use remarks for important context, trade-offs, or usage patterns:

```csharp
/// <remarks>
/// This implementation uses ReplaySubject to ensure late-connecting clients
/// receive the most recent state. Be aware that this keeps the last value
/// in memory until the observable is disposed.
/// 
/// For high-frequency updates, consider using a different subject type or
/// implementing throttling.
/// </remarks>
```

## README Files

READMEs should be welcoming and practical. Help developers get started quickly.

### Structure

```markdown
# Project Name

Brief description of what this does and why it exists.

## Getting Started

The fastest path to running this.

## Core Concepts

High-level explanation of key ideas (if needed).

## Usage

Practical examples showing common scenarios.

## Contributing

How to contribute, running tests, etc.

## License

License information.
```

### Tone for READMEs

- Start with the problem or need
- Use "you" to address the reader
- Show code examples early
- Link to more detailed docs
- Keep it practical and action-oriented

**Example:**

```markdown
# Chronicle .NET Client

Chronicle is an Event Sourcing database built with developer experience in mind.
This client library provides a simple, type-safe way to interact with Chronicle
from your .NET applications.

## Quick Start

```csharp
// Connect to Chronicle
var client = new ChronicleClient("localhost:50051");

// Append events
await client.Events.Append(new OrderPlaced(orderId, customerId));

// Query events
var events = await client.Events.GetForAggregate(orderId);
```

See the [documentation](https://cratis.io/docs) for complete examples and guides.

## Architecture Documentation

When documenting architecture, focus on decisions and trade-offs.

### Decision Records (ADR-style)

```markdown
## Context

Describe the situation and the problem.

## Decision

What we decided to do.

## Consequences

Trade-offs and implications (positive and negative).

## Alternatives Considered

What else we looked at and why we didn't choose it.
```

### Example:

```markdown
## Merging Assemblies with ILRepack

### Context

Our .NET Client packages the gRPC contracts, but these contain types that
should not be exposed to consumers. Exposing them creates confusion and
increases our API surface without adding value.

### Decision

We use ILRepack to merge and internalize the contract assemblies into the
client assembly. We also built custom tools (AssemblyFixer, InternalsVerifier)
to handle Orleans-specific attributes and prevent accidental exposure.

### Consequences

**Positive:**
- Clean API surface - only relevant types visible to consumers
- Reduced confusion from duplicate type names
- Less API to maintain and version

**Negative:**
- Complex build process requiring custom tooling
- More difficult to debug merged assemblies
- Additional maintenance burden for our build tools

### Alternatives Considered

- Keep assemblies separate: Rejected due to confusion and API surface concerns
- Use InternalsVisibleTo: Doesn't solve the problem of exposing types
- Manual refactoring: Too much coupling, couldn't achieve goals
```

## API Documentation

Focus on putting developers in the pit of success.

### Property/Field Documentation

```csharp
/// <summary>
/// The default timeout for client connections in milliseconds.
/// Defaults to 30000 (30 seconds) for most scenarios.
/// </summary>
/// <remarks>
/// Set this to 0 for no timeout, but be aware this could lead to 
/// resource leaks if connections aren't properly managed.
/// </remarks>
public int DefaultTimeout { get; set; } = 30000;
```

### Method Documentation

```csharp
/// <summary>
/// Registers a query handler that automatically supports both HTTP and WebSocket modes.
/// </summary>
/// <typeparam name="TQuery">The query type to handle.</typeparam>
/// <typeparam name="TResult">The result type returned by the query.</typeparam>
/// <param name="handler">
/// The function that executes the query. This will be called for both HTTP GET 
/// requests and WebSocket subscriptions.
/// </param>
/// <remarks>
/// When accessed via HTTP GET, the handler is called once and returns the result.
/// When accessed via WebSocket, the handler should return a ClientObservable that
/// pushes updates as they occur.
/// 
/// See the documentation on queries for examples: https://cratis.io/docs/queries
/// </remarks>
```

## Code Documentation Principles

1. **Assume competence** - Don't over-explain basic programming concepts
2. **Provide context** - Explain why something works this way
3. **Link generously** - Point to related docs, issues, or discussions
4. **Show consequences** - Help developers understand trade-offs
5. **Guide usage** - Show the intended way to use APIs
6. **Acknowledge complexity** - Don't pretend hard things are easy

## Language Style

### For Code Comments

- More concise than blog posts
- Still conversational but professional
- Use complete sentences
- Avoid excessive casualness

### For Documentation

- Professional but approachable
- Clear and direct
- Example-driven when possible
- Structure information for scanning

### For READMEs

- Welcoming and helpful
- Get people started quickly
- Link to detailed docs
- Show common use cases

## Examples of Tone Balance

❌ **Too Casual (for code):**

```csharp
// Yo, this is gonna blow up if you pass null, so don't do that lol
```

❌ **Too Formal:**

```csharp
// This method leverages the factory pattern implementation to instantiate
// the appropriate concrete implementation of the interface specification.
```

✅ **Just Right:**

```csharp
// Note: Passing null will throw ArgumentNullException. Use the parameterless
// constructor if you want default behavior.
```

---

**Remember:** Code documentation should help developers succeed. Be clear, be helpful, and respect their intelligence while providing the context they need.

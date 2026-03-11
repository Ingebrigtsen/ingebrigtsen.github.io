---
title: "Dynamic Consistency Boundaries — the Chronicle way"
date: "2026-03-10"
categories:
  - "net"
  - "architecture"
  - "cratis"
  - "chronicle"
tags:
  - "c#"
  - "event sourcing"
  - "ddd"
  - "cqrs"
---

## What is a Dynamic Consistency Boundary?

A [Dynamic Consistency Boundary](https://www.cratis.io/docs/Chronicle/dynamic-consistency-boundary/index.html) (DCB)
is a deceptively simple idea: consistency should be scoped to the *facts* a decision actually needs,
not to a fixed object boundary drawn at design time.

In practice that means:

- Load only the data relevant to the decision at hand.
- Derive the consistency boundary at runtime from that data.
- Enforce consistency for that boundary alone and let everything else remain eventually consistent.

The aggregate root pattern has traditionally been the DDD answer to this problem. You draw a line
around a cluster of objects, call it a boundary, and protect consistency inside it.
The trouble is that the line is drawn once, at design time, before you fully understand your
access patterns. Unrelated concerns end up sharing a single transactional boundary because they
happened to belong to the same "noun". The aggregate swells, contention grows, and the model
drifts further from the actual business rules it was meant to reflect.

DCB flips this around. The boundary is not a static design decision — it emerges from each
individual command's decision requirements.

## Coupling and vertical slices

One of the quieter benefits of DCB is what it does to coupling.

The classic aggregate root is a horizontal structure: a single object owns a cluster of state
and every operation that touches that state goes through it. Over time the aggregate accumulates
fields, methods, and invariants that belong to different features — they share the boundary
because they share the noun, not because they share a consistency requirement. Changing one
feature risks touching code that another feature depends on. The aggregate becomes a coupling
magnet.

Vertical slices cut the other way: each command is a self-contained unit. It reads the
projections it actually needs, enforces the constraints relevant to its own decision, and
expresses its concurrency scope narrowly. The next command is a separate slice with its own
footprint. They overlap only where the business domain genuinely demands it, not by accident
of object design.

DCB gives vertical slices their consistency backbone. Without some form of dynamic scoping
you are forced to either share a coarse aggregate (horizontal coupling) or accept weaker
guarantees (optimistic writes with no real guard). DCB lets each slice declare exactly what
consistency it needs and have the store enforce it — nothing more, nothing less.

The practical result is that adding or changing a feature tends to stay contained. A new
command introduces its own read model, its own constraints, and its own concurrency scope.
It does not need to fit inside an existing aggregate or widen an existing boundary. The
consistency surface area grows with the feature, not ahead of it.

## Chronicle was built with this in mind

[Chronicle](https://www.cratis.io/docs/Chronicle/dynamic-consistency-boundary/chronicle.html) predates
the DCB name, but the architecture maps cleanly onto its concepts. Events can be appended
independently. Read models are built from projections over disparate streams. Consistency
for the specific facts used to decide is enforced at append time through constraints and
concurrency scopes.

The practical flow looks like this:

1. Read the projections needed to decide.
2. Build constraints that express the decision rule.
3. Choose concurrency scopes that match the decision boundary.
4. Append events and let projections update.

This is not grafted on — it is how Chronicle works by default.

## Constraints: integrity without an aggregate root

The most important building block for DCB in Chronicle is
[constraints](https://www.cratis.io/docs/Chronicle/constraints/index.html).

Constraints are server-side rules evaluated inside the Chronicle Kernel *at append time*. Because
they run in the kernel rather than in client code they are consistent regardless of which client
appends the event, and regardless of whether the client is a well-behaved in-process handler or
a script running directly against the API.

A constraint is any class that implements `IConstraint`:

```csharp
using Cratis.Chronicle.Events.Constraints;

public class UniqueUserNameConstraint : IConstraint
{
    public void Define(IConstraintBuilder builder)
    {
        builder.Unique(unique => unique
            .On<UserRegistered>(@event => @event.UserName)
            .On<UserNameChanged>(@event => @event.NewUserName)
            .RemovedWith<UserRemoved>());
    }
}
```

Chronicle discovers and registers constraints automatically. The kernel creates the required
indexes and evaluates the rule on every append. If the constraint is violated the append fails —
no event is written and no partial state exists.

What this buys you is substantial. You do not need an aggregate root acting as a gatekeeper
to call `ValidateUniqueUserName()` before appending. The rule lives at the store level and
applies universally. The traditional aggregate-root pattern achieves the same end by loading
all past events for an entity, replaying state, and running the check in-process. That works,
but it couples the integrity guarantee to a client-side object that can be bypassed, loaded
incorrectly, or grow stale.

Chronicle's [constraints documentation](https://www.cratis.io/docs/Chronicle/constraints/dotnet-client.html)
covers the full C# usage including uniqueness across multiple event types.

## A fluid concurrency model

Chronicle's [concurrency model](https://www.cratis.io/docs/Chronicle/events/concurrency.html)
is designed to be as narrow or as broad as each decision requires. The central concept is
`ConcurrencyScope` — a description of exactly which streams and event types must be checked
together when a new event is appended.

The simplest form scopes concurrency to a single event source at a known sequence number:

```csharp
var scope = new ConcurrencyScope(
    sequenceNumber: 42,
    eventSourceId: accountId);

await eventLog.Append(accountId, new AccountOpened(accountName), concurrencyScope: scope);
```

For more complex decisions you can compose a scope with the fluent builder:

```csharp
var scope = new ConcurrencyScopeBuilder()
    .WithEventSourceId(accountId)
    .WithSequenceNumber(15)
    .WithEventStreamType("Transactions")
    .WithEventType<MoneyDeposited>()
    .WithEventType<MoneyWithdrawn>()
    .Build();
```

Notice that the scope is scoped to *specific event types*. Operations on unrelated event types
will not contend with this append at all. That is DCB in action: only the facts the decision
depends on participate in consistency enforcement.

Chronicle uses a set of [formalized metadata tags](https://www.cratis.io/docs/Chronicle/events/concurrency.html#formalized-metadata-tags-for-concurrency)
that are indexed and used when evaluating concurrency scopes:

| Tag | Purpose |
|---|---|
| `EventSourceId` | Unique identifier for the event source |
| `EventSourceType` | Overarching concept (e.g. `Account`) |
| `EventStreamType` | A concrete process on the source (e.g. `Transactions`) |
| `EventStreamId` | Separates independent sub-streams (e.g. `2026-03`) |
| `EventTypes` | Specific event types for fine-grained scoping |

When appending events that involve multiple event sources — a money transfer between two
accounts, for instance — you can supply per-source concurrency scopes:

```csharp
await eventLog.AppendMany(events, concurrencyScopes: new Dictionary<EventSourceId, ConcurrencyScope>
{
    [fromAccount] = new ConcurrencyScopeBuilder()
        .WithEventSourceId(fromAccount)
        .WithSequenceNumber(50)
        .WithEventType<MoneyWithdrawn>()
        .Build(),

    [toAccount] = new ConcurrencyScopeBuilder()
        .WithEventSourceId(toAccount)
        .WithSequenceNumber(25)
        .WithEventType<MoneyDeposited>()
        .Build()
});
```

Each side of the transfer is protected at exactly the event types relevant to it. There is no
shared aggregate that must "own" both accounts. The boundary is the scope needed to make a correct
decision — nothing more.

## Declaring concurrency intent on commands

The raw `ConcurrencyScope` API gives you full control, but in most cases you should not have
to build scopes manually. Arc lets you declare the concurrency intent directly on the command
record using attributes, and Chronicle constructs the scope automatically when `Handle()` returns
events.

Three attributes are available — each with a dual purpose: they tag the appended events with
metadata *and*, when `concurrency: true` is set, contribute that dimension to the concurrency
scope:

- **`[EventSourceType]`** — scopes to an overarching concept such as `"Customer"` or `"BankAccount"`.
- **`[EventStreamType]`** — scopes to a named stream type, e.g. `"Transactions"` or `"Onboarding"`.
- **`[EventStreamId]`** — scopes to a specific stream id within a stream type.

A payment command that should only compete with other payment events on the same account looks
like this:

```csharp
[Command]
[EventStreamType("Transactions", concurrency: true)]
public record ProcessPayment(EventSourceId AccountId, decimal Amount)
{
    public PaymentProcessed Handle() => new(AccountId, Amount);
}
```

You can combine attributes to build a more precise boundary. Only the attributes marked
`concurrency: true` contribute to the scope — the others still tag the events but do not
tighten the boundary:

```csharp
[Command]
[EventStreamId("customer-profile", concurrency: true)]
[EventStreamType("Profile", concurrency: true)]
[EventSourceType("Customer", concurrency: true)]
public record UpdateCustomerProfile(EventSourceId CustomerId, string DisplayName, string Email)
{
    public IEnumerable<object> Handle() =>
    [
        new CustomerDisplayNameChanged(CustomerId, DisplayName),
        new CustomerEmailChanged(CustomerId, Email)
    ];
}
```

If no attribute has `concurrency: true` the append proceeds without any optimistic concurrency
check — appropriate for fire-and-forget writes where contention is not a concern.

When the event stream id is only known at runtime rather than as a compile-time constant,
implement `ICanProvideEventStreamId` and return the value from `GetEventStreamId()`:

```csharp
[Command]
[EventStreamType("Reporting", concurrency: true)]
public record GenerateMonthlyReport(EventSourceId AccountId, string MonthKey)
    : ICanProvideEventStreamId
{
    public EventStreamId GetEventStreamId() => MonthKey;

    public MonthlyReportGenerated Handle() => new(AccountId, MonthKey);
}
```

The full details of how Arc resolves and builds the scope are in the
[Arc concurrency documentation](https://www.cratis.io/docs/Arc/backend/chronicle/commands/concurrency.html).

What this pattern achieves at the design level is significant: the concurrency boundary is
visible at a glance on the command record itself. You do not need to trace through a builder
call or look inside an aggregate to understand what consistency contract a command makes. The
command is a vertical slice — it carries its own decision rules (via read model injection),
its own business logic (`Handle`), and its own concurrency scope (via attributes) — all in one
place and all with the minimum footprint needed for that specific operation.

## Projections join the picture

Constraints and concurrency scopes protect the write side. The read side is equally important:
you need to *decide* before you can append, and decisions are made against facts. Those facts
come from [projections](https://www.cratis.io/docs/Chronicle/projections/index.html).

What makes Chronicle's projection system particularly useful for DCB is that projections can
join data from entirely different event streams into a single coherent read model. The
projection framework supports:

- **FROM** mappings that pull properties from events on any stream.
- **JOIN** operations that link data across event source boundaries.
- **Children** collections that model parent/child relationships built from distinct event types.

This means a read model that forms the decision facts for a command can already be a synthesis
of events from several independent parts of the system. The consistency boundary the command
enforces is therefore exactly as wide as the data it reads — not an artificial aggregate boundary
invented at design time.

Because projections are eventually consistent they are updated asynchronously after each append.
For decision-making this means decisions are based on the most recently projected state at the
moment of the command. That is precisely the property DCB calls for: the decision is valid
against the set of facts as they stood when the decision was made, and the constraint enforces
that those facts have not changed before the event commits.

## Read models as business rule guards

If constraints cover data integrity — "is this user name unique?" — there is a larger class of
business rules that are better expressed as policy validation: "is the order in a state that
permits this action?", "has the customer reached their limit?", "is this role still accepting
assignments?".

In [Arc](https://www.cratis.io/docs/Arc/backend/chronicle/read-models.html), the application
framework built on Chronicle, read models produced by projections can be injected directly
as dependencies into command handlers and command validators. The identity of which read model
instance to load is resolved automatically. Arc uses two mechanisms for this, applied in order:

1. **By convention** — if the command has a property whose type is `EventSourceId` or any type
   that inherits from it, that value is used as the event source identity. No attribute is required.
2. **By `[Key]` attribute** — mark any property with `[Key]` and Arc will use that value as the
   identity regardless of its type.

The convention-based resolution is handled by the
[`EventSourceValuesProvider`](https://www.cratis.io/docs/Arc/backend/chronicle/event-source-values-provider.html),
which inspects the command and adds the resolved identity to the command context so all downstream
Chronicle services — aggregate resolution, read model loading, and concurrency scoping — see the
same identity without any custom plumbing.

```csharp
public record PlaceOrderCommand([Key] Guid OrderId, Guid CustomerId, OrderLine[] Items)
{
    public OrderPlaced Handle(OrderReadModel order)
    {
        if (order.Status != OrderStatus.Draft)
            throw new CannotModifyNonDraftOrder(OrderId);

        if (order.LineItems.Length + Items.Length > 100)
            throw new TooManyOrderLines();

        return new OrderPlaced { CustomerId = CustomerId, Items = Items };
    }
}
```

For richer validation, inject the same read model into a `CommandValidator<>`:

```csharp
public class AssignPersonToRoleValidator : CommandValidator<AssignPersonToRoleCommand>
{
    public AssignPersonToRoleValidator(RoleReadModel role)
    {
        RuleFor(x => x.PersonId)
            .Must(personId => !role.AssignedPersonIds.Contains(personId))
            .WithMessage("Person is already assigned to this role");

        RuleFor(x => x)
            .Must(_ => role.Status == RoleStatus.Active)
            .WithMessage("Cannot assign people to inactive roles");

        RuleFor(x => x)
            .Must(_ => role.AssignedPersonIds.Length < role.MaxAssignments)
            .WithMessage($"Role has reached maximum assignments of {role.MaxAssignments}");
    }
}
```

This pattern replaces the aggregate-root-as-validator entirely. The read model is the projected
state built from all relevant events — it can join across streams, aggregate counts, and
compute derived values in ways a replayed aggregate cannot do without replicating that
projection logic inside itself. The command sees a clean, populated view model rather than a
raw event-sourced object graph.

Arc validates commands before the decision block runs, so by the time `Handle` is called the
policy rules have already been checked. Chronicle's constraints then enforce data integrity
at the kernel level. Together these two layers guard the system from two different angles
without a single aggregate root in sight.

## Aggregate roots: supported, but not the goal

Chronicle does [support aggregate roots](https://www.cratis.io/docs/Arc/backend/chronicle/aggregates/aggregate-roots.html)
through Arc. They are a legitimate choice if you want that style, and Chronicle handles the
event stream scoping and concurrency automatically when you use them.

That said, we believe most systems will be healthier without leaning on them as the default.
An aggregate root imposes friction: every command must load an aggregate, replay its history,
run its logic, and emit events. The aggregate becomes the single choke point for a whole
class of decisions. As a system grows the aggregates grow with it, carrying state needed by
some commands but irrelevant to others, all participating in the same transactional boundary
regardless of whether the current command requires it.

The alternative — vertical slices backed by constraints, concurrency scopes, and projection-backed
read models — keeps each operation aligned with exactly the data it needs. There is less coupling,
less contention, and the design is easier to evolve because each command's consistency
requirements are expressed locally rather than accumulated inside a shared object.

## Further reading

- [Dynamic Consistency Boundary — Overview](https://www.cratis.io/docs/Chronicle/dynamic-consistency-boundary/index.html)
- [DCB in Chronicle](https://www.cratis.io/docs/Chronicle/dynamic-consistency-boundary/chronicle.html)
- [Constraints](https://www.cratis.io/docs/Chronicle/constraints/index.html)
- [Constraints — C# usage](https://www.cratis.io/docs/Chronicle/constraints/dotnet-client.html)
- [Concurrency scopes](https://www.cratis.io/docs/Chronicle/events/concurrency.html)
- [Arc command concurrency attributes](https://www.cratis.io/docs/Arc/backend/chronicle/commands/concurrency.html)
- [Projections](https://www.cratis.io/docs/Chronicle/projections/index.html)
- [Arc read models](https://www.cratis.io/docs/Arc/backend/chronicle/read-models.html)
- [Arc Event Source Values Provider](https://www.cratis.io/docs/Arc/backend/chronicle/event-source-values-provider.html)
- [dcb.events](https://dcb.events)

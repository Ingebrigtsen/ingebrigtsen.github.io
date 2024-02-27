---
title: "Domain Concepts"
date: "2021-09-12"
categories: 
  - "net"
  - "code-quality"
  - "code-tips"
  - "practices"
tags: 
  - "c"
---

Back in 2015, I wrote about [concepts](https://www.ingebrigtsen.info/2015/02/03/concepts-and-more/). The idea behind these are that you encapsulate types that has meaning to your domain as well known types. Rather than relying on technical types or even primitive types, you then formalize these types as something you use throughout your codebase. This provides you with a few benefits, such as readability and potentially also give you compile time type checking and errors. It does also provide you with a way to adhere to the [element of least surprise](https://en.wikipedia.org/wiki/Principle_of_least_astonishment) principle. Its also a great opportunity to use the encapsulation to deal with cross cutting concerns, for instance values that adhere to compliance such as GDPR or security concerns where you want to encrypt while in motion etc.

Throughout the years at the different places I've been at were we've used these, we've evolved this from a very simple [implementation](https://github.com/einari/Bifrost/blob/master/Source/Bifrost/Concepts/ConceptAs.cs) to a more [evolved one](https://github.com/einari/DotNET.Fundamentals/blob/master/Source/Concepts/ConceptAs.cs). Both these implementations aims at making it easy to deal with equability and the latter one also with comparisons. That becomes very complex when having to support different types and scenarios.

Luckily now, with C# 9 we got [records](https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/builtin-types/record) which lets us truly simplify this:

```csharp
public record ConceptAs<T>
{
    public ConceptAs(T value)
    {
        ArgumentNullException.ThrowIfNull(value, nameof(value));
        Value = value;
    }

    public T Value { get; init; }
}
```

With **record** we don't have to deal with equability nor comparable, it is dealt with automatically - at least for primitive types.

Using this is then pretty straight forward:

```csharp
public record SocialSecurityNumber(string value) : ConceptAs<string>(value);
```

A full implementation can be found [here](https://github.com/Cratis/cratis/blob/main/Source/Fundamentals/Concepts/ConceptAs.cs) - an implementation using it [here](https://github.com/Cratis/cratis/blob/main/Source/Kernel/Events.Store/EventLogId.cs).

## Implicit conversions

One of the things that can also be done in the base class is to provide an implicit operator for converting from **ConeptAs** type to the underlying type (e.g. Guid). Within an implementation you could also provide the other way, going from the underlying type to the specific. This has some benefits, but also some downsides. If you want the compiler to catch errors - obviously, if all yours **ConceptAs<Guid>** implementations would be interchangeable.

## Serialization

When going across the wire with JSON for instance, you probably don't want the full construct with a **{ value: <actual value> }**, or if you're storing it in a database. In C# most serializers support the notion of conversion to and from the target. For Newtonsoft.JSON these are called **JsonConverter** - an example can be found [here](https://github.com/einari/DotNET.Fundamentals/blob/master/Source/Concepts.Serialization.Json/ConceptConverter.cs), for MongoDB as an example, you can find an example of a serializer [here](https://github.com/Cratis/cratis/blob/main/Source/Fundamentals/MongoDB/ConceptSerializer.cs).

## Summary

I highly recommend using strong types for your domain concepts. It will make your APIs more obvious, as you would then avoid methods like:

```csharp
Task Commit(Guid eventSourceId, Guid eventType, string content);
```

And then get a more clearer method like:

```csharp
Task Commit(EventSourceId eventSourceId, EventType eventType, string content);
```

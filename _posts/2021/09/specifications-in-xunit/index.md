---
title: "Specifications in xUnit"
date: "2021-09-05"
categories: 
  - "code-tips"
  - "practices"
tags: 
  - "c#"
  - "specifications"
  - "testing"
---

## TL;DR

You can find a full implementation with sample [here](https://github.com/aksio-system/Specifications).

## Testing

I wrote my first unit test in 1996, back then we didn't have much tooling and basically just had executables that ran automatic test batteries, but it wasn't until Dan North introduced the concept of [Behavior-Driven Development in 2006](https://dannorth.net/introducing-bdd/) it truly clicked into place for me. Writing tests - or specifications that specify the behavior of a part of the system or a unit made much more sense to me. With [Machine.Specifications](https://github.com/machine/machine.specifications) (MSpec for short) it became easier and more concise to express your specifications as you can see from [this post](https://elegantcode.com/2010/02/19/getting-started-with-machine-specifications-mspec/) comparing an NUnit approach with MSpec.

The biggest problem MSpec had and still has IMO is its lack of adoption and community. This results in lack of contributors giving it the proper TLC it deserves, which ultimately lead to a lack of good consistent tooling experience. The latter has been a problem ever since it was introduced and throughout the years the integrated experience in code editors or IDEs has been lacking or buggy at best. Sure, running it from terminal has always worked - but to me it stops me a bit in the track as I'm a sucker for feedback loops and loves being in the flow.

## xUnit FTW

This is where [xUnit](https://xunit.net) comes in. With a broader adoption and community, the tooling experience across platforms, editors and IDEs is much more consistent.

I set out to get the best of breed and wanted to see if I could get close to the MSpec conciseness and get the tooling love. Before I got sucked into the [not invented here syndrom](https://en.wikipedia.org/wiki/Not_invented_here) I researched if there were already solutions out there. Found a few posts on it and found the [Observation sample](https://github.com/xunit/samples.xunit/tree/main/ObservationExample) In the xUnit samples repo to be the most interesting one. But I couldn't get it to work with the tooling experience in my current setup (.NET 6 preview + VSCode on my Mac).

From this I set out to create something of a thin wrapper that you can find as a Gist [here](https://gist.github.com/einari/dce8f2e787b96408c1e937da0d0900c4). The Gist contains a base class that enables the expressive features of MSpec, similar wrapper for testing exceptions and also extension methods mimicking **Should\*()** extension methods that MSpec provides.

## By example

Lets take the example from the MSpec readme:

```csharp
class When_authenticating_an_admin_user
{
    static SecurityService subject;
    static UserToken user_token;

    Establish context = () => 
        subject = new SecurityService();

    Because of = () =>
        user_token = subject.Authenticate("username", "password");

    It should_indicate_the_users_role = () =>
        user_token.Role.ShouldEqual(Roles.Admin);

    It should_have_a_unique_session_id = () =>
        user_token.SessionId.ShouldNotBeNull();
}
```

With my solution we can transform this quite easily, maintaining structure, flow and conciseness. Taking full advantage of [C# expression body definition (lambda)](https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/operators/lambda-operator#expression-body-definition):

```csharp
class When_authenticating_an_admin_user : Specification
{
    SecurityService subject;
    UserToken user_token;

    void Establish() =>
             subject = new SecurityService();

    void Because() =>
             user_token = subject.Authenticate("username", "password");

    [Fact] void should_indicate_the_users_role() =>
        user_token.Role.ShouldEqual(Roles.Admin);

    [Fact] void should_have_a_unique_session_id() =>
        user_token.SessionId.ShouldNotBeNull();
}
```

Since this is pretty much just standard xUnit, you can leverage all the features and [attributes](https://xunit.net/docs/comparisons).

## Catching exceptions

With the Gist, you'll find a type called **Catch**. Its purpose is to provide a way to capture exceptions from method calls to be able to assert that the exception occurred or not. Below is an example of its usage, and also one of the extension methods provided in the Gist - **ShouldBeOfExactType<>()**.

```csharp
class When_authenticating_a_null_user : Specification
{
    SecurityService subject;
    Exception result;

    void Establish() =>
             subject = new SecurityService();

    void Because() =>
             result = Catch.Exception(() => subject.Authenticate(null, null));

    [Fact] void should_throw_user_must_be_specified_exception() =>
        result.ShouldBeOfExactType<UserMustBeSpecified>();
}
```

## Contexts

With this approach one ends up being very specific on behaviors of a system/unit, this leads to multiple classes specifying different aspects of the same behavior in different contexts or different behaviors of the system/unit. To avoid having to do the setup and teardown of these within each of these classes, I like to reuse these by leveraging inheritance. In addition, I tend to put the reused contexts in a folder/namespace that is called **given**; yielding a more readable result.

Following the previous examples we now have two specifications and both requiring a context of the system being in a state with no user authenticated. By adding a file in the **given** folder of this unit and then adding a namespace segment og **given** as well, we can encapsulate the context as follows:

```csharp
class no_user_authenticated
{
    protected SecurityService subject;

    void Establish() =>
             subject = new SecurityService();
}
```

From this we can simplify our specifications by removing the **establish** part:

```csharp
class When_authenticating_a_null_user : given.no_user_authenticated
{
    Exception result;

    void Because() =>
             result = Catch.Exception(() => subject.Authenticate(null, null));

    [Fact] void should_throw_user_must_be_specified_exception() =>
        result.ShouldBeOfExactType<UserMustBeSpecified>();
}
```

The Gist supports multiple levels of inheritance recursively and will run all the lifecycle methods such as **Establish** from the lowest level in the hierarchy chain and up the hierarchy (e.g. no\_user\_authenticated -> when\_authenticating\_a\_null\_user).

## Teardown

In addition to **Establish**, there is its counterpart; **Destroy**. This is where you'd typically cleanup anything needing to be cleaned up - typically if you need to clean up some global state that was mutated. Take our context for instance and assuming the **SecurityService** implements **IDisposable**:

```csharp
class no_user_authenticated
{
    protected SecurityService subject;

    void Establish() =>
             subject = new SecurityService();

    void Destroy() => subject.Dispose();

}
```

## Added benefit

One of the problems that has been with the MSpec approach is that its all based on statics since it is using delegates as "keywords". Some of the runners have problems with this and async models, causing havoc and non-deterministic test results. Since xUnit is instance based, this problem goes away and every instance of the specification is in isolation.

## Summary

This is probably just yet another solution to this and I've probably overlooked implementations out there, if that's the case - please leave me a comment, would love to not have to maintain this myself 🙂. It has helped me get to a tighter feedback loop as I now can run or debug tests in context of where my cursor is in VSCode with a keyboard shortcut and see the result for that specification only. My biggest hope for the future is that we get a tooling experience in VSCode that is similar to [Wallaby](https://wallabyjs.com) is doing for JS/TS testing. Windows devs using full Visual Studio also has the [live unit testing](https://docs.microsoft.com/en-us/visualstudio/test/live-unit-testing?view=vs-2019) feature. With .NET 6 and the [hot reload](https://devblogs.microsoft.com/aspnet/asp-net-core-updates-in-net-6-preview-5/#net-hot-reload-updates-for-dotnet-watch) feature I'm very optimistic on tooling going in this direction and we can shave the feedback loop even more.

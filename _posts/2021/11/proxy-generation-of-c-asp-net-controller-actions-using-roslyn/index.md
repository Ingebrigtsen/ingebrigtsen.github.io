---
title: "Proxy generation of C# ASP.NET controller actions using Roslyn"
date: "2021-11-02"
categories: 
  - "code-tips"
tags: 
  - "c"
  - "productivity"
---

## TL;DR

All the things discussed can be found as code [here](https://github.com/aksio-system/Foundation/tree/main/Source/Tooling/ProxyGenerator) basic documentation for it [here](https://github.com/aksio-system/Foundation/blob/main/Documentation/frontend/proxy-generation.md). If you're interested in the NuGet Package directly, you find it [here](https://www.nuget.org/packages/Aksio.ProxyGenerator/). The [sample](https://github.com/aksio-system/Foundation/tree/main/Sample) in the repo uses it - read more [here](https://github.com/aksio-system/Foundation#running-the-sample) on how to run the sample.

**_Update_:** have look [here](https://ingebrigtsen.blog/2021/12/11/avoid-code-generation-if-compiler-is-in-error-state/) as well for avoiding generation when there are errors.

## Productivity

I'm a huge sucker for anything that can optimize productivity and I absolutely love taking something that me or any of my coworkers tend to repeat and make it go away. We tend to end up having rules we apply to our codebase, making them a convention - these are great opportunities for automation. One of these areas is the glue between the backend and the frontend. If your backend is written in C# and your frontend in JS/TS and you're talking to the backend over APIs.

Instead of having a bunch of `fetch` calls in your frontend code with URLs floating around, I believe in wrapping these up nicely to be imported. This is what can be automated; generate proxy objects that can be used directly in code. In the past I've [blogged about this](https://www.ingebrigtsen.info/2013/10/06/bifrost-and-proxy-generation/) with a runtime approach.

Anyone familiar with [gRPC](https://grpc.io/docs/languages/csharp/quickstart/#generate-grpc-code) or [GraphQL](https://www.graphql-code-generator.com) are probably already familiar with the concept of defining an API surface and having code generated. Also in the [Swagger](https://swagger.io/tools/swagger-codegen/) space you can generate code directly from the OpenAPI JSON definition.

## Meet Roslyn Source Generators

With .NET and the Roslyn Compiler we can optimize this even further. With the introduction of [source generators](https://docs.microsoft.com/en-us/dotnet/csharp/roslyn-sdk/source-generators-overview) in Roslyn, we can be part of the compiler and generate what we need. Although its originally designed to generate C# code that will be part of the finished compiled assembly, there is nothing stopping us from outputting something else.

A generator basically has 2 parts to it; a syntax receiver and the actual generator. The syntax receiver visits the abstract syntax tree given by the compiler and can then decide what it finds interesting for the generator to generate from.

Our [SyntaxReceiver](https://github.com/aksio-system/Foundation/blob/main/Source/Tooling/ProxyGenerator/SyntaxReceiver.cs) is very simple, we're just interested in ASP.NET Controllers, and consider all of these as candidates.

```csharp
public class SyntaxReceiver : ISyntaxReceiver
{
    readonly List<ClassDeclarationSyntax> _candidates = new();

    /// <summary>
    /// Gets the candidates for code generation.
    /// </summary>
    public IEnumerable<ClassDeclarationSyntax> Candidates => _candidates;

    /// <inheritdoc/>
    public void OnVisitSyntaxNode(SyntaxNode syntaxNode)
    {
        if (syntaxNode is not ClassDeclarationSyntax classSyntax) return;
        if (!classSyntax.BaseList?.Types.Any(_ => _.Type.GetName() == "Controller") ?? false) return;
        _candidates.Add(classSyntax);
    }
}
```

The [SourceGenerator](https://github.com/aksio-system/Foundation/blob/main/Source/Tooling/ProxyGenerator/SourceGenerator.cs) is handed the syntax receiver with the candidates in it.

```csharp
[Generator]
public class SourceGenerator : ISourceGenerator
{
    /// <inheritdoc/>
    public void Initialize(GeneratorInitializationContext context)
    {
        context.RegisterForSyntaxNotifications(() => new SyntaxReceiver());
    }

    /// <inheritdoc/>
    public void Execute(GeneratorExecutionContext context)
    {
        var receiver = context.SyntaxReceiver as SyntaxReceiver;
        // Build from what the syntax receiver deemed interesting.
    }
}
```

There are a few moving parts to our generator and approach, so I won't get into details on the inner workings. You can find the full code of the generator we've built [here](https://github.com/aksio-system/Foundation/tree/main/Source/Tooling/ProxyGenerator).

## In a nutshell

Our generator follows what we find to be a useful pattern. We've basically grouped our operations into **Commands** and **Queries** (I'm a firm believer of [CQRS](https://www.ingebrigtsen.info/2012/07/28/cqrs-in-asp-net-mvc-with-bifrost/)). This gives us basically two operation methods we're interested in; **\[HttpPost\]** and **\[HttpGet\]**. In addition we're saying that a Command (HttpPost) can be formalized as a type and is the only parameter on an **\[HttpPost\]** action using **\[FromBody\]**. Similar with Queries, actions that return an enumerable of something and can take parameters in the form of query string parameters (**\[FromQuery\]**) or from the route (**\[FromRoute\]**).

From this we generate type proxies for the input and output object types and use the namespace as the basis for a folder structure: `My.Application.Has.Features` gets turned into a relative path `My/Application/Has/Features` and is added to the output path.

Our generated code relies on base types and helpers we've put into a [frontend package](https://github.com/aksio-system/Foundation/tree/main/Source/Frontend). Since we're building our frontends using React, we've done things specifically for that as well - for instance for queries with a `[useQuery](https://github.com/aksio-system/Foundation/blob/main/Source/Frontend/queries/useQuery.ts)` hook.

The way we do generation is basically through [templates](https://github.com/aksio-system/Foundation/tree/main/Source/Tooling/ProxyGenerator/Templates) for the different types leveraging [Handlebars.net](https://github.com/Handlebars-Net/Handlebars.Net).

## The bonus

One of the bonuses one gets with doing this is that the new hot reload functionality of .NET 6 makes for a very tight feedback loop with these type of source generators as well. While running with `dotnet watch run` - it will continuously run while I'm editing in the C# code that is being marked as candidates by the syntax receiver. Below you'll see C# on the right hand side while TypeScript is being generated on the left hand side while typing. Keep in mind though, if you have something that generates files with a filename based on something in the original code, you might find some interesting side-effects (ask me how I know 😂).

[![](images/2021-11-01_13-06-45-2.gif)](http://localhost:8080/wp-content/uploads/2021/11/2021-11-01_13-06-45-2.gif)

## Conclusion

Productivity is a clear benefit for us, as the time jumping from backend to frontend is cut down. The context switch is also optimized, as a developer can go directly from doing something in the backend and immediately use it in the frontend without doing anything but compiling - which you're doing anyways.

Another benefit you get with doing something like this is that you create yourself an anti corruption layer (ACL). Often ACLs are associated with going between something like different bounded contexts or different microservices, but the concept of having something in between that basically does the translation between two concepts and allowing for change without corrupting either parties. The glue that the proxies represents is such an ACL - we can change the backend completely and swap out our REST APIs in the future for something else, e.g. GraphQL, gRPC og WebSockets and all we need to change for the frontend to keep working is the glue part - our proxies and the abstraction in the frontend they leverage.

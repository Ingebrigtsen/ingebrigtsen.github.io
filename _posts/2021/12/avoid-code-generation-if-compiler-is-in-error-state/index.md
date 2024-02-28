---
title: "Avoid code generation if compiler is in error state"
date: "2021-12-11"
categories: 
  - "net"
  - "csharp"
  - "code-quality"
tags: 
  - "c#"
  - "productivity"
---

One of the things discovered with usage of our [proxy](https://ingebrigtsen.blog/2021/11/02/proxy-generation-of-c-asp-net-controller-actions-using-roslyn/) [generator](https://ingebrigtsen.blog/2021/11/02/proxy-generation-of-c-asp-net-controller-actions-using-roslyn/) was that when working in the code and adding things like another property on a class/record. While typing we could see the generator running and spitting out files as we type. For instance, lets say we have the following:

```csharp
public record DebitAccount(AccountId Id, AccountName Name, PersonId Owner, double Balance);
```

If I were to now after a build start typing for a fifth property in this, it would start spitting out things. First a file without any name, then as I typed the type I would get a file for each letter I added - depending on how fast I typed. So if this was a **string** type, I could be seeing **_s.ts_**, **_st.ts_**, **_str.ts_** and so on.

Turns out this is by design. One of the optimizations done for the `dotnet build` command is that it keeps the compiler process around. It starts a [build-server](https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet-build-server) that will handle incremental builds as things is happening and therefor be prepared for when we actually do a `dotnet build` and be as fast as it can be.

When doing proxy generation, this is obviously less than optimal. To avoid this, we added a check if there are any diagnostics errors from the compiler - if so, do not generate anything.

In our source generator we added a line at the top to avoid this:

```csharp
public void Execute(GeneratorExecutionContext context)
{
    if (context.Compilation.GetDiagnostics().Any(_ => _.Severity == DiagnosticSeverity.Error)) return;
}
```

---
title: "Orleans and C# 10 global usings"
date: "2021-08-13"
categories: 
  - "code-tips"
tags: 
  - "c#"
  - "orleans"
---

If you're using Microsoft Orleans and have started using .NET 6 and specifically C# 10, you might have come across an error message similar to this from the code generator:

```bash
  fail: Orleans.CodeGenerator[0]
        Grain interface Cratis.Events.Store.IEventLog has method Cratis.Events.Store.IEventLog.Commit(Cratis.Events.EventSourceId, Cratis.Events.EventType, string) which returns a non-awaitable type Task. All grain interface methods must return awaitable types. Did you mean to return Task<Task>?
  -- Code Generation FAILED -- 
  
  Exc level 0: System.InvalidOperationException: Grain interface Cratis.Events.Store.IEventLog has method Cratis.Events.Store.IEventLog.Commit(Cratis.Events.EventSourceId, Cratis.Events.EventType, string) which returns a non-awaitable type Task. All grain interface methods must return awaitable types. Did you mean to return Task<Task>?
     at Orleans.CodeGenerator.Analysis.CompilationAnalyzer.InspectGrainInterface(INamedTypeSymbol type) in Orleans.CodeGenerator.dll:token 0x6000136+0x86
     at Orleans.CodeGenerator.Analysis.CompilationAnalyzer.InspectType(INamedTypeSymbol type) in Orleans.CodeGenerator.dll:token 0x6000138+0x23
     at Orleans.CodeGenerator.CodeGenerator.AnalyzeCompilation() in Orleans.CodeGenerator.dll:token 0x6000009+0x9f
     at Orleans.CodeGenerator.MSBuild.CodeGeneratorCommand.Execute(CancellationToken cancellationToken) in Orleans.CodeGenerator.MSBuild.dll:token 0x6000014+0x44f
     at Microsoft.Orleans.CodeGenerator.MSBuild.Program.SourceToSource(String[] args) in Orleans.CodeGenerator.MSBuild.dll:token 0x6000025+0x45b
     at Microsoft.Orleans.CodeGenerator.MSBuild.Program.Main(String[] args) in Orleans.CodeGenerator.MSBuild.dll:token 0x6000023+0x3d
```

The reason I got this was that I removed an explicit using statement, since I'm now "all in" on the global usings feature. By removing:

```csharp
using System.Threading.Tasks;
```

... the code generator doesn't understand the return type properly and resolves it as a unknown **Task** type.  
Putting in this explicitly resolves the issue and the code generator goes on and does its thing.

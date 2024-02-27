---
title: "C# 10 - Reuse global usings in multiple projects"
date: "2021-08-13"
categories: 
  - "net"
  - "csharp"
tags: 
  - "c"
---

One of the great things coming in c# is the concept of [global using statements](https://anthonygiretti.com/2021/07/18/introducing-c-10-global-usings-example-with-asp-net-core-6/), taking away all those pesky repetitive **using** blocks at the top of your files. Much like one has with the [**\_ViewImports.cshtml**](https://docs.microsoft.com/en-us/aspnet/core/mvc/views/layout?view=aspnetcore-5.0#importing-shared-directives) one has in ASP.NET Core. The global using are per project, meaning that if you have multiple projects in your solution and you have a set of global using statements that should be in all these, you'd need to copy these around by default.

Luckily, with a bit of **.csproj** magic, we can have one file that gets included in all of these projects.

Lets say you have a file called **GlobalUsings.cs** at the root of your solution looking like the following:

```csharp
global using System.Collections;
global using System.Reflection;
```

To leverage this in every project within your solution, you'd simply open the **.csproj** file of the project and add the following:

```xml
<ItemGroup>
   <Compile Include="../GlobalUsings.cs"/> <!-- Assuming your file sits one level up -->
</ItemGroup>
```

This will then include this reusable file for the compiler.

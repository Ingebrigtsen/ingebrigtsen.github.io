---
title: "Legacy C# gRPC package +  M1"
date: "2021-09-06"
categories: 
  - "net"
tags: 
  - "c#"
  - "grpc"
---

I recently upgraded to a new MacBook with the  M1 CPU in it. In one of the projects I'm working on @ work we have a third party dependency that is still using the [legacy package of gRPC](https://www.nuget.org/packages/Grpc.Core) and since we've started using .NET Core 6, which supports the M1 processor fully you get a runtime error when running M1 native and through the Roseatta translation. This is because the package does not include the **OSX64-ARM64** version of the needed native **.dylib** for it to work. I decided to package up a NuGet package that includes this binary only so that one can add the regular package and this new one on top and make it work on the M1 CPUs. You can find the package [here](https://www.nuget.org/packages/Contrib.Grpc.Core.M1/) and the repository [here](https://github.com/einari/Grpc.Core.M1).

## Usage

In addition to your Grpc package reference, just add a reference to this package in your _**.csproj**_ file:

```xml
<ItemGroup>
  <PackageReference Include="Grpc" Version="2.39.1" />
  <PackageReference Include="Contrib.Grpc.Core.M1" Version="2.39.1" />
</ItemGroup>
```

If you're leveraging another package that implicitly pulls this in, you might need to explicitly include a package-reference to the **Grpc** package anyways - if your library works with the version this package is built for.

## Summary

Although this package now exists, the future of gRPC and C# lies with a new implementation that does not need a native library; read more **[here](https://grpc.io/blog/grpc-csharp-future/)**. Anyone building anything new should go for the new package and hopefully over time all existing solutions will be migrated as well.

---
title: "Autofac + ASP.NET Core 6 + Hot Reload/Debug = crash"
date: "2021-09-29"
---

One of the cool things in .NET 6 is the concept of hot reload if doing something like `dotnet watch run`. This extends into ASP.NET to things like Razor pages. If your like me, wants a specific IoC container - like [Autofac](https://autofac.org), you might run into problems with this and even running the debugger. The reason they behave the same is that the hot reload feature is actually leveraging edit&continue, a feature of the debugging facilities of the .NET Core infrastructure.

The problem I ran into was with .NET 6 preview 7 that it didn't know how to resolve the constructor for an internal class in one of the Microsofts Razor assemblies. When calling `MapControllers()` on the endpoints:

```csharp
app.UseEndpoints(endpoints => endpoints.MapControllers());
```

It would crash with the following:

```bash
Autofac.Core.DependencyResolutionException: An exception was thrown while activating Microsoft.AspNetCore.Mvc.Infrastructure.ControllerActionEndpointDataSourceFactory -> Microsoft.AspNetCore.Mvc.Infrastructure.DefaultActionDescriptorCollectionProvider -> λ:Microsoft.AspNetCore.Mvc.Infrastructure.IActionDescriptorChangeProvider[] -> Microsoft.AspNetCore.Mvc.HotReload.HotReloadService -> Microsoft.AspNetCore.Mvc.Razor.RazorHotReload.
       ---> Autofac.Core.DependencyResolutionException: None of the constructors found with 'Autofac.Core.Activators.Reflection.DefaultConstructorFinder' on type 'Microsoft.AspNetCore.Mvc.Razor.RazorHotReload' can be invoked with the available services and parameters:
```

My workaround for this is basically to just explicitly add razor pages, even though I'm not using it:

```csharp
public void ConfigureServices(IServiceCollection services)
{
    services.AddRazorPages();
}
```

With that in place, I was able to debug and also use hot reloading for my code.

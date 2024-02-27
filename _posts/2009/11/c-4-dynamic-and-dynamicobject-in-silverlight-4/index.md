---
title: "C# 4 dynamic and DynamicObject in Silverlight 4"
date: "2009-11-18"
categories: 
  - "net"
tags: 
  - "silverlight"
---

One of the coolest new things with Silverlight 4 is the ability to use C# 4 and in particular the dynamic keyword and infrastructure that comes along with it. The dynamic keyword allows for dynamic typing in .net, which is great for a number of reasons, but alongside it there is something called DynamicObject that makes this a whole lot more interesting for development in environments such as Silverlight.

The DynamicObject is a class one can derive from and override a number of methods, such as TryCreateInstance(), TryInvokeMember() and much more. This can be used for quite a few things, one would be for dynamically invoking services on the server or any other server avoiding the proxy creation all together. The usage from the code invoking the service would only need to call methods as if they were well known thanks to the dynamic keyword.

Working with javascript objects from C# is a second usage, one could create similar functionality for creating javascript objects and invoking methods on them. This is something that I've been working on for a while for Balder - with the next versions of FireFox and WebKit/Safari, they are introducing WebGL. Balder was built for future expansions of platforms, and this is therefor something that comes fairly easy to do thanks to the usage of dynamic and DynamicObject.

One quirk you'll run into, is when using DynamicObject in Silverlight 4 beta, is that you're not having a reference to the assembly were this is located by default, nor is it in the runtime by default. It is in fact located in the SDK. To use the DynamicObject, one needs to add a reference to an assembly called "Microsoft.CSharp.dll", it is located in the Silverlight SDK, typically located here : "C:Program FilesMicrosoft SDKsSilverlightv4.0LibrariesClient".

I'll get back with a future post on how to use dynamic for working with javascript objects - as soon as the next release of Balder is out the door.

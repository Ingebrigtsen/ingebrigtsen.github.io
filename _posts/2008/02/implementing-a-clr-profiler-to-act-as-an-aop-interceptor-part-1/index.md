---
title: "Implementing a CLR Profiler to act as an AOP interceptor - Part 1"
date: "2008-02-10"
categories: 
  - "net"
  - "aop"
  - "csharp"
---

I started looking into the profiling API this friday, thanks to a colleague of mine at work; [Fredrik Kalseth](http://www.iridescence.no/).

He started working on an AOP framework and came into my office and we discussed the possibility to use the profiler API to achieve a better result for an AOP framework. There's been a lot of studies on the subject and a couple of solutions as well, [AOP.net](http://wwwse.fhs-hagenberg.ac.at/se/berufspraktika/2002/se99047/contents/english/aop_net.html) is one of them.

The principle is very simple; intercept any calls being made to methods in a managed type and modify the execution path by calling before, after, around advices.

By hooking up the JITCompilationStarted callback that the ICorProfilerInfo2 interface provides we can do this really slick and very optimal as well. The ICorProfilerInfo2 provides us with two methods ; GetILFunctionBody and SetILFunctionBody. These can be used to get the current body of the method and then modify it and saving it back before it is JIT compiled. The advantage of doing this is that you only need to do it once per type during the lifecycle of your process, giving it a very low impact for doing this. This method does not work with assemblies that has been installed with NGEN, so adding AOP to existing framework bits might prove difficult. :)

One of the quirks with using the CLR profiling API is that you need to set a couple of environment variables in order for it to work, you need to enable profiling and then set the GUID for the COM object representing the profiler. This is something that will look very odd if you have an application you're sending out to customers. I started fiddling with the idea of how I could get about this issue and came up with a solution I found interesting; our entrypoint will not be a managed executable, but an unmanaged entrypoint that hosts the CLR and configures the environment programmatically before starting the CLR.

My prototype at the moment is very very rough, so I won't be publishing any code for this post, but sometime in the near future I will be sharing some of my findings and sourcecode. Seeing that the title of this post is postfixed with Part 1 - I've given myself the necessary pressure to create a Part 2.

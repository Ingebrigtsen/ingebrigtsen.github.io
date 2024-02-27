---
title: "Balder 0.8.8.6 is out"
date: "2010-02-08"
categories: 
  - "net"
  - "3d"
  - "csharp"
tags: 
  - "silverlight"
---

**UPDATE 8th of July 2010 : 0.8.8.7 is out - read more [here](/post/2010/07/08/Balder-0887-out.aspx).**  
  
Finally after a couple of months of hard work and polishing the code, API and performance, version 0.8.8.6 of[Balder](http://balder.codeplex.com)is out. A SampleBrowser can be found [**here**](http://localhost:8080/silverlight/Balder/20100208/TestPage.html) for viewing most of the features of[Balder](http://balder.codeplex.com).  
The features that has changed or is new are as follows:

\* Introduced Silverlight in Core, but still maintaining platform independence  
\- Using core objects directly in Xaml can now be done

\* Removed all controls in Balder.Core.Silverlight.Controls - not needed anymore

\* Introduced View namespace with IView interface and Camera implementing it

\* Viewport has View property insted of Camera

\* Moved rendering from a multithread environment to run synchronously on the CompositionTarget. It gives better performance, due to synchronization issues between all threads. Will be revisited in the future.  
  
\* New drawing routines, optimized

\* Heightmap primitive

\* Box primitive

\* Rotation, Scale on nodes

\* Cylinder primitive

\* DebugLevel is known as DebugInfo

\* Material system in place

\* Support for ReflectionMapping on materials

\* Double sided materials

\* Sprite rendering with alpha channel

\* NodesControl - datadriven nodes control with templating - In Balder.Silverlight.Controls

\* NodesStack - datadriven stacking of nodes with templating - in Balder.Silverlight.Controls

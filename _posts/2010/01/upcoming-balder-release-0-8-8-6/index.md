---
title: "Upcoming Balder release - 0.8.8.6"
date: "2010-01-27"
categories: 
  - "net"
  - "3d"
  - "csharp"
  - "gamedevelopment"
  - "optimizing"
tags: 
  - "silverlight"
---

Its been crazy weeks since I decided to pull 0.8.8.5, but it was for the better. The result is that the rendering speed and quality has gone up quite dramatically. The next version of Balder will be 0.8.8.6 and will contain at least the following: 

\- Optimized framebuffer management

\- Optimized drawing/rendering

\- Optimized lighting

\- Proper polygon clipping against the viewport 

\- Completely refactored way of handling objects, no duplication in the type hierarchy for Balder, like in 0.8.8.0.

\- New controls : NodesControl, NodesStack - similar as Canvas and StackPanel works with 2D elements in Silverlight

\- New geometry types; Box, Cylinder, Plane

\- Transparency for objects / materials

\- Introducing the concept of View, you can now create custom cameras

\- DebugLevel is no longer flag-based, but a self contained object with properties for all Debug options

\- Rendering is now synchronously - gives better framerate in most scenarios, but hogs up rendering event. Ongoing process.

Its been crazy since december with a lot of work being put into Balder and more to come. I don't have a date yet for when I'll have the release, but I'll try to push it as soon as I'm content with the result.

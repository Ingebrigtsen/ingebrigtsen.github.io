---
title: "A bug in Silverlight 1.1 Alpha Polygon Visual?"
date: "2007-05-30"
categories: 
  - "net"
  - "csharp"
tags: 
  - "silverlight"
---

I'm working on my 3D engine still and all of a sudden all my polygons didn't show up on the screen.  
After some hours of debugging I figured out what the problem was. At one point yesterday I removed some casts I had for setting the points for the polygons. The Point class in Silverlight has X and Y as double but the rendering engine does not seem to manage this at all. I have to cast it to int before I use them and remove all decimals.

This clearly can't be "by design".

---
title: "Balder 0.8.8.5 pulled - why ?"
date: "2009-12-17"
categories: 
  - "net"
  - "3d"
  - "csharp"
  - "gamedevelopment"
tags: 
  - "silverlight"
---

A couple of days ago I published a new version of Balder; 0.8.8.5. It had a bunch of improvements in it, especially when it comes to the Silverlight Control support. I had to pull the release mere hours after its release. The reason for pulling it was that I did a lot of optimizations in the rendering, or at least I thought I did. Turns out that when running on a very fast Dual core or Quad core computer, it was faster - but on slower machines, it turned out to be quite slow. 

Instead of reverting the entire optimization, I've decided to actually get the performance up quite a bit. I've been working on a new rendering pipeline that would increase the performance dramatically, so no time like the present.

The biggest change however with the release was the Xaml support. In the [Development branch over at GitHub](http://github.com/einari/Balder/tree/Development) you will find source code with the rendering pipeline being the same as in version 0.8.8.0, but with all the new Xaml support. So if you can't wait for the optimizations and want to get your Xaml right from the start - you should go pull the latest on the Development branch and compile the binaries yourself. In fact, it should be fairly simple to do it, just download it and run the build.cmd file from a command prompt and it will output a Drop directory with all the binaries in it.

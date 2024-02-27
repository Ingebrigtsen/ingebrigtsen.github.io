---
title: "Balder 0.8.8.5 Release is out"
date: "2009-12-15"
categories: 
  - "net"
  - "3d"
  - "balder"
  - "gamedevelopment"
tags: 
  - "silverlight"
---

**UPDATE 8th of July 2010 : 0.8.8.7 is out - read more [here](/post/2010/07/08/Balder-0887-out.aspx).**  
  
**UPDATE, 16th of December 2009 : Release was pulled due to issues with rendering. New release will be pushed soon.**

Its that time again, yet another release of Balder. You're probably thinking - whats going on? Pushing releases close to every week.

Well, this release had to be pushed out fast, the reason being that a couple of days after the previous release I realized that the Xaml support introduced felt good while using it, but clearly had its limitations and also maintainability issues when working with the library.

In the previous release I introduced the Xaml support as Controls in the Balder.Silverlight assembly, which seemed like a fair place to have it, seeing that Xaml/Controls are a very specific platform option that Silverlight supports and should not be present in Core. Problem with that was that we now had two object hierarchies to maintain, one just reflecting most of the properties already found in Core and doing some crazy magic to maintain these hierarchies. Needless to say, this approach is very error prone and hard to maintain.

**Dependency Properties**

**The main reasons for not pushing the Control support into Core was the fact that I didn't want DependencyProperties leaking into it all over the place and not wanting types to derive from DependencyObject or any other Silverlight specific type. So what I came up with is to make the types in question partial and implement the Silverlight specifics in a .Silverlight.cs file - which then could be skipped for other platforms. Then for DependencyProperties, I wrapped everything up in a generic Property type that has a Specific Silverlight implementation that again can change for other platforms.**

The result is a more maintainable codebase, and a better experience when using it.

**Speedups**

Another reason for pushing for another release was the fact that I did some heavy optimizations. Earlier when doing optimizations, I worked mostly with Silverlight 2 and Silverlight 3 Beta. For SL2 I created a RawPngBufferStream, since no WriteableBitmap was available there, and for SL3 beta, the WriteableBitmap was quite different than what the final RTW version had going for it. Long story short, I ended up with a multithreading scenario that gave quite a performance boost.

After looking at this for quite some time, I found that it would be better to have multiple WriteableBitmaps and do triplebuffering with these and use different threads for different purposes (Clearing, Rendering, Showing). Turns out that this was quite efficient, only problem was that synchronization turned out to be a bit of a problem. So I did a test with doing all the operations synchronously in the CompositionTargets event, and it gave a serious performance boost. That combined with some optimized ways of clearing surely seemed to do wonders.

The new release is available from[here](http://balder.codeplex.com/Release/ProjectReleases.aspx?ReleaseId=37298).

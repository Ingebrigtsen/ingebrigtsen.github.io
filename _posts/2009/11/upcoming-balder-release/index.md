---
title: "Upcoming Balder release"
date: "2009-11-17"
categories: 
  - "net"
  - "balder"
tags: 
  - "silverlight"
---

My blog has been dead silent lately. The reason for this is that I'm quite busy getting a new release of Balder out the door. 

For the upcoming release, which will be named 0.8.8 - still in Alpha mode, I've focused a lot on code quality and getting some debt paid back from the "early" days when I started the project. But fear not, there is also a bunch of new features coming.

To mention a few things:

\- Mouse interaction with objects, an event model

\- Simpler initialization - in fact, there is none

\- A better declarative Xaml model that replicates the object model found in Core - they are separated, due to cross-platform support that will come.

\- The ability to have more than one displays - great for Silverlight when you want to have multiple 3D models on the same page, but not interacting with each other

\- Command support - so one can actually do MVVM style 

\- Debug information - bounding spheres 

 In addition there is tons of bug fixes, such as:

\- Coordinate system was out of wack. Positive Y was pointing downards, now pointing up

\- Initialization bugs that occured from time to time

\- Speedups - rendering pipeline has optimized a tad, and the initialization phase as well.

There are a few breaking changes there as well in the API - its gotten a bit cleaner and more concise.

A detailed description of all this will come in the release notes.   Keep your ears to the ground, cool stuff will come soon.

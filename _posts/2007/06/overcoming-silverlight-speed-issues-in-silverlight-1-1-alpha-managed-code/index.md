---
title: "Overcoming Silverlight speed issues in Silverlight 1.1 Alpha (Managed code)"
date: "2007-06-24"
categories: 
  - "net"
  - "csharp"
tags: 
  - "silverlight"
---

I've been close to ranting lately about my issues with speed for Silverlight 1.1.. Shame on me, a little bit.. :)   

I have now refactored my 3D a bit and I'm now experiencing increased speed. The main problem is that if you want to runtime generate the visuals for every frame there is too much marshalling going on between the managed runtime and the core presentation engine of Silverlight. After a couple of days of real frustration I got struck by lightning (Silver ofcourse). I ran in to my livingroom from playing with one of my kids and grabbed my laptop and ran outside again to "play"...   The answer is : Generate the XAML and marshal only once! This can be achieved in several ways, I chose to create myself a user control that I dynamically create and add to my Canvas every frame (only one), within this user control I generate the XAML needed and pass it along to the InitializeFromXaml() method found in the base class Control.

This resulted in the engine using around 10 milliseconds per frame on my test object. It used between 30 and 40 milliseconds before. (My machine : Dell Latitude D820 Laptop, running Intel Core Duo 2.33 Mhz)

It is kind of obvious that this is the result. Since the managed environment is decoupled in the manner it is, it will make sense to marshal as little as possible.

I've implemented this into the Balder engine, if you want to have a look at how it is done, download the source at Codeplex ([http://www.codeplex.com/Balder](http://www.codeplex.com/Balder)). PolyControl.cs and Face.cs is in this writing moment the magicians. This will change soon when I clean up it's act.

Check out the latest version, optimized :  
[http://www.dolittle.com/Silverlight/3D\_Optimized/TestPage.html](http://localhost:8080/silverlight/3D_Optimized/TestPage.html)

(There is not a lot of added features, just optimizations and behind-the-scenes stuff...)

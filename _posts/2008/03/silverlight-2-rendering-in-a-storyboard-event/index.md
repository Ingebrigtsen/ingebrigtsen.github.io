---
title: "Silverlight 2 - rendering in a Storyboard event"
date: "2008-03-30"
categories: 
  - "csharp"
  - "gamedevelopment"
tags: 
  - "silverlight"
---

During my "port" from Silverlight 1.1 to 2 of the [Balder](http://www.codeplex.com/Balder) game engine I started working on last year, I've ran into a couple of gotchas. When I was optimizing the engine I discovered that Silverlight 1.1 had a speed issue when working with any Visual from managed code and adding it to the rendering pipeline of Silverlight. There was a very large interop overhead involved and I changed the rendering strategy to use a singleton Control that all primitives was added to and this would convert them all to Xaml and call the InitializeFromXaml() on itself. This proved to give a serious boost in performance.

This same approach for Silverlight 2 proved to be a killer for the engine all together. It turns out that doing this from the Storybard completed event that the engine was built around to serve as the "rendering thread", is really bad. It's all OK as long as you don't spend more time in the completed event than you've set the duration property to for the storyboard you're using. Default the storyboard is set to 0, but for Balder we set this to 20 milliseconds, which is just the game programmer in me coming to life; 20ms = 50 Hz = the refresh rate of the PAL standard (50 field changes a second, that is).

So, what to do with this..  Well. To be honest, I haven't figured it out yet. I'm still looking into it. Any thoughts on the matter can be emailed me at einar\_at\_dolittle.com. One of the things I will be looking into is to revert to rendering by creating the visuals programatically and adding them from managed code, I guess this won't solve the entire problem since the Storyboard implementation seems to be the one with a problem here, or at least the usage of it. After all it was not designed for the purpose of doing what I'm trying to do. :)

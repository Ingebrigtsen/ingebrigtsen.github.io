---
title: "Balder 0.8.8.7 out"
date: "2010-07-08"
categories: 
  - "net"
  - "3d"
  - "balder"
tags: 
  - "silverlight"
---

  
I promised a release last month, but I had to do surgery and got a bit sidetracked with feeling sorry for myself being in pain. Anyhow, all is good and finally got the release out the door.

Its been almost 6 months since the last release. So this better be good. :)

The following are as complete a list I could compile of whats new and improved, btw. you'll find the new release [here](http://balder.codeplex.com/releases/view/48503 "Balder 0.8.8.7"). A new version of the SampleBrowser can be found [here](http://dl.dropbox.com/u/5342359/Balder/SampleBrowser/TestPage.html "Balder SampleBrowser").

  
**Performance improvements**

- Scanline renderers has improved quite a bit  
    
- Lighting calculations  
    
- NodesControl  
    
- Startup improvements  
    
- Content caching - loading the same content twice will only clone existing in cache
- Color class - conversion plus operations are rewritten, introduced ColorAsFloats  
    
- Dependency properties now represented as Property with caching in it

**Bugfixes**

- World matrix + general matrix fixups  
    
- NodesControl fixed, one can now nest these, plus a massive performance improvement during databinding using the ItemsSource.  
    
- Mouse events actually working - 0.8.8.6 had quite a few bugs with this, they are pixel perfect  
    
- PivotPoint fixed - working recursively  
    
- Completely rewritten rendering pipeline for stability, expandability and performance  
    
- Memory leaks in mouse event handling  
    
- Fixed Asset handling system - had a few bugs in it. Still has to revisit this.  
    
- Parsing of ASE files now use invariant culture all over the place. Had a couple of places it didn't.

**New features**

- Manipulation events on objects, implemented using mouse events.  
    
- They contain more detailed information about the object being manipulated, such as material information. Also, the events are not like the mouse events, they actually contain delta information about the manipulation occuring.  
    
- Tooltips, there is a property on all objects called Tooltip, you can create tooltips as you please, as you'd do with the TooltipService in Silverlight for other objects. The TooltipService will not work, hence the specialized property for it.  
    
- DirectionalLight - basic directional lighting  
    
- ViewLight - lighting that is "attached" to the camera/view  
    
- ArbitraryHeightMap - heightmap that can have its corners placed arbitrarily  
    
- SmoothingGroups implemented  
    
- New ASE parser - supporting multiple objects, world matrix. Also a lot faster.  
    
- Ring - geometry type  
    
- Started implementation of a ChamferBox - very basic at this point  
    
- Passive Rendering, will draw in wireframe during interaction and flip to full rendering when interaction has stopped. When no interaction, it will not render, Balder goes idle.  
    
- Pausing - for pausing everything.  
    
- Grabbing a frame from the Display can now be done  
    
- Container for renderable nodes - has its own world coordinate system that can be manipulated, lights can't be placed in this container.  
    
- BubbledEvent system for events that needs to bubble up in the hierarchy  
    
- Messenger system for decoupling and stability  
    
- IGeometryDetailLevel - basically only used for Passive rendering at this point  
    
- Geometry artifacts such as Face, Vertex and so forth are now classes and has been generalized. Its now up to the implementing platform to create specialized versions of them.  
    
- Removed MEF and introduced a specialized TypeDiscoverer instead.

**Development environment**

- Changed to Visual Studio 2010  
    
- Build server up and running with a more complete Balder.build file for continuous integration

**Breaking changes**

- IGeometryContext does no longer hold the geometry data directly, introduced something called IGeometryDetailLevel. One can get the full detail level, which is the default (and only for now), by calling the method GetDetailLevel() on the IGeometryContext. In addition, any Geometry has a property called FullDetailLevel for convenience.  
    
- Mouse events has been specialized - they are named the same as one is used to from Silverlight, but the MouseEventArgs has been "duplicated" in Balder.Core.Input. The reason for this is that the Silverlight class for this is sealed and does not have a public constructor, and the mouse event handling needs to handled in a special manner in Balder. Also, the events are now bubbled as well through the geometry hierarchy.

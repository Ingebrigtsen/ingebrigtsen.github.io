---
title: "Balder 0.8.8.8 is out"
date: "2010-07-26"
---

Its only been 2 weeks since the last release, but a new release of Balder is ready.  
It can be found [here](http://balder.codeplex.com/releases/view/49650).

Here are the highlights :  

- Major breaking changes in namespace : Balder.Core.\* is now Balder.\*, Balder.Silverlight.Animation is now Balder.Animation.
- Brought everything down from 2 DLLs to 1 DLL - Balder.dll, it contains everything
- Swapped to the latest version of NInject - internally a lot of changes had to be done
- Introducing Windows Phone 7 support in WP7 Silverlight Application with Hardware Accelarated graphics
- Skybox support - property on Game and Viewport
- Started working on iOS (iPhone/iPad) version
- Started working on Xna version
- Started working on Desktop version
- One step closer to desig-time support, not quite there yet - hang in there
- Shading support for textured models (both flat and gourd)
- Lighting has been fixed a lot for OmniLight - takes into account the light color and the material information, still some work ahead on this subject though.
- Some bug fixes in ASE loader + tests
- Cleaned up some samples in SampleBrowser
- Introduced IMap interface for Maps instead of tying everything to Image for DiffuseMap and ReflectionMap on Material. One can now implement any map types - but dimensions must be power of 2.

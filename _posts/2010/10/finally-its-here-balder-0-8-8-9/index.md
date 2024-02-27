---
title: "Finally, its here...  Balder 0.8.8.9"
date: "2010-10-07"
---

Ever since I started blogging and talking about this release back in August, I have simply not had the time to get it out the door. Always a little something I wanted to fix, or my daytime job getting in the way. Anyways, finally managed to get it out the door today. Pick it up at the [Balder site](http://balder.codeplex.com).

The following list are the changes :

- Perspective corrected texture mapping
- perspective corrected Z buffering
- Dual texture support with mixing
- Enhanced material support
- Shaded textures, flat + gouraud
- Rewritten lighting code for rendering
- New skybox, utilizing perspective projection in Silverlight
- Bilinear filtering
- Performance enhancements
- Subpixel rendering
- Multiple games in one page
- Clearer exceptions
- InstancingNodes - faster bindable solution
- Extensible FileLoader support - one can load from anywhere
- ChamferBox primitive type
- Vertex coloring support - reads vertex colors from ASE files
- Multi/Sub material rewritten - faces no longer has Material, but a Id reference instead
- Wireframe support for Materials
- Statistics added
- Shine + ShineStrength for materials added
- Color manipulation optimized, using integers
- Smoothing group fix for primitives Cylinder and Ring
- Optimized heightmap
- CLUT system removed - too slow
- Frustum clipping of objects
- Matrix optimized - going for the solution most use, public fields instead of array as before
- Started implementation of MipMap levels for textures
- Rewritten texture system - introducing the concept of map
- More details on ManipulationEvents
- Optimizations for Windows Phone 7
- Added more unit tests
- Optimized mouse intersection with objects

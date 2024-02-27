---
title: "Balder - Upcoming release"
date: "2010-05-12"
categories: 
  - "3d"
  - "balder"
  - "csharp"
tags: 
  - "silverlight"
---

Its been some 4 months since the last official binary drop of Balder and its just about time to get a new version out. The reason for the "hold up" is that I've been quite busy with working 2 jobs; my daytime job and Balder related freelance work at night. Combining that with having a family of 2 kids and a wife, there simply hasn't been any time left get binaries out there. 

But, as part of the work that I've been doing freelance, Balder has gotten a lot of improvements. Among these are the following : 

\- Further optimizations in the rendering pipeline

\- Rewritten NodesControl, speed up and more capable

\- General cleanups

\- More Xml comments for documentation purposes

\- Retrofitted some unittests

\- Mouse events working properly

\- Tooltip for Nodes

\- Arbitrary Heightmap - corners of heightmap can be placed anywhere

\- New AseLoader with more support than before (Smoothings groups, more objects, more material details, colors++)

\- Rewritten AssetLoader system

\- Fixed bugs with primitives

\- More samples in SampleBrowser

\- Visual Studio 2010 solution + project files

\- Optimized lighting

\- Added ViewLight - lighting relative to view, basically directional lighting

\- Passive Rendering, making the rendering halt unless properties are changed on any object in the scene

\- Content caching for faster startups

\- A lot of code cleanups for decoupling the platform even more

\- Material detection for mouse events 

And a whole bunch of other improvements.

The only thing left before a release can be done is to tie together some lose ends and fix a couple of bugs - then its ready for deployment. I'll be sure to post about all the new features and how they can be used in a post when the release is ready.

The next iteration will focus more on increasing code quality, more cleanups, get more documentation up and running, continuous integration server up and running and things that will improve further development on the project.

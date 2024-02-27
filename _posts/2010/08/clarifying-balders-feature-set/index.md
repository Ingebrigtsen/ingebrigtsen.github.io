---
title: "Clarifying Balders feature set"
date: "2010-08-15"
categories: 
  - "net"
  - "3d"
  - "balder"
  - "csharp"
tags: 
  - "silverlight"
---

Hopefully I'm not forgetting anything (probably am) - but below is a clarification of what features Balder has.

##   
Coordinate system

Balder uses a left-handed coordinate system - currently there is no way to change this, but there are plans for opening up for any coordinate system.

## Nodes

- Interaction - one can enable interaction on any nodes and they can be interactively manipulated during runtime
- Position coordinates
- Rotation coordinates, in angles for each axis
- Scale coordinates
- Hierarchical rendering of nodes

## Scene

- A Scene contains objects, any Balder object implementing the interface INode; Lights, geometries, sprites

## Viewport

- Defines a clipping area on the screen, coordinate relative to its container

## View

- Camera
    - Position
    - Target
    - Field Of View

## Sprites

- Flat image based objects that exist in 3D space - they are rendered along with other 3D content and positioned and scaled correct according to their 3D space position.

## Geometries

- Box - simple box with dimensions
- Cylinder - top and bottom dimensions can be specified independently
- Ring - inner and outer circle dimensions can be specified independently
- ChamferBox - simple box with a chamfer segment
- HeightMap - a plane that consist of a set of vertices (points) that can be manipulated by its height
- ArbitraryHeightMap - a derivative of HeightMap, but its plane is arbitrary
- Mesh - a complex mesh which can be loaded from a file

## Other objects

- Container - not renderable itself, but can contain any Node in it - hierarchically

## Assets

All data loaded from disk or elsewhere is known as Assets. There are Asset loaders for file types, you can even create your own Asset loaders quite easily. For Silverlight, there exist today a limitation which only allows loading of assets found in the XAP file - meaning that any asset added to the project must be a Resource in the XAP file. This is being worked on and will in a future release be more flexible.

- ASE file - supports 90% of the Autodesk Ascii Scene Export format for 3D objects
- Experimental support for Demoniak3D format
- JPEG, PNG for Images

Assets are cached in a content manager, which means that if you load the same asset twice, it will clone the first one.

## Lighting

- OmniLight - non directional light, emits light in all directions
- DirectionalLight - emits light in a specific direction, without any starting point or ending point
- ViewLight - view dependent light that will always emit from the view and into the Scene

## Rendering

- Z buffered rendering
- Flat shaded - single color faces
- Gouraud shaded - color can be specific on each corner of a triangle
- TextureMapping - perspective corrected, gouraud shaded.
- Lines
- Passive rendering mode - renders only when there are changes
- Bilinear filtering
- Face-culling - do not render faces/triangles facing away, can be controlled via Materials
- Frustum-culling - objects not inside view will not be rendered - increases performance a lot

## Materials

- Diffuse color
- Diffuse map
- Ambient color
- Specular color
- Reflection map
- Opacity for the different maps can be specified

## Imaging

- Supports PNG and JPEG
- For textures, you must use images with dimensions being power of 2 (2,4,8,16,32,64,128,256,512,1024 and so on)

## Input

- For Silverlight; mouse events are supported (MouseEnter, MouseLeave, MouseMove, MouseLeftButtonDown, MouseLeftButtonUp)
- Manipulation events for all Nodes to make it easier to interact with objects

## Debug visualization

- Bounding information
- Show vertices

## Statistics

- Rendering timing
- Amount of faces being rendered
- Amount of objects being rendered

## Execution

- Actor system with statemachine for actors in the scene
- Game - base class for any game

## Silverlight / Windows Phone 7 specifics

- Full XAML support - you can declaratively do everything that Balder can do in XAML
- Specific CoordinateAnimation that can be used in storyboards for animating properties on Nodes
- NodesControl / NodesStack - databindable controls that be bound to any source with NodeTemplate to specify its representation on screen. Similar to ItemsControl found in Silverlight.

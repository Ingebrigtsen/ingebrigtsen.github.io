---
title: "Extensions and Helpers for Silverlight and WPF"
date: "2009-07-11"
categories: 
  - "net"
  - "csharp"
  - "wpf"
tags: 
  - "silverlight"
---

Earlier I posted about some extensions I did for Silverlight handling INotifyPropertyChanged and helpers for DependencyProperties. Recently I've had a couple of request to release a downloadable source with samples of their use. Since the original posts (found [here](/post/2009/01/09/DependencyProperties-why-art-though-%28so-much-hassle%29.aspx) and [here](/post/2008/12/11/INotifyPropertyChanged-revisited.aspx)), I've refined them a little bit and worked out some quirks that was left in the originals.

So, why should one use these kind of extensions and what do they solve?

INotifyPropertyChanged and creating DependencyProperties rely on the usage of literals. When for instance notifying the PropertyChanged event with a change on a particular property, the argument one passes in is the literal holding the name of the property. This is bad for at least a couple of reasons:

- Refactoring goes out the window - renaming the property means renaming the literals by hand
- Obfuscation - if one were to obfuscate the code, literals will still stay the same but your propertynames will change - your code is broken

I've wrapped it all in a nice download with both a Silverlight and a WPF version of the code (actually pretty much the same code, you'll find #if(SILVERLIGHT) #else #endif statements where specifics are needed). Also in the download, you'll find a Silverlight sample with a usercontrol implementing a dependencyproperty and a data object using the INotifyPropertyChanged extensions. In addition to this, there are a few other nifty helper classes and extensions for other aspects of both Silverlight and WPF development. Hope you'll find it handy.

The download can be found [here](/Downloads/DoLittle.Common.zip).

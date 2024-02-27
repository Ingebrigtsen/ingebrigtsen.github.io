---
title: "Silverlight speed issues"
date: "2007-06-23"
categories: 
  - "net"
  - "csharp"
tags: 
  - "silverlight"
---

I posted earlier about Silverlight rendering being very slow. I've been digging deep inside the Silverlight runtime to figure out what and why there should be issues. Drawing issues is only half the problem, maybe even not a problem at all. Whenever you change a property that is a DepedencyProperty there is a lot of code involved. For the 3D engine I'm working on this is very critical, we change a lot of dependency-properties all the time. The main problem is that in order for a visual to get updated with any changes you need to actually set the property even though it should be sufficient just modifying a property on the type of the top level property (did that sentence make any sence.:) ) .

A good example of what I'm talking about is the Color property for a polygon. I just need to update the R,G,B properties on the polygon, but in order for the polygon to get the changes I need to set the Color property and that involves a lot of code behind the scenes in Silverlight in order to do that. Looking at architectural overview at Microsoft, it sort of says it all : [http://msdn2.microsoft.com/en-us/library/bb404713.aspx](http://msdn2.microsoft.com/en-us/library/bb404713.aspx). There is marshalling involved between the presentation Core and the .net Runtime that is very costy. It makes sense that it is like this, the presentation core has to be running natively seeing that it is cross platform.

---
title: "Performance Profiling in Silverlight"
date: "2008-10-09"
---

One of the things that is missing out of the box when developing Silverlight applications, is the ability to analyse performance. The performance monitoring tools in VS2008 does not support Silverlight. [Seema Ramchandani](http://blogs.msdn.com/user/Profile.aspx?UserID=35574) at Microsoft has created a [guide](http://blogs.msdn.com/seema/archive/2008/10/08/xperf-a-cpu-sampler-for-silverlight.aspx) to two tools to aid with this; xperf and xperfView. These tools were previously only available internally to Microsoft, but is now available for everyone.  
  
The xperf tool is a command line tool that be used to run the Silverlight application for collecting performance information. With xperfView you can take the output and get performance details from the xperf tool like this:  
  
![](images/moz-screenshot1.jpg)  
  
Thanks to [Stefaan Rillaert](http://stefaan.wordpress.com/) for sending me this link.

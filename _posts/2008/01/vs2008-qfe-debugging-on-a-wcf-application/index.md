---
title: "VS2008 QFE Debugging on a WCF application"
date: "2008-01-17"
categories: 
  - "net"
  - "csharp"
---

I got all excited today and downloaded and instaled [VS2008 QFE](https://login.live.com/login.srf?wa=wsignin1.0&rpsnv=10&ct=1200575156&rver=4.0.1534.0&wp=MBI_SSL&wreply=https:%2F%2Fconnect.microsoft.com%2FVisualStudio%2FDownloads%2FDownloadDetails.aspx%3FDownloadID%3D10443%26wa%3Dwsignin1.0&lc=1033&id=64416) (.net source code) and enabled debugging according to [Shawn Burke's blog](http://blogs.msdn.com/sburke/archive/2008/01/16/configuring-visual-studio-to-debug-net-framework-source-code.aspx) and fired up a WCF server application I'm working on. The server is using the ServerHost class for hosting it. Much to my surprise I kept getting an ConfigurationErrorsException with the message : "This element is not currently associated with any context". The application hadn't changed for a couple of days and I have no configuration file as I define everything programmatically. The only thing I had done was to install QFE and enable Debugging.

Turns out that the "Enable just my code" option that I turned off to enable QFE debugging caused this. I haven't really bothered to figure out why yet, just thought I'd blog the incident straight away.

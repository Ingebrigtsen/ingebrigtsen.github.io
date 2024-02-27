---
title: "MediaPlayer Content plugin for Windows Live Writer"
date: "2007-07-16"
categories: 
  - "net"
  - "csharp"
---

I've just sort of finished a simple plugin for adding a MediaPlayer object to blogs from the Windows Live Writer.  
In order to use the plugin you must enable the object tag, so they won't get scrubbed during rendering.

For Community Server this is achieved by going into the communityserver.config file (residing in the Web directory of your Community Server installation) and going to the <markup> section; here you can add the object tag as a trusted tag type. **Remember that you're doing that on your own risk!!!!**

Anyways..  Download the file to play around with it.  I've also attached the source for it.

**Important :  
**To install it you have to copy it to the Plugins directory of Windows Live Writer, typically c:Program FilesWindows Live WriterPlugins.

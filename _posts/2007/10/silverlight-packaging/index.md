---
title: "Silverlight packaging"
date: "2007-10-31"
tags: 
  - "silverlight"
---

One of the things I'm really missing from Silverlight as it is today is the ability to package an entire application with all it's artifacts (xaml, binary/DLLs, javascripts, PNG files - etc.. etc..) in a single archive and reference this in an ASP.net application.

I've been working with a solution that enables this feature through packaging applications as ZIP archives. The solution is very simple; create an HTTP handler that responds to this in a specific directory and unzips the archives on the fly and preferably cache them somewhere on the disk for speedy lookups later.

Follow my blog and I'll get back to you on the subject when I have finished the code!

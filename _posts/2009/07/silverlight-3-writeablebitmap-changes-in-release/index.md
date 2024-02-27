---
title: "Silverlight 3 - WriteableBitmap changes in release"
date: "2009-07-14"
categories: 
  - "net"
tags: 
  - "silverlight"
---

I guess most of you already know that Silverlight 3 is out. Exciting times. Version is truely a remarkable release in the history so far of Silverlight. With it there are some changes in the API for you who have been working the the beta releases of Silverlight 3. The most noticable for me was the WriteableBitmap class. The WriteableBitmap can be used if you want to draw things yourself onto a surface that can be rendered by Silverlight.

The first change lies with the constructor, previously it had an argument that told what type of pixelformat it should be in, this is now gone.

Secondly you no longer have to lock and unlock in order to write to it, you simple index the new property called Pixels and after you're done you call invalidate. This makes a lot more sense.

Third thing I notice is the SetSource() method, which I never seen before. I haven't had the chance to check it out yet, but I guess you don't have to be a rocket-scientist to know that it has the ability to take a stream source and stream the pixels into the bitmap. 

All these changes are something that [Balder](http://balder.codeplex.com) will have great benefit from, initial testing seems that performance has gone up quite a bit and I believe there might be something to gain from streaming the pixels instead of the way we are doing things internally in Balder today. Updates has been made to Balder to work with the release version of Silverlight 3 - new release will be posted on Codeplex shortly.

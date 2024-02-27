---
title: ".net (generic) type caching"
date: "2008-05-21"
categories: 
  - "net"
  - "csharp"
  - "clr"
  - "optimizing"
---

The runtime for .net has a type caching mechanism that is really great. Every so often I write code where you need specific data based upon a type. Normally one tend to revert to a Dictionary with Type as the key and the datatype as the valuetype for the generic parameters.

Typically:

[![image](images/54af7125539d-netgenerictypecaching_8a26_image_thumb_1.png)](http://localhost:8080/wp-content/2012/07/54af7125539d-netgenerictypecaching_8A26_image_4.png)

This will then rely on he dictionary and its implementation. Sure, it is not a bad solution, but there is a more effective and last but not least; cooler way of going about achieving the same effect:

[![image](images/54af7125539d-netgenerictypecaching_8a26_image_thumb_3.png)](http://localhost:8080/wp-content/2012/07/54af7125539d-netgenerictypecaching_8A26_image_8.png)

The beauty of this is that the static constructor will run once per type and one can do type specific stuff in the constructor

The two implementations above lack a lot, so lets go for a more complete sample:

[![image](images/54af7125539d-netgenerictypecaching_8a26_image_thumb_4.png)](http://localhost:8080/wp-content/2012/07/54af7125539d-netgenerictypecaching_8A26_image_10.png)

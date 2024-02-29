---
title: "Persistent Objects Part 3"
date: "2004-08-18"
categories: 
  - "csharp"
---

The one thing I find missing in other persistent object implementations is the ability to persist data from any kind of source.

You could easily persist data from a Web Service, a dataset, other functionality found in your business logic. Just about anything, actually.

If you look at your persistent objects a bit like facade objects, this would make a lot of sense.

For instance :

```csharp
[Persistent]
public class MyPersistentObject : PersistentObject
{
     [PersistentWebService("<uri for webservice>","get method","set method")]
     public string Name 
     {
          get { return string.Empty; }
          set {}
     }
}
```

The DoLittle Persistency project found at GotDotNet is going in that direction. The implementation uses a PersistencySource and goes through a manager to get the Default source. The default behavior can easily be changed by implementing your own source. This source could for instance get data from a file, if that is what you are trying to accomplish.

It's a world of opportunities.. :)

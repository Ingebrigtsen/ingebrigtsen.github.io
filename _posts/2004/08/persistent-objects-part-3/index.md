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

<table style="background-color:#f2f2f2;border:#e5e5e5 1px solid;" border="0" width="100%" cellspacing="0" cellpadding="0"><tbody><tr style="vertical-align:top;line-height:normal;"><td style="width:40px;text-align:right;"><pre style="border-right:#e7e7e7 1px solid;font-size:11px;margin:0;color:gray;font-family:courier new;padding:2px;">1
2
3
4
5
6
7
8
9</pre></td><td><pre style="margin:0;padding:2px 2px 2px 8px;"><span style="font-weight:normal;font-size:11px;color:black;font-family:Courier New;background-color:transparent;">[Persistent]
<span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">public</span> <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">class</span> MyPersistentObject : PersistentObject
{
     [PersistentWebService(<span style="font-weight:normal;font-size:11px;color:#666666;font-family:Courier New;background-color:#e4e4e4;">"&lt;uri for webservice&gt;"</span>,<span style="font-weight:normal;font-size:11px;color:#666666;font-family:Courier New;background-color:#e4e4e4;">"get method"</span>,<span style="font-weight:normal;font-size:11px;color:#666666;font-family:Courier New;background-color:#e4e4e4;">"set method"</span>)]
     <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">public</span> <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">string</span> Name {
          get { <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">return</span> <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">string</span>.Empty; }
          set {}
     }
}</span></pre></td></tr></tbody></table>

The DoLittle Persistency project found at GotDotNet is going in that direction. The implementation uses a PersistencySource and goes through a manager to get the Default source. The default behaviour can easily be changed by implementing your own source. This source could for instance get data from a file, if that is what you are trying to accomplish.

It's a world of opportunities.. :)

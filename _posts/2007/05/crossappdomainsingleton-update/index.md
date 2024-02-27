---
title: "CrossAppDomainSingleton - Update"
date: "2007-05-30"
categories: 
  - "net"
  - "csharp"
---

I forgot a couple of very essential things in my [last post about a singleton that lives across appdomains](http://ingebrigtsen.blog/2007/05/18/cross-appdomain-singleton/).

When accessing a remote object using remoting, like I did with the singleton implementation, the remoting system obtains a lease for the object. The lease period is implemented in the MarshalByRefObject class through a method called InitializeLifeTimeService(). A singleton like the one we wanted to achieve needs to live forever, therefor you need to override the InitializeLifeTimeService() method and always return null. Returning null means that it should live forever (more details can be at [http://msdn.microsoft.com/msdnmag/issues/03/12/LeaseManager/default.aspx](http://msdn.microsoft.com/msdnmag/issues/03/12/LeaseManager/default.aspx))

<table style="background-color:#f2f2f2;border:#e5e5e5 1px solid;" border="0" width="100%" cellspacing="0" cellpadding="0"><tbody><tr style="vertical-align:top;line-height:normal;"><td class="" style="width:40px;text-align:right;"><pre style="border-right:#e7e7e7 1px solid;font-size:11px;margin:0;color:gray;font-family:courier new;padding:2px;">1
2
3
4
5
6
7
8
9
10
11
12
13</pre></td><td class=""><pre style="margin:0;padding:2px 2px 2px 8px;"><span style="font-weight:normal;font-size:11px;color:black;font-family:Courier New;background-color:transparent;">&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-weight:normal;font-size:11px;color:green;font-family:Courier New;background-color:transparent;">/// &lt;summary&gt;</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-weight:normal;font-size:11px;color:green;font-family:Courier New;background-color:transparent;">/// Override of lifetime service initialization.</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-weight:normal;font-size:11px;color:green;font-family:Courier New;background-color:transparent;">/// </span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-weight:normal;font-size:11px;color:green;font-family:Courier New;background-color:transparent;">/// The reason for overriding is to have this singleton live forever</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-weight:normal;font-size:11px;color:green;font-family:Courier New;background-color:transparent;">/// &lt;/summary&gt;</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-weight:normal;font-size:11px;color:green;font-family:Courier New;background-color:transparent;">/// &lt;returns&gt;object for the lease period - in our case always null&lt;/returns&gt;</span>
&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">public</span> <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">override</span> <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">object</span> InitializeLifetimeService()
&nbsp;&nbsp;&nbsp;&nbsp;{
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-weight:normal;font-size:11px;color:green;font-family:Courier New;background-color:transparent;">// We want this singleton to live forever</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-weight:normal;font-size:11px;color:green;font-family:Courier New;background-color:transparent;">// In order to have the lease across appdomains live forever,</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-weight:normal;font-size:11px;color:green;font-family:Courier New;background-color:transparent;">// we return null.</span>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">return</span> <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">null</span>;
&nbsp;&nbsp;&nbsp;&nbsp;}</span></pre></td></tr></tbody></table>

In addition I've made it all threadsafe. So look at the attachment for this post instead..

On a second note; if you for instance expose an event in your singleton and any subscribers to that event exists in another AppDomain, you might want to keep in mind that you should probably inherit from MarshalByRefObject and override the IntializeLifeTimeService() method and return null there as well. Otherwize you might end up having a broken lease in the delegate added to the singleton.

The updated C# file for this can be found [here](http://localhost:8080/wp-content/2014/10/crossappdomainsingleton_improved1.zip).

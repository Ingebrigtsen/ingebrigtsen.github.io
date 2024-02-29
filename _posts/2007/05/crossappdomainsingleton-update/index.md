---
title: "CrossAppDomainSingleton - Update"
date: "2007-05-30"
categories: 
  - "net"
  - "csharp"
---

I forgot a couple of very essential things in my [last post about a singleton that lives across appdomains](/2007/05/18/cross-appdomain-singleton/).

When accessing a remote object using remoting, like I did with the singleton implementation, the remoting system obtains a lease for the object. The lease period is implemented in the MarshalByRefObject class through a method called InitializeLifeTimeService(). A singleton like the one we wanted to achieve needs to live forever, therefor you need to override the InitializeLifeTimeService() method and always return null. Returning null means that it should live forever (more details can be found [here](http://msdn.microsoft.com/msdnmag/issues/03/12/LeaseManager/default.aspx))

```csharp
  /// <summary>
  /// Override of lifetime service initialization.
  /// 
  /// The reason for overriding is to have this singleton live forever
  /// </summary>
  /// <returns>object for the lease period - in our case always null</returns>
  public override object InitializeLifetimeService()
  {
    // We want this singleton to live forever
    // In order to have the lease across appdomains live forever,
    // we return null.
    return null;
  }
```

In addition I've made it all threadsafe. So look at the attachment for this post instead..

On a second note; if you for instance expose an event in your singleton and any subscribers to that event exists in another AppDomain, you might want to keep in mind that you should probably inherit from MarshalByRefObject and override the IntializeLifeTimeService() method and return null there as well. Otherwize you might end up having a broken lease in the delegate added to the singleton.

The updated C# file for this can be found [here](files/crossappdomainsingleton_improved1.zip).


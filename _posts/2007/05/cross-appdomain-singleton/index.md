---
title: "Cross AppDomain Singleton"
date: "2007-05-18"
categories: 
  - "net"
  - "csharp"
---

**PS: There is an addition to this post that you can find [here](http://ingebrigtsen.blog/2007/05/30/crossappdomainsingleton-update/)**

One thing that I find a bit inconvient from time to time is the lack of shared memory between appdomains. Today I figured I had to find a way of doing this, so I created a CrossAppDomainSingleton class that has it's implementation and data shared between AppDomains.

The solution we want is that the singleton class is created in a given AppDomain and in all other AppDomains we get a transparent proxy to that singleton.

In order to do this we need to have the ability to enumerate through existing AppDomains in order to create an instance in the correct AppDomain (at least I found this to be cool way of doing it). I came across a thread on microsoft.public.dotnet.framework.clr that gave me a good solution ([http://groups.google.com/group/microsoft.public.dotnet.framework.clr/browse\_frm/thread/dba9c445ad8d5c3/9df14bf0af393c28?lnk=st&q=enumerate+appdomain+group%3Amicrosoft.public.dot%20net.\*&rnum=5#9df14bf0af393c28](http://groups.google.com/group/microsoft.public.dotnet.framework.clr/browse_frm/thread/dba9c445ad8d5c3/9df14bf0af393c28?lnk=st&q=enumerate+appdomain+group%3Amicrosoft.public.dot%20net.*&rnum=5#9df14bf0af393c28))

You need to add a reference to the mscoree.tlb which is situated in the .net directory (c:windowsmicrosoft.netframeworkv2.0.50727). When you add a reference to it you'll get an Interop.mscoree.dll added to your output directory. You will have to have this alongside your deployment if you're going to use this in a solution.

With my modifications, we get a method that finds a AppDomain based upon the friendly name. If it doesn't find it, it returns null..

```csharp
private static AppDomain GetAppDomain(string friendlyName)
{
  IntPtr enumHandle = IntPtr.Zero;
  mscoree.CorRuntimeHostClass host = new mscoree.CorRuntimeHostClass();

  try
  {
    host.EnumDomains(out enumHandle);

    object domain = null;

    while (true)
    {
      host.NextDomain(enumHandle, out domain);

      if (domain == null)
        break;

      AppDomain appDomain = (AppDomain)domain;

      if( appDomain.FriendlyName.Equals(friendlyName) )
        return appDomain;
    }
  }
  finally
  {
    host.CloseEnum(enumHandle);
    Marshal.ReleaseComObject(host);
    host = null;
  }

  return null;
}
```

The full implementation of the class is then :

```csharp
public class CrossAppDomainSingleton<T> : MarshalByRefObject where T:new()
{
  private static readonly string AppDomainName = "Singleton AppDomain";
  private static T _instance;

  private static AppDomain GetAppDomain(string friendlyName) 
  { 
    IntPtr enumHandle = IntPtr.Zero; 
    mscoree.CorRuntimeHostClass host = new mscoree.CorRuntimeHostClass(); 
    
    try 
    { 
      host.EnumDomains(out enumHandle);

      object domain = null;
      
      while (true) 
      { 
        host.NextDomain(enumHandle, out domain); 
        
        if (domain == null) 
        { 
          break; 
        } 
        
        AppDomain appDomain = (AppDomain)domain; 
        
        if( appDomain.FriendlyName.Equals(friendlyName) ) 
        { 
          return appDomain; 
        } 
      } 
    } 
    finally 
    { 
      host.CloseEnum(enumHandle); 
      Marshal.ReleaseComObject(host); 
      host = null; 
    } 

    return null; 
  }

  public static T Instance 
  { 
    get 
    { 
      if (null == _instance) 
      { 
        AppDomain appDomain = GetAppDomain(AppDomainName); 
        if (null == appDomain) 
        { 
          appDomain = AppDomain.CreateDomain(AppDomainName);
        } 
        
        Type type = typeof(T); 

        T instance = (T)appDomain.GetData(type.FullName);
        if (null == instance) 
        { 
          instance = (T)appDomain.CreateInstanceAndUnwrap(type.Assembly.FullN ame, type.FullName);
          appDomain.SetData(type.FullName, instance); 
        } 
        
        _instance = instance; 
      }

      return _instance; 
    } 
  } 
}
```

This class is not thread safe, so that bit needs to be added..

To use the class you do the following :

```csharp
public class MySingleton : CrossAppDomainSingleton<MySingleton>
{
  public void HelloWorld()
  {
    Console.WriteLine("Hello world from '" + AppDomain.CurrentDomain.FriendlyName + " (" + AppDomain.CurrentDomain.Id + ")'"); 
  } 
}
```

Look at the entire C# sample file from [here](files/crossappdomainsingleton1.zip)

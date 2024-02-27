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

private static AppDomain GetAppDomain(string friendlyName)

{

IntPtr enumHandle = IntPtr.Zero;

mscoree.CorRuntimeHostClass host =

new mscoree.CorRuntimeHostClass();

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

returnnull;

}

<table style="background-color:#f2f2f2;border:#e5e5e5 1px solid;" border="0" width="100%" cellspacing="0" cellpadding="0"><tbody><tr style="vertical-align:top;line-height:normal;"><td style="width:40px;text-align:right;"><pre style="border-right:#e7e7e7 1px solid;font-size:11px;margin:0;color:gray;font-family:courier new;padding:2px;">1
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
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31</pre></td><td><pre style="margin:0;padding:2px 2px 2px 8px;"><span style="font-weight:normal;font-size:11px;color:black;font-family:Courier New;background-color:transparent;">  <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">private</span> <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">static</span> AppDomain GetAppDomain(<span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">string</span> friendlyName)
  {
   IntPtr enumHandle <span style="font-weight:normal;font-size:11px;color:red;font-family:Courier New;background-color:transparent;">=</span> IntPtr.Zero;
   mscoree.CorRuntimeHostClass host <span style="font-weight:normal;font-size:11px;color:red;font-family:Courier New;background-color:transparent;">=</span> <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">new</span> mscoree.CorRuntimeHostClass();
   <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">try</span>
   {
    host.EnumDomains(<span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">out</span> enumHandle);</span></pre><span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">object</span> domain <span style="font-weight:normal;font-size:11px;color:red;font-family:Courier New;background-color:transparent;">=</span> <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">null</span>; <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">while</span> (<span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">true</span>) { host.NextDomain(enumHandle, <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">out</span> domain); <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">if</span> (domain == <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">null</span>) { <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">break</span>; } AppDomain appDomain <span style="font-weight:normal;font-size:11px;color:red;font-family:Courier New;background-color:transparent;">=</span> (AppDomain)domain; <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">if</span>( appDomain.FriendlyName.Equals(friendlyName) ) { <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">return</span> appDomain; } } } <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">finally</span> { host.CloseEnum(enumHandle); Marshal.ReleaseComObject(host); host <span style="font-weight:normal;font-size:11px;color:red;font-family:Courier New;background-color:transparent;">=</span> <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">null</span>; } <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">return</span> <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">null</span>; }</td></tr></tbody></table>

The full implementation of the class is then :

<table style="background-color:#f2f2f2;border:#e5e5e5 1px solid;" border="0" width="100%" cellspacing="0" cellpadding="0"><tbody><tr style="vertical-align:top;line-height:normal;"><td style="width:40px;text-align:right;"><pre style="border-right:#e7e7e7 1px solid;font-size:11px;margin:0;color:gray;font-family:courier new;padding:2px;">1
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
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32
33
34
35
36
37
38
39
40
41
42
43
44
45
46
47
48
49
50
51
52
53
54
55
56
57
58
59
60
61
62</pre></td><td><pre style="margin:0;padding:2px 2px 2px 8px;"><span style="font-weight:normal;font-size:11px;color:black;font-family:Courier New;background-color:transparent;"> <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">public</span> <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">class</span> CrossAppDomainSingleton&lt;T&gt; : MarshalByRefObject where T:<span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">new</span>()
 {
  <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">private</span> <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">static</span> <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">readonly</span> <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">string</span> AppDomainName <span style="font-weight:normal;font-size:11px;color:red;font-family:Courier New;background-color:transparent;">=</span> <span style="font-weight:normal;font-size:11px;color:#666666;font-family:Courier New;background-color:#e4e4e4;">"Singleton AppDomain"</span>;
  <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">private</span> <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">static</span> T _instance;</span></pre><span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">private</span> <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">static</span> AppDomain GetAppDomain(<span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">string</span> friendlyName) { IntPtr enumHandle <span style="font-weight:normal;font-size:11px;color:red;font-family:Courier New;background-color:transparent;">=</span> IntPtr.Zero; mscoree.CorRuntimeHostClass host <span style="font-weight:normal;font-size:11px;color:red;font-family:Courier New;background-color:transparent;">=</span> <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">new</span> mscoree.CorRuntimeHostClass(); <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">try</span> { host.EnumDomains(<span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">out</span> enumHandle);<div></div><span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">object</span> domain <span style="font-weight:normal;font-size:11px;color:red;font-family:Courier New;background-color:transparent;">=</span> <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">null</span>; <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">while</span> (<span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">true</span>) { host.NextDomain(enumHandle, <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">out</span> domain); <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">if</span> (domain == <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">null</span>) { <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">break</span>; } AppDomain appDomain <span style="font-weight:normal;font-size:11px;color:red;font-family:Courier New;background-color:transparent;">=</span> (AppDomain)domain; <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">if</span>( appDomain.FriendlyName.Equals(friendlyName) ) { <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">return</span> appDomain; } } } <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">finally</span> { host.CloseEnum(enumHandle); Marshal.ReleaseComObject(host); host <span style="font-weight:normal;font-size:11px;color:red;font-family:Courier New;background-color:transparent;">=</span> <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">null</span>; } <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">return</span> <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">null</span>; }<div></div><span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">public</span> <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">static</span> T Instance { get { <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">if</span> (<span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">null</span> == _instance) { AppDomain appDomain <span style="font-weight:normal;font-size:11px;color:red;font-family:Courier New;background-color:transparent;">=</span> GetAppDomain(AppDomainName); <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">if</span> (<span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">null</span> == appDomain) { appDomain <span style="font-weight:normal;font-size:11px;color:red;font-family:Courier New;background-color:transparent;">=</span> AppDomain.CreateDomain(AppDomainName); } Type type <span style="font-weight:normal;font-size:11px;color:red;font-family:Courier New;background-color:transparent;">=</span> <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">typeof</span>(T); T instance <span style="font-weight:normal;font-size:11px;color:red;font-family:Courier New;background-color:transparent;">=</span> (T)appDomain.GetData(type.FullName); <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">if</span> (<span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">null</span> == instance) { instance <span style="font-weight:normal;font-size:11px;color:red;font-family:Courier New;background-color:transparent;">=</span> (T)appDomain.CreateInstanceAndUnwrap(type.Assembly.FullN ame, type.FullName); appDomain.SetData(type.FullName, instance); } _instance <span style="font-weight:normal;font-size:11px;color:red;font-family:Courier New;background-color:transparent;">=</span> instance; }<div></div><span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">return</span> _instance; } } }</td></tr></tbody></table>

This class is not thread safe, so that bit needs to be added..

To use the class you do the following :

<table style="background-color:#f2f2f2;border:#e5e5e5 1px solid;" border="0" width="100%" cellspacing="0" cellpadding="0"><tbody><tr style="vertical-align:top;line-height:normal;"><td style="width:40px;text-align:right;"><pre style="border-right:#e7e7e7 1px solid;font-size:11px;margin:0;color:gray;font-family:courier new;padding:2px;">1
2
3
4
5
6
7
8</pre></td><td><pre style="margin:0;padding:2px 2px 2px 8px;"><span style="font-weight:normal;font-size:11px;color:black;font-family:Courier New;background-color:transparent;"> <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">public</span> <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">class</span> MySingleton : CrossAppDomainSingleton&lt;MySingleton&gt;
 {</span></pre><span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">public</span> <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">void</span> HelloWorld() { Console.WriteLine(<span style="font-weight:normal;font-size:11px;color:#666666;font-family:Courier New;background-color:#e4e4e4;">"Hello world from '"</span> <span style="font-weight:normal;font-size:11px;color:red;font-family:Courier New;background-color:transparent;">+</span> AppDomain.CurrentDomain.FriendlyName <span style="font-weight:normal;font-size:11px;color:red;font-family:Courier New;background-color:transparent;">+</span> <span style="font-weight:normal;font-size:11px;color:#666666;font-family:Courier New;background-color:#e4e4e4;">" ("</span> <span style="font-weight:normal;font-size:11px;color:red;font-family:Courier New;background-color:transparent;">+</span> AppDomain.CurrentDomain.Id <span style="font-weight:normal;font-size:11px;color:red;font-family:Courier New;background-color:transparent;">+</span> <span style="font-weight:normal;font-size:11px;color:#666666;font-family:Courier New;background-color:#e4e4e4;">")'"</span>); } }</td></tr></tbody></table>

Look at the entire C# sample file from [here](http://localhost:8080/wp-content/2014/10/crossappdomainsingleton1.zip)

private static AppDomain GetAppDomain(string friendlyName) private static AppDomain GetAppDomain(string friendlyName)

{

IntPtr enumHandle = IntPtr.Zero;

mscoree.CorRuntimeHostClass host =

new mscoree.CorRuntimeHostClass();

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

{

IntPtr enumHandle = IntPtr.Zero;

mscoree.CorRuntimeHostClass host =

new mscoree.CorRuntimeHostClass();

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

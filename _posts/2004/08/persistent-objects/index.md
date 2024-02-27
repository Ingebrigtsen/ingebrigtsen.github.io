---
title: "Persistent Objects"
date: "2004-08-06"
categories: 
  - "csharp"
---

One of the things that are cool with .net Framework 2.0 is the ObjectSpaces. For JAVA developers this has been available for quite some time through libraries such as Hibernate. Today you get Hibernate for .net and there is also a free Objectspaces library for .net 1.1. The only thing with both these that I really find a bit odd is that they rely on XML files to configure the classes and properties to be connected to the datasource.

The only benefit I can see from this is that DBAs can read the humanly readable XML file and just map out the DB schema for the developer to use.

Another way to go about creating a persistent object would be to do some magic in the .net framework. The remoting framework provides us with some cool features to do this a bit more fancy and smooth for the programmer. An AOP approach by using attributes is a far more sexy solution.

Let's say you have an object "Customer" and you have a property "Name" that you want to map to a table with the same name and using the column with the same name. How would the following code sound to do that trick :

<table style="background-color:#f2f2f2;border:#e5e5e5 1px solid;" border="0" width="100%" cellspacing="0" cellpadding="0"><tbody><tr style="vertical-align:top;line-height:normal;"><td style="width:40px;text-align:right;"><pre style="border-right:#e7e7e7 1px solid;font-size:11px;margin:0;color:gray;font-family:courier new;padding:2px;">1
2
3
4
5
6
7
8</pre></td><td><pre style="margin:0;padding:2px 2px 2px 8px;"><span style="font-weight:normal;font-size:11px;color:black;font-family:Courier New;background-color:transparent;">[PersistentObject(<span style="font-weight:normal;font-size:11px;color:#666666;font-family:Courier New;background-color:#e4e4e4;">"Customer"</span>)]
<span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">public</span> <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">class</span> Customer : ContextBoundObject
{
      [Column(<span style="font-weight:normal;font-size:11px;color:#666666;font-family:Courier New;background-color:#e4e4e4;">"Name"</span>)]
      <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">public</span> <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">string</span> Name {
           get {}
      }
}</span></pre></td></tr></tbody></table>

To accomplish this, you have to use the proxy system in the remoting framework. Instead of having a server/client solution we make sure that we get a proxy no matter where it is instantiated.

We need two things to achieve this. 1. An attribute that implements the System.Runtime.Remoting.Proxies.ProxyAttribute and it's CreateInstance() method.

2\. We need a proxy for the object that handles the magic.

The attribute can look something like this :

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
11</pre></td><td><pre style="margin:0;padding:2px 2px 2px 8px;"><span style="font-weight:normal;font-size:11px;color:black;font-family:Courier New;background-color:transparent;">[AttributeUsage(AttributeTargets.Class)]
<span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">public</span> <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">class</span> PersistentObjectAttribute : ProxyAttribute
{
    <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">public</span> PersistentObjectAttribute(<span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">string</span> tableName) {
    }</span></pre><span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">public</span> <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">override</span> MarshalByRefObject CreateInstance(Type serverType) { PersistenceProxy proxy <span style="font-weight:normal;font-size:11px;color:red;font-family:Courier New;background-color:transparent;">=</span> <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">new</span> PersistenceProxy(serverType); <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">return</span> (MarshalByRefObject)proxy.GetTransparentProxy(); } }</td></tr></tbody></table>

The proxy could look something like this :

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
18</pre></td><td><pre style="margin:0;padding:2px 2px 2px 8px;"><span style="font-weight:normal;font-size:11px;color:black;font-family:Courier New;background-color:transparent;"><span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">public</span> <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">class</span> PersistenceProxy : RealProxy 
{
    <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">public</span> PersistenceProxy(Type type) : <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">base</span>(type) {
    }</span></pre><span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">public</span> <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">override</span> IMessage Invoke(IMessage msg) { <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">if</span>( msg <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">is</span> IConstructionCallMessage ) { <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">return</span> EnterpriseServicesHelper.CreateConstructionReturnMessage((IConstructionCallMessage) msg,(MarshalByRefObject)<span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">this</span>.GetTransparentProxy()); }<div></div><span style="font-weight:normal;font-size:11px;color:green;font-family:Courier New;background-color:transparent;">// Use reflection to get the tagged properties... </span><span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">if</span>( msg.Properties[<span style="font-weight:normal;font-size:11px;color:#666666;font-family:Courier New;background-color:#e4e4e4;">"__MethodName"</span>].Equals(<span style="font-weight:normal;font-size:11px;color:#666666;font-family:Courier New;background-color:#e4e4e4;">"get_Name"</span>) ) { <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">return</span> <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">new</span> ReturnMessage(<span style="font-weight:normal;font-size:11px;color:#666666;font-family:Courier New;background-color:#e4e4e4;">"Cool Name"</span>,<span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">null</span>,0,<span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">null</span>,(IMethodCallMessage)msg); }<div></div><span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">throw</span> <span style="font-weight:normal;font-size:11px;color:blue;font-family:Courier New;background-color:transparent;">new</span> NotImplementedException(<span style="font-weight:normal;font-size:11px;color:#666666;font-family:Courier New;background-color:#e4e4e4;">"Need more logic..."</span>); } }</td></tr></tbody></table>

All you need to do is to create an instance of the Customer object and there you have your proxy. Ofcourse the solution for an entire system would include some factories for handling these objects from the DB and such, but the basics of it is pretty much as shown above.

Another point is that all the solutions I've seen for having persistence on objects are focused on mapping tables and columns. This can be extended to include far more features than that. How about linking a property to a WebService, an ADO DataSet, a static method on another object, a file... The possibilities are endless.

At the moment I'm working on a project that will be a fully working Component for anyone to use. You'll find it at GotDotNet :

 

http://www.gotdotnet.com/community/workspaces/workspace.aspx?id=0bb104cb-9ebb-4fc8-947f-2f9649f412b4

 

The revised version of this blog's topic can be found on TheServerSide.net : [http://blog.dolittle.com/ct.ashx?id=71e1b6fd-59bf-41a5-8c33-cde01dbf9899&url=http%3a%2f%2fwww.theserverside.net%2fnews%2fthread.tss%3fthread\_id%3d28325](http://blog.dolittle.com/ct.ashx?id=71e1b6fd-59bf-41a5-8c33-cde01dbf9899&url=http%3a%2f%2fwww.theserverside.net%2fnews%2fthread.tss%3fthread_id%3d28325)

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

```csharp
[PersistentObject("Customer")]
public class Customer : ContextBoundObject
{
      [Column("Name")]
      public string Name {
           get {}
      }
}
```

To accomplish this, you have to use the proxy system in the remoting framework. Instead of having a server/client solution we make sure that we get a proxy no matter where it is instantiated.

We need two things to achieve this. 1. An attribute that implements the System.Runtime.Remoting.Proxies.ProxyAttribute and it's CreateInstance() method.

2\. We need a proxy for the object that handles the magic.

The attribute can look something like this :

```csharp
[AttributeUsage(AttributeTargets.Class)]
public class PersistentObjectAttribute : ProxyAttribute
{
  public PersistentObjectAttribute(string tableName) 
  {
  }

  public override MarshalByRefObject CreateInstance(Type serverType) 
  { 
    PersistenceProxy proxy = new PersistenceProxy(serverType); return (MarshalByRefObject)proxy.GetTransparentProxy(); 
  } 
}
```

The proxy could look something like this :

```csharp
public class PersistenceProxy : RealProxy 
{
  public PersistenceProxy(Type type) : base(type) 
  {
  }

  public override IMessage Invoke(IMessage msg)
  { 
    if( msg is IConstructionCallMessage ) 
    {
      return EnterpriseServicesHelper.CreateConstructionReturnMessage((IConstructionCallMessage) msg,(MarshalByRefObject)this.GetTransparentProxy()); 
    }

    // Use reflection to get the tagged properties...
    if( msg.Properties["__MethodName"].Equals("get_Name") ) 
    { 
      return new ReturnMessage("Cool Name",null,0,null,(IMethodCallMessage)msg); 
    }

    throw new NotImplementedException("Need more logic..."); 
  } 
}
```

All you need to do is to create an instance of the Customer object and there you have your proxy. Of course the solution for an entire system would include some factories for handling these objects from the DB and such, but the basics of it is pretty much as shown above.

Another point is that all the solutions I've seen for having persistence on objects are focused on mapping tables and columns. This can be extended to include far more features than that. How about linking a property to a WebService, an ADO DataSet, a static method on another object, a file... The possibilities are endless.

At the moment I'm working on a project that will be a fully working Component for anyone to use. You'll find it at GotDotNet :

http://www.gotdotnet.com/community/workspaces/workspace.aspx?id=0bb104cb-9ebb-4fc8-947f-2f9649f412b4

The revised version of this blog's topic can be found on TheServerSide.net : [http://blog.dolittle.com/ct.ashx?id=71e1b6fd-59bf-41a5-8c33-cde01dbf9899&url=http%3a%2f%2fwww.theserverside.net%2fnews%2fthread.tss%3fthread\_id%3d28325](http://blog.dolittle.com/ct.ashx?id=71e1b6fd-59bf-41a5-8c33-cde01dbf9899&url=http%3a%2f%2fwww.theserverside.net%2fnews%2fthread.tss%3fthread_id%3d28325)

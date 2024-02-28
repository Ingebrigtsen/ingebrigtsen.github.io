---
title: "Dynamically discovering assemblies and types on Windows Phone 7"
date: "2010-07-15"
categories: 
  - "net"
tags: 
  - "silverlight"
---

The last few days I've been busy porting [Balder](http://balder.codeplex.com) to other platforms, amongst those; Windows Phone 7 Series. There are some nuances between the different platforms Balder will support, one of these for Windows Phone 7 was that the Load() method does not exist on an AssemblyPart from the deployment object.

Balder has a discover architecture were it discovers different types from the loaded assemblies, in the Silverlight version I could simply go and get all the AssemblyParts and get it as a resource stream and load them to get the actual Assembly instance. Since the Load() method didn't exist I had to to look elsewhere.  
Fortunately, the Assembly class in the Windows Phone 7 version of .net has an overload for the Load() method that takes a string. According to the MSDN documentation it needs to take a fully qualified assemblyname, that turned out to be difficult to acquire. But, it turns out that its sufficient to pass it the short name - this can be derived from the DLL name found in the AssemblyParts property called Source.

From the [TypeDiscoverer](http://balder.codeplex.com/SourceControl/changeset/view/6c6cb5db5ec4#Source%2fBalder.Core%2fExecution%2fTypeDiscoverer.cs) code in Balder :

```csharp  
private void CollectTypes()  
{  
if( null != Deployment.Current )  
{  
var parts = Deployment.Current.Parts;  
foreach (var part in parts)  
{  
var assemblyName = part.Source.Replace(".dll", string.Empty);  
var assembly = Assembly.Load(assemblyName);  
var types = assembly.GetTypes();  
\_types.AddRange(types);  
}  
}  
}  
```

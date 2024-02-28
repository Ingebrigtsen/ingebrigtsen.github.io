---
title: "Loading files from other places than the XAP package with Balder"
date: "2010-09-18"
---

One of the more common feature request of Balder has been to be able to load files from anywhere. Although it is a commonly requested feature, there are a whole set of other features that is constantly getting more priority than this. Until tonight.

I had 30 minutes to spare and was able to get it done, at least so anyone can start extending on this themselves.  
  

Balder is using something its calling a FileLoader, defined through the interface IFileLoader. Till tonight, there could only be one FileLoader, and it was defined by the Platform. What I've implemented tonight is the ability to define your own FileLoaders.

All you need to do is to implement the interface IFileLoader anywhere in any assembly of your application, just make the implementation public. Balder will discover anything that implements IFileLoader and add it as a potential loader.

In the interface you'll find one very important property you need to implement; SupportedSchemes. It returns an array of strings that represents the URI schemes that the loader supports. Nevermind the Exists() method for now, it is not being used yet - but will in the near future, so mind it again at a later stage. :)

The schemes you return should only be the name of the scheme, without the "://" part of the URI. When you then want to assets into Balder, either in your Xaml or programatically, you just create the assetname as follows : "://". For instance, if you were to create a WCF loader :

```csharp  
public class WcfFileLoader : Balder.Content.IFileLoader  
{  
public Stream GetStream(string fileName)  
{  
// Do magical WCF calls and return a stream  
}  
public bool Exists(string fileName)  
{  
// Do some more magical WCF calls and return wether or not the file exists  
}  
public string\[\] SupportedSchemes { get { return \[\] { "wcf" }; } }  
```

The filename would then be something like : "wcf://my3DModel.ase".

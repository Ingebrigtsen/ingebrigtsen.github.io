---
title: "INotifyPropertyChanged - Automagically implemented"
date: "2010-01-10"
categories: 
  - "net"
  - "balder"
tags: 
  - "silverlight"
---

**Update, 19th of November 2011:**

**Eduardo Elias Mardini Bitar did an article for the [CodeProject with some updates and improvements](http://www.codeproject.com/KB/cs/INotifyPropertyChanged.aspx).**

Recently I've been working on a small Silverlight project at a client and at the same time I've been working on implementing a SampleBrowser for Balder on my spare time, both these applications are using the MVVM paradigm and all that comes with it. One of the things that has really been bugging me is the INotifyPropertyChanged interface, a key interface for making the View observe changes on objects. Not only do you have to implement the same thing over and over again (the notification bit), but also the PropertyChanged event takes an argument that holds the property being changed as a literal. Although, the literal bit can be solved quite easily with some Lambda Expression magic, like I've [blogged about in the past](/post/2008/12/11/INotifyPropertyChanged-revisited.aspx). But your still left with writing the same boring notification code over and over again.

I got really inspired by [Jonas Follesoes](http://jonas.follesoe.no) [post](http://jonas.follesoe.no/AutomaticINotifyPropertyChangedUsingDynamicProxy.aspx) about how he solved the ever lasting challenge of INotifyPropertyChanged using Castles DynamicProxy to generate a proxy and automatically handle most of it. I read it and automatically started thinking about how I could remove the last bits and make the objects needed notification totally ignorant of the fact they should notify any changes. The Castle approach described by Jonas is very clean and I love working with Aspects like that, but it is pretty much impossible to get it to 100% automatically generate everything. The reason for this is that in the Silverlight runtime, you are not allowed for security reasons to invoke delegates on another type other than your own through reflection. Another issue I had that I could never figure out, was how to tie it in with an IoC container. I couldn't find a way in Castles solution to actually get the proxy type and not the instance, this of course is quite possibly possible, but I couldn't find it at all.

I started earlier today with the idea I could generate the proxy from scratch myself. The idea is to create a new proxy type that derives from the type you want to automatically notify its changes by overriding your properties. The properties you want to automatically notify must be virtual and implement a setter. The weaved version will override these properties and actually forward both the get and the set method of the properties to your type, so you can still do more complex stuff in your property methods. The result is a specialized object weaver for handling INotifyPropertyChanged. The code is too much to include in this post, but you'll find the implementation [here](http://github.com/einari/Balder/blob/Development/Source/Balder.Silverlight/Notification/NotifyingObjectWeaver.cs) and the unit tests [here](http://github.com/einari/Balder/blob/Development/Source/Balder.Silverlight.Tests/Notification/NotifyingObjectWeaverTests.cs), also it support a couple of attributes - much like Jonas' solution for ignoring and adding other properties it should notify as well. Take a look at the entire [namespace](http://github.com/einari/Balder/tree/Development/Source/Balder.Silverlight/Notification/) for all files needed. Also worth mentioning is that if you define your constructor to have arguments, it will implement a constructor on the proxy that is exactly the same and forward any arguments when instantiated. That way in a typical ViewModel scenario were you have dependencies to typically services, these will be injected when creating an instance of the proxy through an IoC Container.

Using it is very simple, create a class:

\[code:c#\]  
public class ViewModel  
{      
    public virtual string SomeString { get; set; }    
}   
\[/code\] 

Getting the proxy type:

\[code:c#\]  
var proxyType = NotifyingObjectWeaver.GetProxyType<ViewModel>();  
\[/code\]

Once you have the type you can bind it in your IoC container or simply use the Activator type and create an instance of it. 

**UPDATED 12th of January 2010: Discovered a small bug when I moved it into production, had forgotten to mark the type created with public. Silverlight can't instantiate private types via dynamically from other types. Its all been updated in the repository.** 

**EDIT 18th of January 2010: Made it dispatcher friendly - read my [post](/post/2010/01/16/Dispatcher-Safe-INotifyPropertyChanged.aspx) about it.**

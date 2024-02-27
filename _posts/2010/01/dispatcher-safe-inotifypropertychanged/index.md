---
title: "Dispatcher Safe INotifyPropertyChanged"
date: "2010-01-16"
categories: 
  - "net"
  - "csharp"
tags: 
  - "silverlight"
---

**Update, 19th of November 2011:**

**Eduardo Elias Mardini Bitar did an article for the [CodeProject with some updates and improvements](http://www.codeproject.com/KB/cs/INotifyPropertyChanged.aspx).**

One of the things I really love in Silverlight is the promotion of non-locking UIs through heavy use of asynchronous operations for things like webservice calls. The main problem though with this is that it is running on a different thread than the UI thread and you can't modify anything on the UI without running on the same thread. This even goes for databinding, so if you have properties on an object databound in the UI and you set the value on any of these properties, you still need to be on the UI thread in order for this to work. This is also true for WPF applications.

The way you could do this is to get an instance of the Dispatcher and use the BeginInvoke() method on it. In Silverlight there is only one Dispatcher and it can be retrieved from the Deployment object in System.Windows; Deployment.Current.Dispatcher. In WPF there can be several Dispatchers, so it gets a bit more complicated, you'd have to do Dispatcher.FromThread() and use the current thread during the add method of your PropertyChanged and store it alongside with the instance of the delegate to know which Dispatcher to invoke a change on.

 When I first wrote my automagically implemented INotifyPropertyChanged [post](/post/2010/01/10/INotifyPropertyChanged-Automagically-implemented.aspx), it didn't have this support. I knew I needed it to support it, but I didn't want to have a dependency directly to the Dispatcher found in the Deployment object, as my unit tests would have a hard time coping with that dependency. I needed to abstract it away so I could have a cleaner way of doing this and be able to test it without too much hassle. By introducing an interface representing the Dispatcher, I was halfway there, but had no way of injecting this into the proxy types being created. The problem is that you can't define a constant on the type that holds a reference to a ref object, it only supports value types. I really struggled a full day with this, I was trying to not have any dependencies from the proxies in order to get the Dispatcher, and I didn't want to tie it up to just be compatible with IoC containers and specifically NInject that I'm using for the most part. The result is that I had to implement a DispatcherManager and have a private field on the proxy type holding a reference to an IDispatcher and let the manager control which implementation it got. This worked out nicely, even though it now have a dependency to the DispatcherManager directly. 

This has all been implemented into the Balder project, as I need it for my SampleBrowser I'm working on, the code is located inside the Notification namespace and can be found [here](http://github.com/einari/Balder/tree/Development/Source/Balder.Silverlight/Notification/). 

**What does it do?**  
Lets say you have your object like below, the virtuals are in there for the weaver to be able to implement these properties in its proxy (as eplained in my previous [post](/post/2010/01/10/INotifyPropertyChanged-Automagically-implemented.aspx)). 

\[code:c#\]  
public class Employee  
{  
    public virtual string FirstName { get; set; }  
    public virtual string LastName { get; set; }   
}  
\[/code\]

The weaver will then go and inject its magic, the end result is pretty much like this:  
\[code:c#\]  
public class EmployeeProxy : Employee, INotifyPropertyChanged  
{  
    private IDispatcher \_dispatcher = DispatcherManager.Current;  
  
    public event PropertyChangedEventHandler PropertyChanged;  
  
    public override string FirstName  
    {  
        get { return base.FirstName; }  
        set  
        {  
            base.FirstName = value;  
            OnPropertyChanged("FirstName");  
        }  
    }  
  
  
    public override string LastName  
    {  
        get { return base.LastName; }  
        set  
        {  
            base.LastName = value;  
            OnPropertyChanged("LastName");  
        }  
    }  
  
    private void OnPropertyChanged(string propertyName)  
    {  
        if( null != PropertyChanged )  
        {  
            if( \_dispatcher.CheckAccess() )  
            {  
                PropertyChanged(this, new PropertyChangedEventArgs(propertyName));  
            }  
            else  
            {  
                \_dispatcher.BeginInvoke(PropertyChanged,this, new PropertyChangedEventArgs(propertyName));  
            }  
        }  
    }  
  
}  
\[/code\]

---
title: "INotifyPropertyChanged revisited"
date: "2008-12-11"
categories: 
  - "net"
  - "csharp"
  - "clr"
  - "wpf"
tags: 
  - "silverlight"
---

**UPDATE, 12th of July 2009: Full source with sample can be downloaded from the following [post](/post/2009/07/11/Extensions-and-Helpers-for-Silverlight-and-WPF.aspx)**. 

A recurring annoyance with me and quite a few other developers, is the way notification of changes from for instance your domain model to the UI should be handled in environments such as WPF or Silverlight.  
  
The environments are heavily relying on the objects implementing INotifyPropertyChanged and hooks up to the event PropertyChanged to be notified about any changes in any properties.  
  
This works out fine, with the exception of we as developers have to plumb in this code in all our objects.  
Normally you would write something like :  
  
\[code:c#\]  
public class Employee : INotifyPropertyChanged  
{  
    public event PropertyChangedEventHandler PropertyChanged;  
  
    private string \_firstName;  
    public string FirstName  
    {  
       get { return this.\_firstName; }  
       set  
       {  
          this.\_firstName = value;  
          this.OnPropertyChanged("FirstName");  
       }  
    }  
  
    private void OnPropertyChanged(string propertyName)  
    {  
        if( null != this.PropertyChanged )  
        {  
           this.PropertyChanged(this, new PropertyChangedEventArgs(propertyName));  
        }  
    }  
}  
\[/code\]  
  
One can easily see that the above code can become quite boring to write over and over again. A solution could be to put the frequently used bits in a base class for all your objects. But this steals inheritance.  
  
Another thing that bothers me with the whole INotifyPropertyChanged concept is the fact that I will be having my code filled up with literals that will not give any compiler errors if they contain typos, nor will they be subject to any renaming of properties as part of refactoring.  
  
In my search for a better way of doing this I came across quite a few ways of trying to simplify it. The best one I came across involved using Lambda expressions to express the property that was changed and thus fixing the latter problem with renaming/refactoring. But as far as Google took me, I couldn't find anything that didn't involved switching to an extensible language like Boo or similar to really tackle the problem more elegantly. But my quest couldn't end there.  
  
I started playing again with the problem a bit today and came up with a solution that I think is quite elegant. It involves Lambda expressions, extension methods and reflection. My three favourite things in C# and CLR these days. :)  

_**Update: 16th of December 2008, thanks to [Miguel Madero](http://www.miguelmadero.com/)**_ _**for pointing out the problem with value types.**_

\[code:c#\]  
    public static class NotificationExtensions  
    {  
        public static void Notify(this PropertyChangedEventHandler eventHandler, Expression<Func<object>> expression)  
        {  
            if( null == eventHandler )  
            {  
                return;  
            }  
            var lambda = expression as LambdaExpression;  
            MemberExpression memberExpression;  
            if (lambda.Body is UnaryExpression)  
            {  
                var unaryExpression = lambda.Body as UnaryExpression;  
                memberExpression = unaryExpression.Operand as MemberExpression;  
            }  
            else  
            {  
                memberExpression = lambda.Body as MemberExpression;  
            }  
            var constantExpression = memberExpression.Expression as ConstantExpression;  
            var propertyInfo = memberExpression.Member as PropertyInfo;  
              
            foreach (var del in eventHandler.GetInvocationList())  
            {  
                del.DynamicInvoke(new object\[\] {constantExpression.Value, new PropertyChangedEventArgs(propertyInfo.Name)});  
            }  
        }  
   }  
\[/code\]  
  
When having the extension method above within reach, you will get the Notify() extension method for the PropertyChanged event in your class. The usage is then very simple. Lets revisit our Employee class again.  
   
\[code:c#\]  
  
public class Employee : INotifyPropertyChanged  
  
{  
  
    public event PropertyChangedEventHandler PropertyChanged;  
  
  
  
    private string \_firstName;  
  
    public string FirstName  
  
    {  
  
       get { return this.\_firstName; }  
  
       set  
  
       {  
  
          this.\_firstName = value;  
  
          this.PropertyChanged.Notify(()=>this.FirstName);  
  
       }  
  
    }  
  
}  
  
\[/code\]  
  
  
This is a highly reusable and pretty compact technique, and if you're not like me and aren't all that agressive with putting "this." all over the place, it will be even more compact. :)  

_**Update**_, _**16th of December 2008:**_

Since my original post, I also added a SubscribeToChange() extension method. The reason for this is pretty much that I literally don't like literals and wanted to have the ability to subscribe to changes for a specific property.

\[code:c#\]  
        public static void SubscribeToChange<T>(this T objectThatNotifies, Expression<Func<object>> expression, PropertyChangedEventHandler<T> handler)  
            where T : INotifyPropertyChanged  
        {  
            objectThatNotifies.PropertyChanged +=  
                (s, e) =>  
                    {  
                        var lambda = expression as LambdaExpression;  
                        MemberExpression memberExpression;  
                        if (lambda.Body is UnaryExpression)  
                        {  
                            var unaryExpression = lambda.Body as UnaryExpression;  
                            memberExpression = unaryExpression.Operand as MemberExpression;  
                        }  
                        else  
                        {  
                            memberExpression = lambda.Body as MemberExpression;  
                        }  
                        var propertyInfo = memberExpression.Member as PropertyInfo;  
  
                        if(e.PropertyName.Equals(propertyInfo.Name))  
                        {  
                            handler(objectThatNotifies);  
                        }  
                    };  
        }  
\[/code\]

The above code extends classes that implements INotifyPropertyChanged and gives you a syntax like  follows for subscribing to events:

\[code:c#\]  
myObject.SubscripeToChange(()=>myObject.SomeProperty,SomeProperty\_Changed);  
\[/code\]

 And then your handler would look like this:

\[code:c#\]  
private void SomeProperty\_Changed(MyObject myObject)  
{  
    /\* ... implement something here \*/  
}  
\[/code\]

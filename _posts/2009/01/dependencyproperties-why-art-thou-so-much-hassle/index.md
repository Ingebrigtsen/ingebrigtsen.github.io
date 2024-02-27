---
title: "DependencyProperties - why art thou (so much hassle)?"
date: "2009-01-09"
categories: 
  - "net"
  - "csharp"
  - "wpf"
tags: 
  - "silverlight"
---

**UPDATE, 12th of July 2009: Full source with sample can be downloaded from the following [post](/post/2009/07/11/Extensions-and-Helpers-for-Silverlight-and-WPF.aspx)**.

I've grown quite fond of WPF and Silverlight, and find the architecture behind both great. I love the notions of DependencyProperties and how these are implemented. The only thing I find a bit annoying, is how one declares them. I am not going to go into details how DependencyProperties or binding works, there is quite a few tutorials out there that covers that.  
  
Lets say you have a ViewModel object, and on it you have a State property you wish to expose and make visible and bindable in Xaml:  
  
\[code:c#\]  
public class ViewModel  
{  
     public ViewState State { get; set; }  
}  
\[/code\]  
  
  
**DependencyProperty out of the box**  
In order for this to become a DependencyProperty and something we can bind against in Xaml, we have to do the following:  
  
\[code:c#\]  
public class ViewModel  
{  
     public static readonly DependencyProperty StateProperty =  
           DependencyProperty.Register("State",typeof(ViewState),typeof(ViewModel),null);  
     public ViewState State  
     {  
         get { return (ViewState)this.GetValue(StateProperty); }  
         set { this.SetValue(StateProperty,value); }  
     }  
}  
\[/code\]  
  
If you wanted to get notified if the property changed from databinding or similar, you would have to specify propertymetadata with a handler as the last argument for the Register method.  
Its not too bad, but it is error-prone - there is a literal there specifying the name of the property. This has to match the actual name of the property. Hardly refactorable.  
  
This alone made me want to do something about it. In addition, I wanted my properties to act as any other property I have on objects.  For instance, if a state change occured, I just wanted my set method on the State property to be called. This introduces a bit of a problem. Calling the SetValue() method causes a whole range of events to occur, if you have a binding expression attached to the dependency property, it causes the PropertyChanged event from the attached object to be decoupled. Needless to say, not a good solution.  
  
What I've created for my project are 3 classes that can be used seperately or together.  
  
**DependencyPropertyHelper  
  
**\[code:c#\]  
public static class DependencyPropertyHelper  
{  
    public static DependencyProperty Register<T, TResult>(Expression<Func<T, TResult>> expression)  
    {  
        return Register<T,TResult>(expression, null);  
    }  
  
    public static DependencyProperty Register<T, TResult>(Expression<Func<T, TResult>> expression, TResult defaultValue)  
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
  
        string dependencyPropertyName = propertyInfo.Name;  
  
        DependencyProperty prop = DependencyProperty.Register(  
            dependencyPropertyName,  
            propertyInfo.PropertyType,  
            typeof(T),  
            new PropertyMetadata(defaultValue,(o, e) =>  
                                                  {  
                                                    Action a = ()=>propertyInfo.SetValue(o, e.NewValue, null);  
                                                    if( o.Dispatcher.CheckAccess() )  
                                                    {  
                                                        a();  
                                                    } else  
                                                    {  
                                                        o.Dispatcher.BeginInvoke(a);  
                                                    }  
                                                  }));  
        return prop;  
    }  
}  
\[/code\]  
  
The helper have the assumption that any change callback should just set the property value directly.  
With this helper, we can at least make our dependency properties refactorable:  
  
\[code:c#\]  
public class ViewModel  
{  
     public static readonly DependencyProperty StateProperty =  
           DependencyPropertyHelper.Register<ViewModel,ViewState>(o=>o.State);  
     public ViewState State  
     {  
         get { return (ViewState)this.GetValue(StateProperty); }  
         set { this.SetValue(StateProperty,value); }  
     }  
}  
\[/code\]  
  
But still, we have the problem with the SetValue() in the property. So we need a second helping hand to make it all tick. Introducing the DependencyPropertyExtensions class:  
**  
DependencyPropertyExtensions  
  
**\[code:c#\]  
public static class DependencyPropertyExtensions  
{  
    public static void SetValue<T>(this DependencyObject obj, DependencyProperty property, T value)  
    {  
        object oldValue = obj.GetValue(property);  
        if (null != oldValue && null != value)  
        {  
            if (oldValue.Equals(value))  
            {  
                return;  
            }  
        }  
        obj.SetValue(property,value);  
    }  
  
    public static T GetValue<T>(this DependencyObject obj, DependencyProperty property)  
    {  
        return (T)obj.GetValue(property);  
    }  
}  
\[/code\]  
  
With this in place, we can do the following:  
  
\[code:c#\]  
public class ViewModel  
{  
     public static readonly DependencyProperty StateProperty =  
           DependencyPropertyHelper.Register<ViewModel,ViewState>(o=>o.State);  
     public ViewState State  
     {  
         get { return this.GetValue<ViewState>(StateProperty); }  
         set { this.SetValue<ViewState>(StateProperty,value); }  
     }  
}  
\[/code\]  
  
Our code will now work as planned, and we can start putting any logic we want in the set method.  
  
**TypeSafeDependencyProperty**  
Still, it could get better than this.  
The DependencyProperty class can live anywhere, so we can actually wrap it all up in a new class that utilizes the other two classes:  
  
\[code:c#\]  
public class TypeSafeDependencyProperty<T1,T>  
{  
    private readonly DependencyProperty \_dependencyProperty;  
  
  
    private TypeSafeDependencyProperty(DependencyProperty dependencyProperty)  
    {  
        this.\_dependencyProperty = dependencyProperty;  
    }  
  
  
    public T GetValue(DependencyObject obj)  
    {  
        return obj.GetValue<T>(this.\_dependencyProperty);  
    }  
  
    public void SetValue(DependencyObject obj, T value)  
    {  
        obj.SetValue<T>(this.\_dependencyProperty,value);  
  
    }  
  
    public static TypeSafeDependencyProperty<T1,T> Register(Expression<Func<T1, T>> expression)  
    {  
        var property = DependencyPropertyHelper.Register<T1,T>(expression);  
  
        var typeSafeProperty = new TypeSafeDependencyProperty<T1,T>(property);  
  
        return typeSafeProperty;  
    }  
  
    public static TypeSafeDependencyProperty<T1,T> Register(Expression<Func<T1, T>> expression, T defaultValue)  
    {  
        var property = DependencyPropertyHelper.Register<T1, T>(expression,defaultValue);  
  
        var typeSafeProperty = new TypeSafeDependencyProperty<T1, T>(property);  
  
        return typeSafeProperty;  
    }  
}  
\[/code\]  
  
Our property can then be implemented as follows:  
\[code:c#\]  
public class ViewModel  
{  
     public static readonly TypeSafeDependencyProperty<ViewModel,ViewState> StateProperty =  
           TypeSafeDependencyProperty.Register<ViewModel,ViewState>(o=>o.State);  
     public ViewState State  
     {  
         get { return StateProperty.GetValue(this); }  
         set { StateProperty.SetValue(this,value); }  
     }  
}  
\[/code\]  
  
  
**Conclusion  
**Code quality is a subject that I think is really important. In many of the APIs introduced by Microsoft, there is room for throwing code quality out the window. DependencyProperties and PropertyChanged on INotifyPropertyChanged interface are two things that open up for trouble - in my opinion. By using literals for code elements is a thing that I find to be really bad. If you were to rename the property and forget to rename the literal, you can end up debugging for hours. In Silverlight, the mismatch between the two does not cause any obvious exceptions. But, as shown above, they are relatively easy to wrap and make safe(r).

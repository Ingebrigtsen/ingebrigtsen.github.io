---
title: "Compiler extensions is just another framework"
date: "2008-11-03"
---

Over the years I've had several issues where I've longed for ways to better express my code that I felt that the language should have exposed grammar for me to make it more readable. Just like LINQ introduces an internal DSL, I've had quite a few cases were I also wanted to introduce my own internal DSL. Very often one ends up with working around it and do creative frameworks or libraries that helps doing the same thing without really solving the expressiveness.  
  
I come to realize more and more that the programming language one chose is less important than the frameworks one use. As long as one can express the code the way one wants and perhaps even in a suitable manner for the domain you're working in, the choice of language is really not important.  
  
**Attributes**  
Attributes in C# are great for expressiveness, they are great at providing additional meta information for classes, fields and properties. Often I find myself using attributes for expressing business rules and having evaluation code for classes that recognise the attributes and then validates according by calling the different validation attributes applied. In my opinion, this is a bit unnatural. A lot of the attributes found in the .net framework acts as more than just meta information at compiletime. The compiler recognizes a whole bunch of the framework attributes and alters the behavior of the execution accordingly.  
Ofcourse, everything that could be solved at compiletime could certainly also be solved at runtime, but it affects runtime speed and scalability.  
  
**Modifying IL code**  
[PostSharp](http://www.postsharp.org/) is a project that solves this; one can alter the IL code generated after compilation and then commit it to the assembly. Attributes is a part of the language and with PostSharp we could solve this problem and we don't need to extend the compiler.  
  
**Plumbing**  
Another good place were you'd might look at having compiler extensions are the places were you are basically just plumbing to make things work with how a framework wants it to work. A good candidate would be for instance the INotifyPropertyChanging and INotifyPropertyChanged interfaces were you basically are just doing the same code over and over again for all your properties. With a compiler extension you could plumb all this automatically.  
  
Typically you would do the following:  
  
  
```csharp  
public class MyNotifyingObject : INotifyPropertyChanging  
{  
    public event PropertyChangedEventHandler PropertyChanging;  
  
    protected virtual void OnPropertyChanging(string propertyName)  
    {  
       if( null != this.PropertyChanging )  
       {  
          this.PropertyChanging(this,new PropertyChangedEventArgs(propertyName));  
       }  
    }  
  
    public string Name  
    {  
       get  
       {  
          return this._name;  
       }  
  
       set  
       {  
          if ((this._name != value))  
          {  
             this.OnPropertyChanging("Name");  
             this._name = value;  
             this.OnPropertyChanged("Name");  
          }  
       }  
    }  
}  
```  
  
A more expressive way could be:  
  
```csharp  
public class MyNotifyingObject  
{  
    public notify string Name { get; set; }  
}  
```  
  
  
  
If you ever worked with WPF or Silverlight, you know the tedious parts where you want to have DependencyProperties on your controls. The syntax is like this:  
  
```csharp  
public static readonly DepedencyProperty MyStringProperty =  
                  DependencyProperty.Register("MyString", typeof(string), typeof(ParentType), null);  
  
public string MyString  
{  
     get  
     {  
           return this.GetValue(MyStringProperty);  
     }  
     set  
     {  
           this.SetValue(MyStringProperty,value);  
     }  
}  
```  
  
Wouldn't it be a lot more expressive if we could just do:  
  
```csharp  
public dependent string MyString { get; set; }  
```  
  
The way a compiler extension would handle this, is to fill in all the code found above to make it all work like if you were to write it all. We would get a more expressive code and actually get rid of potential problems with the literal declaring the name of the property as we do today.  
**  
C# 4.0**  
During PDC there's been a bit talk about C# 4.0 and further down the pipeline, Anders Hejlsberg talked about the new static type called dynamic, that will help us out getting more dynamic. I for one has been quite the skeptic over the years about dynamic languages, but I must admit that in many cases it is really convienient. My conclusion is that this is a really great step forward for the language.  
  
  
**Boo**  
The programming language Boo is a static language that can be dynamically altered by introducing new keywords into the language through compiler extensions. In addition to the compiler they've created a small framework that enables the developer to take part of the compilation and modify the AST. This feels very great and gives us developers the power we need to really express our code and give our programming model a domain specific feel. A colleague of mine; Tore Vestues blogs about Boo and all its glory. Have a look [here](http://tore.vestues.no/2008/09/28/what-makes-boo-great/).  
  
Boo is great, but has a couple of obstacles before it will be embraced as a mainstream programming language by a lot of developers; syntax is one - even though I claim that the language shouldn't really matter, it sort of does. If you are familiar with the C syntax of C++,Java,C#, JavaScript, then the chances are that you'd feel that swithching to a new language is too big and you fall back. So, what about C# - if this is so great, why aren't we seeing this in C#? It is for sure, technically possible. At PDC there was a great panel on the future of programming languages where this among a ton of subjects was discussed. My impression was that Anders Hejlsberg was quite clear on this subject; they didn't want to open it all up because of the danger of devolving the language. I think this is really sad, I really hope they turn around on this. After all, as the title of this post claims; it is basically just another framework. By extending the language, and doing it like Boo has done it, wouldn't pose a threat to the language. The extensions one would build would in many cases be solving a domain specific problem and just act as just another framework one used to solve that problem.  
  
**Compiler Extensions - how  
**A compiler extension, would need access to the AST tree created during compile time and based upon the code and any extensions found extend the existing tree. Boo solves this in a very graceful manner, the extensions are just part of your code as you compile or you can put them in a component. It is really not that intrusive as it might sound. We're not talking about creating a whole new version of the language, rather than introducing domain specific problem-solvers or aiding in creating more expressiveness. In addition to compiler extensions, one need to hook into the IDE to get rid of all the errors one would get thrown in your face while writing code.

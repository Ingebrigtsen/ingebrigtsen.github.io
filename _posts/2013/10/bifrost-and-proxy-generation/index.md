---
title: "Bifrost and Proxy generation"
date: "2013-10-06"
categories: 
  - "bifrost"
---

One of the things we consider to be one of the most successful things we've added to [Bifrost](http://bifrost.dolittle.com) is the bridge between the client and the server in Web solutions. Earlier this year we realized that we wanted to be much more consistent between the code written in our "backend" and our "frontend", bridging the gap between the two.  And out of this realization came generation of proxy objects for artifacts written in C# that we want to have exposed in our JavaScript code. If you're a [node.js](http://www.nodejs.org) developer you're probably asking yourself; WHY..   Well, we don't have the luxury to be writing it all in JavaScript right now, but it would be interesting leveraging what we know now and build a similar platform on top of node.js, or for the Ruby world for that matter - but thats for a different post.  One aspect of our motivation for doing this was also that we find types to be very helpful; and yes - JavaScript is a dynamic language but its not typeless, so we wanted the same usefulness that the types have been playing for our backend code in the frontend as well. The types represent a certain level of metadata and we leverage the types all through our system.

Anywho, the principle was simple; use [.net reflection](http://msdn.microsoft.com/en-us/library/f7ykdhsy.aspx) for the types we wanted represented in JavaScript and generate pretty much an exact copy of those types in corresponding namespaces in the client. Namespaces, although different between different aspects of the system come together with a convention mechanism built into [Bifrost](http://bifrost.dolittle.com) - this also being a post on its own that should be written :), enough with the digressions.

Basically, in the Core library we ended up introducing a CodeGeneration namespace - which holds the JavaScript constructs we needed to be able to generate the proxies we needed.

[![CodeGeneration_NS](http://localhost:8080/wp-content/2013/10/codegeneration_ns1.png?w=102)](http://localhost:8080/wp-content/2013/10/codegeneration_ns1.png)

There are two key elements in this structure; CodeWriter and LanguageElement - the latter looking like this:

```csharp public interface ILanguageElement { ILanguageElement Parent { get; set; } void AddChild(ILanguageElement element); void Write(ICodeWriter writer); } ```

Almost everything sitting inside the JavaScript namespace are language elements of some kind - to some extent some of them being a bit more than just a simple language element, such as the Observable type we have which is a specialized element for [KnockoutJS](http://www.knockoutjs.com). Each element has the responsibility of writing themselves out, they know how they should look like - but elements aren't responsible for doing things like ending an expression, such as semi-colons or similar. They are focused on their little piece of the puzzle and the generator will do the rest and make sure to a certain level that it is legal JavaScript.

The next part os as mentioned the CodeWriter:

```csharp public interface ICodeWriter { void Indent(); void Unindent(); void WriteWithIndentation(string format, params object\[\] args); void Write(string format, params object\[\] args); void NewLine(); } ```

Very simple interface basically just dealing with indentation, writing and adding new lines.

In addition to the core framework for building the core structure, we've added quite a few helper methods in the form of extension methods to much easier generate common scenarios - plus at the same time provide a more fluent interface for putting it all together without having to have .Add() methods all over the place.

So if we dissect the code for generating the proxies for what we call queries in [Bifrost](http://bifrost.dolittle.com) (queries run against a datasource, typically a database):

```csharp public string Generate() { var typesByNamespace = \_typeDiscoverer.FindMultiple&lt;IReadModel&gt;().GroupBy(t =&gt; t.Namespace); var result = new StringBuilder();

Namespace currentNamespace; Namespace globalRead = \_codeGenerator.Namespace(Namespaces.READ);

foreach (var @namespace in typesByNamespace) { if (\_configuration.NamespaceMapper.CanResolveToClient(@namespace.Key)) currentNamespace = \_codeGenerator.Namespace(\_configuration.NamespaceMapper.GetClientNamespaceFrom(@namespace.Key)); else currentNamespace = globalRead;

foreach (var type in @namespace) { var name = type.Name.ToCamelCase(); currentNamespace.Content.Assign(name) .WithType(t =&gt; t.WithSuper(&quot;Bifrost.read.ReadModel&quot;) .Function .Body .Variant("self", v =>; v.WithThis()) .Property("generatedFrom", p => p.WithString(type.FullName)) .WithPropertiesFrom(type, typeof(IReadModel))); currentNamespace.Content.Assign("readModelOf" + name.ToPascalCase()) .WithType(t => t.WithSuper("Bifrost.read.ReadModelOf") .Function .Body .Variant("self", v => v.WithThis()) .Property("name", p => p.WithString(name)) .Property("generatedFrom", p => p.WithString(type.FullName)) .Property("readModelType", p => p.WithLiteral(currentNamespace.Name+"." + name)) .WithReadModelConvenienceFunctions(type)); }

if (currentNamespace != globalRead) result.Append(\_codeGenerator.GenerateFrom(currentNamespace)); }

result.Append(\_codeGenerator.GenerateFrom(globalRead)); return result.ToString(); } ```

Thats all the code needed to get the proxies for all implementations of an interface called IQueryFor<>, it uses a subsystem in [Bifrost](http://bifrost.dolittle.com) called [TypeDiscoverer](https://github.com/dolittle/Bifrost/blob/master/Source/Bifrost/Execution/TypeDiscoverer.cs) that deals with all types in the running system.

**Retrofitting behavior, after the fact..**

Another discovery we've had is that we're demanding more and more from our proxies - after they showed up, we grew fond of them right away and just want more info into them. For instance; in [Bifrost](http://bifrost.dolittle.com) we have [Commands](http://en.wikipedia.org/wiki/Command_pattern) representing the behavior of the system using [Bifrost](http://bifrost.dolittle.com), commands are therefor the main source of interaction with the system for users and we secure these and apply validation to them. Previously we instantiated a command in the client and asked the server for validation metadata for the command and got this applied. With the latest and greatest, all this information is now available on the proxy - which is a very natural place to have it. Validation and security are knockout extensions that can extend observable properties and our commands are full of observable properties. So we introduced a way to extend observable properties on commands with an interface for anyone wanting to add an extension to these properties:

```csharp public interface ICanExtendCommandProperty { void Extend(Type commandType, string propertyName, Observable observable); } ```

These are automatically discovered as with just about anything in [Bifrost](http://bifrost.dolittle.com) and hooked up.

The end result for a command with the validation extension is something like this:

\[code language="javascript"\] Bifrost.namespace("Bifrost.QuickStart.Features.Employees", { registerEmployee : Bifrost.commands.Command.extend(function() { var self = this; this.name = &quot;registerEmployee&quot;; this.generatedFrom = "Bifrost.QuickStart.Domain.HumanResources.Employees.RegisterEmployee"; this.socialSecurityNumber = ko.observable().extend({ validation : { "required": { "message":"'{PropertyName}' must not be empty." } } }); this.firstName = ko.observable(); this.lastName = ko.observable(); }) }); ```

**Conclusion** As I started with in this post; this has proven to be one the most helpful things we've put into Bifrost - it didn't come without controversy though. We were met with some skepticism when we first started talking about, even with claims such as "... it would not add any value ...". Our conclusion is very very different; it really has added some true value. It enables us to get from the backend into the frontend much faster, more precise and with higher consistency than before. It has increased the quality of what we're doing when delivering business value. This again is just something that helps the developers focus on delivering the most important thing; business value!

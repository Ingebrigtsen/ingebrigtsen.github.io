---
title: "Persistent Objects Part 2"
date: "2004-08-06"
categories: 
  - "csharp"
---

Another aspect of creating persistent objects is the ability to design these through a visual designer such as the DataSet editor in Visual Studio. One way to go about using the same designer and get an output consisting of your objects instead of a strongly typed dataset would be to create your own custom tool.

Creating your own custom tool that generates code in Visual Studio .net 2003 is somewhat interesting. Microsoft removed or made a class private in the plugin architecture of the editor that was very helpful. The class I'm referring to is the 'BaseCodeGeneratorWithSite' base class for code generator custom tools. But a quick search on Google gives you the class along with a tutorial on how to write the plugin.  
[http://www.drewnoakes.com/snippets/WritingACustomCodeGeneratorToolForVisualStudio/](http://blog.dolittle.com/ct.ashx?id=ed5fda5d-1e97-4509-befe-01e3752f9f2c&url=http%3a%2f%2fwww.drewnoakes.com%2fsnippets%2fWritingACustomCodeGeneratorToolForVisualStudio%2f)

The custom tool has to implement the GenerateCode() method and do the magic. As input to this method you get the file content of the XSD file. This content can easily be transformed into whatever code you'd like. For instance, if you'd like to keep the DataSet functionality but want the dataset to be a bit smarter you can use the TypedDataSetGenerator class found in System.Data to generate a CodeDOM of the dataset and just walk this and modify the parts you want to have smarter. One thing it could do is to let all your rows have the persistent object attributes attached to it as mentioned in my other blog about Persistent Objects ([http://blog.dolittle.com/PermaLink.aspx?guid=71e1b6fd-59bf-41a5-8c33-cde01dbf9899](http://blog.dolittle.com/ct.ashx?id=ed5fda5d-1e97-4509-befe-01e3752f9f2c&url=http%3a%2f%2fblog.dolittle.com%2fPermaLink.aspx%3fguid%3d71e1b6fd-59bf-41a5-8c33-cde01dbf9899)).

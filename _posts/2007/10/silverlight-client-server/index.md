---
title: "Silverlight - client / server"
date: "2007-10-31"
categories: 
  - "net"
  - "csharp"
tags: 
  - "silverlight"
---

I've been brewing on an idea lately that I'm going to start prototyping as soon as I have a spare hour or two.. :)  

What if we had a server side representation of the the user interface from a Silverlight application. Let's say you have a DataGrid control in your silverlight application and you want to databind this to the server without having to go through a WebService, wouldn't it be need if you could do :

<DataGrid x:Name="myDataGrid" Server:DataRowChanged="myDataGrid\_DataRowChanged"/>

In your server code you would just do :

protected void myDataGrid\_DataRowChanged(object sender, DataRowChangedEventArgs e)  
{  
}

What I would then like to have in my Visual Studio solution/project explorer is 3 files :

Page.xaml  
Page.xaml.client.cs  
Page.xaml.server.cs

Why would this be handy you say..   Well..  I would get rid of a lot of boiler plate code that I would have to do every time I wanted a scenario where I connect data for instance from the server to the client.

---
title: "Balder gets declarative"
date: "2009-10-28"
categories: 
  - "net"
  - "3d"
  - "balder"
  - "csharp"
  - "gamedevelopment"
  - "wpf"
tags: 
  - "silverlight"
---

We're getting closer to the BETA mark for Balder, and we're starting to get most of the features we want in for version 1 ready. The latest feature is the ability to declaratively through Xaml get Balder up and running. Current release is versioned 0.8.7 and can be found over at the [Balder](http://balder.codeplex.com) page at Codeplex.

By adding the following namespace declaration in your Xaml file:

\[code:c#\]xmlns:Core="clr-namespace:Balder.Core;assembly=Balder.Core.Silverlight"\[/code\] 

You now get a set of extra controls that can be used.

First off is the RenderingContainer:

\[code:c#\]  
<balder:RenderingContainer x:Name="\_renderingContainer" Width="800" Height="600" BackgroundColor="Black"/>   
\[/code\] 

You need to specify the Width and Height, as that is used to setup the display properly. The BackgroundColor property can be any color, including transparent - which is great if you want to mix with existing Silverlight controls on your page. 

The next control we've added is the Mesh control, it enables you to add any Mesh from a file/resource to the RenderingContainer. You do this by accessing the Nodes property on the Container and putting up a RenderedNodeCollection and put your Mesh(es) within that.

\[code:c#\]  
<balder:RenderingContainer.Nodes>  
       <balder:RenderedNodeCollection>  
             <balder:Mesh x:Name="\_audi" AssetName="audi.ASE"/>  
        </balder:RenderedNodeCollection>  
</balder:RenderingContainer.Nodes>  
\[/code\] 

For now, there is a limited amount of DependencyProperties exposed, so manipulation via Storyboards aren't possible today, but will be very soon. The only way to access this is by hooking up the Updated event on the RenderingContainer and implement codebehind logic for it, something like this:

\[code:c#\]  
private float \_angle = 0f;  
  
private void Updated(RenderingContainer renderingContainer)  
{  
    \_audi.Node.World = Matrix.CreateRotationY(\_angle);  
    \_angle += 0.5f;  
    \_renderingContainer.Camera.Position = new Vector(0,-5,-20);  
}  
\[/code\] 

Last but not least, to get it all working, you need to initialize Balder. In your App.xaml.cs file, during the Application\_Startup event, you need to add one line of code. It is very important for now that you add that line before your page (RootVisual) is created and set.

\[code:c#\]  
  private void Application\_Startup(object sender, StartupEventArgs e)  
  {  
   TargetDevice.Initialize();  
   RootVisual = new Page();  
  }  
\[/code\]

I you want to use it the "conventional" way - non Xaml based, you need to add a similar line of code, but that line of code needs to be added after the page has been created. This is something that makes absolutely no sense and is something we're trying to fix and make it a lot more sense. Our goal is to get rid of that line of code all together.

A little note, we're not trying to mimick the WPF 3D namespaces at all, we're going our own direction. We don't feel the urge to replicate those, as the purpose of Balder is very different.

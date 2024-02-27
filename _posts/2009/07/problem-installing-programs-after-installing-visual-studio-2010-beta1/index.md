---
title: "Problem installing programs after installing Visual Studio 2010 beta1?"
date: "2009-07-15"
categories: 
  - "net"
  - "general"
  - "wpf"
---

I'm working on a WPF 4 project, targetting .net 4 and need to use Visual Studio 2010 beta1 for this. For now I've been handcoding all my Xaml (I know, the designer in VS2010 is quite good - but I kinda love doing Xaml), but I wanted to do some more advanced graphics and I am somewhat used to working with Blend for doing that. So I decided to download the Blend 3 Trial and get going. Only thing was that the installer kept saying "Another installation is in progress. You must complete that installation before continuing this one". I downloaded the [Windows Installer Cleanup Utility](http://support.microsoft.com/default.aspx?kbid=290301) , but it didn't solve anything. In fact, I couldn't install it even, since it was a Windows Installer, had to install it on another computer and copy the files. ![Tongue out](images/smiley-tongue-out.gif "Tongue out")

The event viewer was referring to the 'VSTA\_IDE\_12590\_x86\_enu' component and a missing directory. This is a package installed by Visual Studio, called Microsoft Visual Studio for Applications 2.0. 

Turns out, the solution is really simple. Just create the directory and try installing again, in my case I had to reboot and then do the installation of Blend. 

And, by the way, if you want to open your project in Blend 3, you need to change the target framework to something that Blend recognize, 3.5 or less. Read more over at [Charles Sterling's blog](http://blogs.msdn.com/charles_sterling/archive/2009/05/21/running-blend-3-0-with-visual-studio-2010-beta1.aspx).For me, I must maintain a seperate .net 3.5 project for my frontend for working with Blend as I am targetting .net 4.

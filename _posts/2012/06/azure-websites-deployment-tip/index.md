---
title: "Azure WebSites - deployment tip"
date: "2012-06-09"
categories: 
  - "azure"
---

The latest [preview](http://weblogs.asp.net/scottgu/archive/2012/06/07/meet-the-new-windows-azure.aspx) of Azure looks really good, very impressed with what they've accomplished and Microsoft seem to be doing a great job with catching up with their competitors. Personally I'm using a few cloud offerings already, including Amazon for Virtual Machine handling - since their VMs have been persistent and Azures has not been up till this release. Also I'm using AppHarbor for the ease of deploying web sites, but am now in the process of considering Azure for this as well. 

I signed up for all the preview features and got them one by one within hours of signing up, and I must admit I got really impressed with the ease of getting things up and running. It is totally comparable to both AppHarbor and Heroku. I did however run into one tiny little problem, not sure if this is something that is common or not. Inside the CSProj file for a Web project, it holds an import statement for importing the default WebApplication targets that will help build the Web site for ASP.net. In mine the line was : 

![NewImage](images/vs2010webappimport.png)

It needed to point to the 32 bit build extension path

![NewImage](images/vs2010webappfix.png)

This might not be a problem one gets if using Visual Studio, but might be just related to the fact that I do most of my .net development in MonoDevelop.  Anyways, doing that certainly made it all build and was running smoothly in a matter of seconds after that. 

If you haven't had the time to get started with Azures new WebSite feature, [Maarten Balliauw](http://blog.maartenballiauw.be) has a great [post](http://blog.maartenballiauw.be/post/2012/06/07/GitHub-for-Windows-Azure-Websites.aspx) for setting it up - although, the UI on the new Azure portal is just really intuitive.

Time to explore Azure a bit more - looking good so far!

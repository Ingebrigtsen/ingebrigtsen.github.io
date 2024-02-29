---
title: "Community Server module for embedding Silverlight 1.1 to posts"
date: "2007-07-26"
categories: 
  - "net"
  - "csharp"
tags: 
  - "silverlight"
---

I figured I just jump into it; creating a Community Server 2007 module for rendering Silverlight content.

It all started up yesterday as a simple thing, but I figured that I didn't feel comfortable with the way the plugin system worked in Community Server, so I created a small abstraction from it to make it feel more right for me. :)   It's all based upon attributes instead of hooking up events. The reason I started doing the abstraction was that I have a couple of modules I need in the pipeline and wanted to simplify stuff I will be needing for all modules, such as filtering for ApplicationType.

The module code turns out as follows (I've attached the entire project with source and binaries)

```csharp
[Module("SilverlightModule")]
public class SilverlightModule : BaseModule
{
  private static readonly string SilverlightScript = "Silverlight";
  private static readonly string SilverlightApplicationScript = 
                      "SilverlightApplication";

  [Method(MethodType.PreRender)]
  [MethodType(MethodType.PreRender)]
  [ApplicationType(ApplicationType.Weblog)]
  [ApplicationType(ApplicationType.ContentManagement)]
  public string Render(string protocol,string xamlUri)
  {
    string completeUri = protocol + ":" + xamlUri;

    Page page = MethodContext.Current.Page;

    if (!page.ClientScript.
        IsClientScriptBlockRegistered(SilverlightScript))
    {
      page.ClientScript.
        RegisterClientScriptBlock(  typeof(SilverlightModule), 
                      SilverlightScript, 
                      Resources.Silverlight, true);
    }

    if (!page.ClientScript.
        IsClientScriptBlockRegistered(SilverlightApplicationScript))
    {
      page.ClientScript.
        RegisterClientScriptBlock(  typeof(SilverlightModule), 
                      SilverlightApplicationScript, 
                      Resources.SilverlightApplication, 
                      true);
    }

    Guid applicationGuid = Guid.NewGuid();

    string hostName = "SilverlightControlHost_"+applicationGuid.ToString();

    completeUri = completeUri.Trim();

    return 
    "<div id="" + hostName + "" style="background-color:Black" >" +
    "<script type="text/javascript" style="background-color:Black">" +
    "createSilverlight(""+completeUri+"",""+applicationGuid.ToString()+"");" +
    "</script>" +
    "</div>";
  }
}
```

![CommunityServermoduleforembeddi.1toposts_780E_image_1](images/CommunityServermoduleforembeddi.1toposts_780E_image_1.png)

**Installation instructions :**

Copy the binary (DoLittle.CS.Modules.dll) into the bin directory of your Community Server installation. Add the following line to your communityserver.config file :

<add name\="SilverlightModule" type\="DoLittle.CS.Modules.SilverlightModule, DoLittle.CS.Modules"/>

Then you have the SilverlightModule up and running.

To use it you simple write \[SilverlightModule: protocol:uri\] in your editor.

protocol : http, https uri : The uri for the XAML to use

Sample : \[SilverlightModule: [http://www.dolittle.com/Silverlight/3D/Page.xaml](http://localhost:8080/silverlight/3D/Page.xaml)\]

Remember to use the unlink button for the Uri. Community Server editor and most other editors will automatically translate the Uri and add a href around it.

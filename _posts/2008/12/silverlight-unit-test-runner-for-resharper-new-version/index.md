---
title: "Silverlight Unit Test Runner for ReSharper - new version"
date: "2008-12-11"
---

Its been a busy couple of months, which has put a serious break on my ability to contribute to anything but my work. But I had some hours left over and figured I'd do an update for the Silverlight Unit Test Runner for the framework made by [Jeff Wilcox](http://www.jeff.wilcox.name/). It has now been updated to the latest version of the framework that is included in the December 2008 release of Silverlight Toolkit (download the source and you'll find the binaries).  
  
The runner is pretty crude still, and has the same shortcomings as before. This is something I will address as soon as I cross the deadline barrier of the current project I'm on.  
  
Anyhow, the binaries can be found [here](/Downloads/ReSharper_Silverlight_UnitTest_Runner.zip).  
  
Installation notes:  
  

- Close any open Visual Studio 2008 instances  
    
- Create a directory called SilverlightUnitTestRunner in the C:Program FilesJetBrainsReSharperv4.xBinPlugins directory. If you don't have a plugins directory, create it.
- Uncompress the ZIP file and put them in the created directory.
- Put the Cassini.dll file in your Global Assembly Cache (open explorer, browse to c:WindowsAssembly and drag the file into here). 

Voila. You should be good to go. Your unit tests should pop up in the Unit Test Explorer and you can start running them. Mind you, that they will take a little longer to run than other tests running in the unit test explorer. This is something I will try to figure out how to optimize.  
  
Also, if you're interested in the source code for the project, it is available [here](http://www.codeplex.com/SilverlightRunners).

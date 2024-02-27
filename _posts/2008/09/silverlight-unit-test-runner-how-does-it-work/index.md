---
title: "Silverlight Unit Test runner - how does it work?"
date: "2008-09-23"
---

Before I tidy up everything and publish the source code for the [Silverlight Unit Test runner](/post/2008/09/21/Silverlight-UnitTest-runner-for-Jetbrains-ReSharper.aspx), I thought I'd let you all in on the secret behind it and how it actually works.  
  
The runner is a plugin built for the ReSharper plugin for Visual Studio (a plugin within a plugin - cool). Whenever you open the unit test explorer or do a change and recompile your code, the ReSharper mechanism is to call all plugins and let them gather information about the compiled assemblies and decide if it is a test assembly and then gather the test classes/fixtures and methods for ReSharper. Once this information is gathered, one needs to provide rendering facilities for ReSharper to render the tests in the unit test explorer or other windows it find appropriate.  
  
Then, when you choose to run your tests (either a selection, or all), the plugin starts its trip into some really strange hoops. First we start by copying a specialized test execution engine written in Silverlight and a testpage for it to the destination folder of the test project, typically bindebug under the test projects directory. Then the plugin instantiates Cassini and sets its root path to point to the same location as mentioned before. A windows form is then created with a browser plugin within it and the URL given is the TestPage for the test execution engine previously copied with an additional request string following it with information about what tests to run. The test execution engine hooks up a LogProvider for the test framework by Jeff Willcox and then dynamically loads the XAP for the real test project written by the user and creates a visual for this to be used as the visual root for the application. Now, the tests will run and give feedback to the LogProvider which gathers all the results into an XML. After completing running all the tests, the XML with all the results in it is added to a programatically created DIV object into the DOM of the enclosing testpage.  
  
Back in the plugin we are "listening" to the page and look into the DOM to see if the DIV appears, once this appear we have our result. We parse this result and convert it into ReSharper results and send it back to an internal manager for the plugin. Once ReSharper asks for the result on a callback for all the methods, we ask the manager what the result is and then hand this over.  
  
My original idea was to host a WCF service inside the plugin and let the test execution engine in Silverlight contact the WCF service with results async. This could possibly give a better user experience and give test results as the tests were run. But I guess for now, the way it is implemented works out fine.
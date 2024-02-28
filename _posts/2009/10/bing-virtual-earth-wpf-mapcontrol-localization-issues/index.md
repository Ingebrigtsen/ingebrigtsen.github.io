---
title: "Bing / Virtual Earth WPF MapControl - Localization issues"
date: "2009-10-24"
categories: 
  - "net"
  - "csharp"
---

I just got an email from a guy that watched my WPF talk on the MSDN Live tour in Trondheim, he had downloaded one of my samples from that talk and gave it a go. But he constantly got this "Script Error" thing. The demo was using the WPF MapControl for Virtual Earth maps. It worked OK in all browsers he had tried. Kinda odd I thought. 

The error message was "String was not recognized as a valid boolean". I googled the error message without any concrete results.

Then it struck me; "could it be... Naahh.. It couldn't,  lets try switching regional format settings.." - I always set mine to English - U.S., without really having any good reason for doing so, seeing that I live in Norway. Anywho, I switched it to Norwegian, and there the same error was. 

The simple solution, codewize, is to set the CurrentCulture to be Invariant:

```csharp

System.Threading.Thread.CurrentThread.CurrentCulture = CultureInfo.InvariantCulture; 

``` 

I haven't had time to investigate why this happens, but it sure is kinda odd, since running the map in a browser works and the WPF Control is in fact just a WebBrowser control, using the same browser.

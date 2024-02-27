---
title: "OpenCompiler project"
date: "2009-03-28"
---

Ever since I saw the capabilities of the Boo programming language and their eco-system, I've been constantly asking myself; Why don't we have these posibilities with C#. The ability to extend the language with macros or even further to give your code more expressiveness and solve domain specific limitations to the language itself, feels to me so natural and the correct path to go down.  
  
The concept is really not a new one, but with Boo they've made it more seemless and it feels more natural. C/C++ and other languages has had macros from day one, but they've been limited to just expand into their own context and not be able to modify anything. With Boo you get the oportunity to actually modify the entire AST tree during compilation. This is the feature I am really missing, if you wonder about why I want it, you can read [this post](/post/2008/11/03/Compiler-extensions-is-just-another-framework.aspx) or [this](/post/2009/01/05/Why-compiler-extensions-shouldnt-be-scary.aspx).  
  
With this as a backdrop, one sunday afternoon I found myself in front of the computer (no surprise there) and was pondering about this. I had looked at the Mono compiler for a while, to see if it was at all possible to sneak in the posibilities into that one. Then my crazy head started to think; what if I wrote my own, at least I could try - nothing to lose. So, I started looking around the net to get inspiration and to find good articles about how to write your own compiler - and I came across an article by Joel Pobar on [MSDN](http://msdn.microsoft.com/en-us/magazine/cc136756.aspx) that really inspired me and made me think it would be possible.  
  
After a couple of weeks of working on it, on and off, I figured out it was about to take shape and maybe, just maybe, it had a chance of surviving in the jungle of projects I tend to start up (but not finish). So, today I went to Codeplex and established a project with the catchy name of OpenCompiler (probably a million projects named this already. :) ) and uploaded the source thus far. You'll find the project [here](http://www.codeplex.com/opencompiler).  
  
**The road ahead**  
So far, what the compiler is able to do is to recognize most of the C# grammar in the scanning phase of the lifecycle. This is converted to something that the parser can understand and make more sense of. The parser then builds the AST tree consisting of all the things that can be generated for the IL code. The last week I've been working on making the AST tree complete with regards to which elements needed.  
  
So far, this is at a level were I am still hoping it is possible to do this. My main doubts are not with regards to wether or not it is technical possible, but will it be a project that is doable in the sense that I can spend enough time on it to actually make a version 1.0. Time will tell. I've decided to focus my sparetime energy these days on this project, because I think it is important - and it will ultimately make the code I write from day to day look better and more expressive.  
  
I'll be posting more details about the project as I work on it, to document what I'm thinking and how I want to things, hopefully I'll get some input from the ones reading the posts to guide me in the right direction. This is the first time ever I try to write a compiler of this magnitude.  
  

![](http://img.zemanta.com/pixy.gif?x-id=2f4be536-94bb-817b-ad67-6ababd54a24d)

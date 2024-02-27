---
title: "Machine Specifications - .NET Core"
date: "2016-04-16"
categories: 
  - "net"
  - "csharp"
---

I’ve been working on a particular project, mostly in the design phase - but leading up to implementation I quickly hit a snag; my favorite framework and tools for running my tests - or rather, specs, are not in the .NET Core space yet. After kicking and screaming for my self for the most part, I decided to do something about it and contribute something back after having been using the excellent [Machine.Specifications](https://github.com/machine) Specification by Example framework and accompanying tools for years.

The codebase was not really able to directly build on top of .NET Core - and I started looking at forking it and just #ifdefing my way through the changes. This would be the normal way of contributing in the open source space. Unfortunately, it quickly got out of hand - there simply are too many differences in order for me to work fast enough and achieve my own goals right now. So, allthough not a decision I took lightly; I decided to just copy across into a completely new repository the things needed to be able to run it on .NET Core. It now lives [here](https://github.com/einari/Machine.Specifications.Core).

Since .NET Core is still in the flux, and after the announcement of DNX being killed off and replaced by a new .NET CLI tool called dotnet - I decided to for now just do the simplest thing possible and not implement a command or a test framework extension. This will likely change as the tools mature over time. Focused on my own feedback loop right now.

Anywho, the conclusion I’ve come to is that I will have my own test/spec project right now be regular console apps with a single line of code executing the all the specs in the assembly. This is far from ideal, but a starting point so I can carry on. The next logical step is to look at improving this experience with something that runs the specs affected by a change either in the unit under test or the spec itself. If you want a living example, please have a look [here](https://github.com/Cratis/Core/tree/master/Specifications).

Basically - the needed bits are Nuget packages that you can find [here](https://www.nuget.org/packages/Machine.Specifications.Core.Runner.CLI), [here](https://www.nuget.org/packages/Machine.Specifications.Core) and [here](https://www.nuget.org/packages/Machine.Specifications.Should.Core).  
The first package do include a reference to the others. But right now the tooling is too flaky to predict wether or not intellisense actually works using things like OmniSharp with VSCode or similar, so I have been explicitly taking all three dependencies.

The next thing you need is to have a Program with a Main method that actually runs it by calling the AssemblyRunner that I’ve put in for now.

<img data-position="3" src="http://localhost:8080/wp-content/2016/04/2016-04-16\_23-55-21.png" data-mce-src="2016-04-16\_23-55-21.png"

Once you have this you can do a dotnet run and the output will be in the console.

<img data-position="3" src="http://localhost:8080/wp-content/2016/04/2016-04-16\_23-40-52.png" data-mce-src="2016-04-16\_23-40-52.png"  

  

# .NET Core Version

Important thing to notice is that I’ve chosen to be right there on the bleeding edge of things, taking dependencies on packages and runtime versions from the MyGet feeds. The reason behind this is that some of the things that I’m using only exist in the latest bits. Scott Hanselman has a great [writeup](http://www.hanselman.com/blog/AnUpdateOnASPNETCore10RC2.aspx) with regards to where we are today with .NET Core.

  

# Future

Well, I’m not yet knee deep into this and not focusing my effort on this project. I’ll be building what I need, but of course - totally open to anyone wanting to contribute to this project. But if I were to say anything about my own vision and steps I can see right now that would be natural progressions for this it would be that I’d love to see the first step be an auto-watching CLI tool that will run the appropriate tests according to files being changed. I would not go all in and do a full analysis of call stacks and all to figure out what is changing, but rather have an approximation approach to it - similar to what we put in place for our test runner project for JavaScript called [Forseti](https://github.com/dolittle/forseti). The approximation was basically based on configurable conventions mapping a relationship between the systems under test and the tests - or specs as I prefer to refer to them as. After that I can see integration with VSCode - which is my favorite editor at the moment. Something similar to [WallabyJS](http://wallabyjs.com/) would be very cool.

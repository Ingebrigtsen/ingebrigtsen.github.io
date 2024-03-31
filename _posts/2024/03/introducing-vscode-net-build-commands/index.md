---
title: "Introducing VSCode NET Build Commands"
date: "2024-03-31"
categories: 
  - "net"
  - "csharp"
  - "vscode"
  - "extensions"
tags: 
  - "c#"
  - "productivity"
---

## TL;DR

I've made a VSCode extension to make build tasks and launch configuration easier to maintain.
You can find it [here](https://marketplace.visualstudio.com/items?itemName=einari.dotnet-build-commands).

## Why

It all started with an itch, as it always does. I've been using VSCode as my primary code editor ever since its release in 2015.
Being a C# developer in that ecosystem has been a bit of a bumpy ride with varying levels of commitments from Microsoft themselves.
This all turned around when they introduced the [C# Dev Kit](https://learn.microsoft.com/en-us/visualstudio/subscriptions/vs-c-sharp-dev-kit).
With this the development environment became more consistent, had better support for the things you'd expect and in general also
increased stability.

However, one of the big benefits of VSCode, in my opinion, is the flexibility. I can pretty much configure it however I'd like, bring
in the plugins I want and quite easily extend it to meet my needs.

Back to my itch. Compiling/building and debugging has historically been done through the `tasks.json` and `launch.json` files.
With these files you get fine grained control over everything, which is great. I for one am a sucker for tight feedback loops and
want my build processes to take as little time as possible and tend to then turn off the automatic restore every time I build (`--no-restore`).
The biggest challenge with these files however is that you have to add configurations manually for every project you want to build
in your repository. The same goes for debug configurations in the `launch.json` file. This becomes very tedious, and also I would argue,
a bit hard to maintain if you want to add a command-line switch or something.

With the **C# Dev Kit** you don't really need to have any of these files, as it has the new **Solution explorer** which then supports
at least debugging a specific project and it will also automatically build the solution file you have open.

There are a couple of things I personally didn't like.

* I lost control over arguments I could pass along and general customization for my build tasks or launch configuration
* Lack of building or debugging a specific project
* Lack of building a project in the context of the currently open file

With these requirements I started down a rabbit hole of trying to find existing solutions or try to combine existing extensions to
get to what I want. I found the [Command Variable](https://marketplace.visualstudio.com/items?itemName=rioj7.command-variable) extension
and tried combining it with the [Tasks Shell Input](https://marketplace.visualstudio.com/items?itemName=augustocdias.tasks-shell-input) extension
for populating the projects I wanted to show up for building.

Due to limitations of nested `inputs` in VSCode, I couldn't get it to work. Thats how this all came about.

Hope you enjoy it.

Love to hear from you, give feedback or report any issues on the official [GitHub repository](https://github.com/einari/dotnet-build-commands) for it.

---
title: "TFS - Source Control Move of builds - Ultimate Automagic"
date: "2008-02-22"
---

I've been working quite a bit the last two weeks with setting up a continuous integration build regime at work along side a big refactoring job that includes a lot of files and directories moving about.

In TFS2005 the default path for builds was $<your project>TeamBuildTypes<build name>. This is more customizable in TFS2008 and I wanted to take advantage of that. I figured that our build types should be within the branch, so that when we're branching out we can branch out even the build types. Using the Source Control Explorers move action, I started moving about our builds. The next thing I needed to do was to update the build definition by going to the Team Explorer in Visual Studio and rightclicking the build I wanted to edit and choose to edit the build definition. Selected the project file page. Much to my surprise, the path for the project file has already been updated. Turns out that the build part of TFS figured out I moved the files and decided to update this automagically. Quite a nice feature, if you ask me. Saved me a bit of work, seeing that we have a few builds.

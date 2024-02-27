---
title: "Balder switching to GITHub for SourceControl"
date: "2009-10-23"
categories: 
  - "3d"
  - "balder"
tags: 
  - "silverlight"
---

The last week or so, we've been hard at work on Balder to reorganize the source repository and move it to GITHub. The reason we want to do this are many, but one of the most important reasons is to enable anyone to be able to contribute to the project and give the core developers greater control for picking changes/patches done to the source and push it into the master/trunk branch.

For now we will be pushing all changes back to the [Balder](http://balder.codeplex.com) project on CodePlex as well, so anyone that just downloads the source will still find it over there.

During this transition we had really big trouble getting the synchronization between the repositories, even when we want the CodePlex one to be "slave" and no changes will be committed directly to CodePlex. We got errors that was not possible to get any response from Google on (must admit, never tried to Bing them), so we ended up having to totally purge all the source at CodePlex and push it back manually.

We've created a tutorial for getting started [here](http://balder.codeplex.com/wikipage?title=ContributeTutorial&referringTitle=SourceCode) and if you need details on GIT and how we do branching with it, you can read [here](http://balder.codeplex.com/wikipage?title=RepositoryGuide&referringTitle=ContributeTutorial).

---
title: "Xbox Live GamerCard .net class (C#)"
date: "2008-01-06"
categories: 
  - "csharp"
---

A friend of mine; Dan Strandberg put together a nice Vista Sidebar gadget for showing your Xbox Live GamerCard (Look [here](http://gamecamp.no/blogs/news/archive/2008/01/05/windows-vista-gamercard-gadget.aspx)).

I couldn't resist creating a C# class that can be used from any .net application to extract all the data. Based upon Dans (nice regexes.. :) ) work I've put together a simple class that one can use for this purpose (download [here](http://localhost:8080/wp-content/2008/01/XboxLiveGamerCard.netclassC_12020_GamerCard.zip)). I've also put together a simple WinForms application that uses it (download [here](http://localhost:8080/wp-content/2008/01/XboxLiveGamerCard.netclassC_12020_GamerCardForm.zip)).

[![XboxLiveGamerCard.netclassC_12020_image_2](images/XboxLiveGamerCard.netclassC_12020_image_2.png)](http://localhost:8080/wp-content/2008/01/XboxLiveGamerCard.netclassC_12020_image_2.png)

The usage is very simple :

```
GamerCard.Loaded += new GamerCardLoadedEventHandler(GamerCard_Loaded);
GamerCard card = GamerCard.Create("Adept DoLittle");
```

```
void GamerCard_Loaded(GamerCard gamerCard)
{


}
```

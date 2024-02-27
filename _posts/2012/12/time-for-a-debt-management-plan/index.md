---
title: "Time for a debt management plan?"
date: "2012-12-02"
categories: 
  - "code-quality"
---

Lately I've been getting negative feedback from talking about technical debt. I've been trying to go over it in my head why it would be considered negative, and what spawns the idea of it being a negative thing. I really can't figure out why it would ever be considered bad to have technical debt, so instead of trying to figure out why people would consider it a bad thing, I'll try to shed some light on what technical debt in reality is.

I'm going to start off by saying; technical debt is something that all projects have, no matter how recent the project was created. In fact, I would probably argue we put in technical debt on a daily basis on all software projects. You might be screaming [WAT](http://www.urbandictionary.com/define.php?term=wat) at this point, and you're fighting the urge to completely disregard this post and move long, because you think I'm talking utter nonsense. But before you do that, I'd like to take the time to lay out what i think classified as technical debt. 

## **// Todo**

Ever sit in your code and you go up against something you really can't fix, its too involved at the current point in time, or the architecture in its current state would not permit it, or plain and simple; you don't have time - you're having a Sprint demo in 1 hour. You end up putting a **// Todo** comment in the code, something to revisit at a later stage. You might not even know when. This falls into the technical debt category. One could even argue that any comment put into the code makes the code technical debt, the reason being - the code is too hard to understand on its own and needs a comment to explain what it is doing. I'll leave the subject of general comments for now, as it should be subject of a different post.

## Legacy code

Just about every system being built out there has some legacy they have to deal with, some data model that you can't get rid of. The art of dealing with legacy code is then to try to come up with an [anti corruption layer](http://www.infoq.com/interviews/Architecture-Eric-Evans-Interviews-Greg-Young) that will keep the legacy in one place. But even having this in place, sometimes things leak through. So things you really didn't want in your new model might be leaking in, it could be anything from a simple property with the wrong name going through your new model to large concepts being misrepresented. All these can be categorised as technical debt.

## Changing horses midstream

Working in software is in my opinion much like being on a high speed train that really don't have a destination but have [railway switches](http://www.ehow.com/info_8453835_parts-railroad-intersection.html) that makes the software change tracks. This can be new way of doing things that the team want to embrace. It could be new knowledge the team acquires that they didn't have before that will make the software better moving forward. Everything being left behind at that point represent technical debt. They are things the team would ideally want to have fixed, but often in the interest of time, they can't go and do it right now.

## Complexity

Another warning sign that makes my bells go off is when something is hard to follow. Unless you're sending spaceships to the moon or other planets, I have a hard time believing that software should be hard to do, understand or follow. Done right, and everything should be very simple. Large methods, large classes, things taking on more than one responsibility, all these are things leading to complexity in the software and making it hard for anyone else but the guy that originally wrote it to understand. In fact, I would even argue that the guy that originally wrote it would have a hard time going back into own complex code. This is typically a situation were the team would like to have it another way, and hence should be categorised as technical debt. 

## Bugs

So, what about bugs then. This is funnily enough something that does not fall into the category. Bugs are defects in the software, functionality that does not work as promised. Sure, it could be a ripple effect thats causing the bug, or clash of bugs, based off other parts of the system being technical debt. But then you should try to identify the real problem and fix that in isolation, not categorise the bug as technical debt. 

## Now what? 

Don't jump into panic just yet, just because you're realising the project you're on seems to suffer from one or more of the above mentioned issues. How do we deal with it? Well, first of all - be honest. When it comes to software development and life in general, I've had great success with just being honest. Be honest with yourself, be honest with your team, be honest with whoever is picking up the bill at the end of the day; **you have technical debt.** And its fine, its actually a good thing, it means the system is evolving, you as a developer is evolving, and probably for the better. Its called progress. You only need to be aware of the technical debt, write it down somewhere - **NOT IN THE CODE** - somewhere making it visible for the entire team. Writing it down and glancing at it during planning, having it in the back of every developers mind makes it so much easier to actually deal with the debt, pay back some of it while moving forward and creating new features or fixing bugs. How you register it and make it visible is not important, whatever works for your team. Personally I prefer simple ways of dealing with this. One project I was on, we started by just putting the technical debt in the form of post-its on a wall. This slowly progressed into becoming a [Trello board](http://www.trello.com) that we had running on a 42" screen all the time. By doing this we had the technical debt available when not sitting in the office, but by putting it on the 42" screen displaying only that made it a focal point. Something the team was focused around, all the time; keeping an eye on the debt - slowly paying back.

Another aspect I find important, not only for technical debt but in general; don't make your code personal. Its not a manifestation of yourself, it is code. The code gets committed into the repository, and it is no longer yours, but the entire teams. The idea that you will be maintaining it for ever is just silly, you might quit your job, or worse things could happen. The code is not yours in that sense, you wrote it, but detach from it!

If for any reason technical debt is a loaded term in your organisation, you might want to consider calling it something else. Don't pretend you don't have the elements mentioned in your solution just because it is a loaded term. Call it something like "wall of shame", or anything that will work within your team and organisation.

## Conclusion

Stop letting technical debt scare you, stop trying to avoid admitting to the fact there is technical debt. We all have it, we all contribute to having it, the only important thing is that it is on our agenda, we need a way to pay it back. Establish your own debt management plan, either in the form of work items in your work item tracking software, post-its on a wall or something that fits you. Get it out there, in the open, its not scary - in fact, I would argue the opposite is scary; not knowing what the debt level is.

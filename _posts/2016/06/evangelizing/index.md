---
title: "Evangelizing"
date: "2016-06-19"
categories: 
  - "code-quality"
tags: 
  - "architecture"
---

A while back I got into a discussion with another developer. The other guy basically critiqued my code because [Angular 1](https://angularjs.org) was so much better than [Knockout](http://knockoutjs.com). It really annoyed me, not because I felt the other person was wrong, or at least not wrong in the sense that I loved Knockout that much. But it annoyed me because its really comparing apples and pears. Sure, both targeting to solve workloads for frontend development on the Web. The arguments presented was very clearly for Angulars ease and against Knockouts idiotic properties being “ko.observable\*”. But fundamentally they are different in its underlying core values and concepts. Knockout aiming for a reactive model with its observables, while Angular not having any reactive model at all and being a MVA (Model View Anything) - not opinionated.

This is what bugs the hell out of me. Since these things are so different, fundamentally - how can one be better than the other? And as a consequence, just because one has found something that makes sense for you, why does it have to be true for everyone else? To me for instance; Angular is just completely weird and can’t understand why one would like it at all.

Lets take a step back; this is not a “Foo Framework” against “Bar Framework”. I’m trying to get to the core of something that I think is way much broader than just software development - but probably more visible in software, seing we have all the options we have. Going back to when I grew up for instance, I was a fan of SONY’s HiFi equipment, while one of my best friends was a JVC fan. We had the weirdest discussions. Enter my third friend who was fan of things no one had ever heard of; NAD, Denon and similar. The discussions got even weirder - not from our third friend, but from the others trying to convince him that he was wrong. You can see this with just about everything - people being so convinced their choice of car is the best, TV and of course religion. It seems that this is part of human nature. And we love to evangelize it and try to convince everyone else we’re right.

Trust me, I’m not taking a high road here; because I do this myself. I find something that I enjoy enough to start “evangelizing” it. This is probably something well defined in psychology already; related to wanting to getting a reinforcement of ones own beliefs and decisions.

  

# Core values

There is nothing wrong with a good discussion and if you’ve discovered something you should of course show it off and see if others find it cool. But if you’re in a team, having these discussions around one thing being better than other can truly be poison. In my oppinion it also reflects a symptom of lack of common core values. The discussion of Angular vs Knockout as described above is a weird one because it really is not about a discussion between the two, but rather about the differences in underlying mindset and core values. If you’re used to and enjoy a particular way of thinking, changing to something else is very hard. For instance, if you’re used to object oriented programming, functional can be too far away to understand.

# Job protection

A scary thing I’ve seen a few times; people get comfortable in their job - so comfortable that they start making up reasons for keeping their beloved way of doing things. The reasons behind this is not always obvious. The ones I’ve encountered have been in two categories.

1. I’ve spent a lot of time learning what I know now and don’t see the point of learning anything new.
2. The company has had success with the way we’ve done things.

For the first reason I’m just going to say “ehh… what…”. That is especially true for our line of work; software development. A relatively young business with so many things changing all the time, and not only changes in software - but the hardware in which the software is running on. Personally I think that is a risky way of going about thinking in our line of business.The second reason; if you’re having success it is really hard to see and even argue that you should change your way. If the business you’re working for is having success, but for instance the software you’re working on hits a snag and you get to the point of getting to rewrite it. Even then, you will have a hard time seeing that you need to do it in a different way; after all - the way you did it worked, because it brought success.

In both cases I think the [boiling frog anecdote](https://en.wikipedia.org/wiki/Boiling_frog) might be the reason behind. Basically, while building something over time - you won’t notice the things that lead to something not really being done in a good way. You’re having many small successes and feel good periods and you simply aren’t noticing that the project is in fact failing. Most projects do tend to have the best velocity in the beginning and slow down over time. Something the team members executing on it won’t notice, because it is happening slowly. But anyone external to the development team is noticing, because their demands for new things have not declined over time but rather increased and often these are the people dealing with the problems as well - while the development team is having a hard time getting through things at the right pace.  

I find what Einstein saying: **[“Insanity: doing the same thing over and over again and expecting different results.](https://www.brainyquote.com/quotes/quotes/a/alberteins133991.html)”** interesting and so true. One gets into discussions with management of needing to recreate the product from scratch, because you’ve identified something that is holding the development back and is too painful to fix. You get to do “File -> New Project” and do it again [using the same kind of thinking we used when we created the problems in the first place](https://www.brainyquote.com/quotes/quotes/a/alberteins385842.html) (referring to another Einstein quote).  

We are so lucky in our profession; there are so many choices - so many ways of doing things. It truly is a luxury.

# Mixing it up

At a place I was we were about to embark on a rewrite. A few of us had discovered some new principles and experienced some pain while doing a small 3-4 month project in isolation. From this two of us were tasked to do a small proof of concept for the larger project, to sketch out a direction and a starting point for a discussion. After doing this we decided on the direction for the project and what fundamentals to go for. To get the team familiar with different thinking, we mixed things up a bit by doing a period of Ruby development. Writing Ruby and discovering the culture of rubyists let us write our C# in a different way when we got back to it.

# Keeping fresh

So, how do you keep fresh thinking? It is hard, it really is. Everyone suggesting everything from kode katas, pair programming, friday lightning talks and all these cool things must realize that it is hard to get there. They are all good ideas and things that can help your team keep fresh. But getting to a place where you can build this type of culture is hard. You need the trust from the business to be able to do so. Also, you probably need to have a certain critical mass of people working together before it can be accomplished. Lets face it, being a development team of one makes this very hard. But it is very doable. It starts with recognizing that one has to keep fresh and on top of things. If you think when you graduated that you didn’t need to learn new things, you need to start with changing your attitude. That attitude won’t push anything forward in terms of new ways of doing things. Innovation comes from being aware of what is going around out there and combining wizdom and build on top of it or go in a different direction from established wizdom - but nevertheless, its about knowledge.

# Breaking it all up...

One way of being able to push forward and try different things to be able to learn new tricks and gain knowledge could be to start breaking your software up into smaller pieces; enter the buzz of the Micro Services. Sure, there is a lot of buzz around this. But cut to the bone; its about breaking monoliths up into smaller digestable pieces. These digestables could be implemented in different ways, in fact - I would argue they should be. Basically because the different parts have different requirements both for business and ultimately also technical. This is a great opportunity to mix things up.

# Back to the value thing...

Remember I said something about core values. I’m convinced this sits at the heart of it. If you get to work and it is a predictable environment in terms of you know you share something with your coworkers. Having the thing you share being core values, rather than the belief in something hard and concrete as a specific technology - you move the discussions to a more healthy level. If your discussion is which of Windows, Linux or OS X is the best operating system, you’re probably not solving the real problems. If you can look past this and past implementational details and start having a solid fundamental that you all believe in - you can move up the stack much more rapidly. Chances are that a lot of the decisions will automatically be made for you if you settle the core value debate first. I’ve blogged about this [before](/2016/04/23/identifying-core-values/) - I have no problem reiterating the importance of this, I think it is at the heart of a lot of silly discussions that could’ve been resolved without them having started.

# Wrapping up...

Is it really important that I drive a Toyota and you drive a Ford? Will the world be a better place if I switched to a Ford? Probably not! Conformity is nothing but just that. It doesn’t really solve any fundamental issues, it covers it up. It is the fundamentals that are different. In software development, these fundamentals are core principles - how you believe software should be written and what makes you productive. This view is a subjective view and it is also a very temporary view. Once you’ve learned new ways of doing things, chances are you look back at your previous knowledge level and laugh or you’re embarressed you ever had that view. If you’re really cool, you even move forward in life and forget you had the view and laugh at people who have the view you had way back… ehh… a whole month ago… Everything is hard until you know it, and then it is the easiest thing in the world. We tend to make a point about it as well. Once we know it, we’re so proud of knowing it that we tell everyone. Knowledge is a moving target, new knowledge emerges - embrace this concept and embrace change. I know I will work for this and aim for getting better at doing better in this area. I have a few comfort zones to break out of and will push forward. Wish me luck!

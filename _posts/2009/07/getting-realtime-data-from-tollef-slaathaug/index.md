---
title: "[Getting realtime data from Tollef Slaathaug]"
date: "2009-07-03"
categories: 
  - "net"
  - "podcast"
---

Tollef Slaathaug is a senior developer at Baze Technology, a software company based in Porsgrunn, Norway. Tollef has great experience with working with optimizations in .net code. This show we're talking about their project and how they have done things to get the desired performance.

<table border="0"><tbody><tr><td><img style="max-width:800px;" src="images/flag_usa.png" alt="" width="64" height="64"></td><td>English</td></tr><tr><td><img style="max-width:800px;" src="images/cd_music.png" alt="" width="94" height="94" border="0"></td><td><a href="http://localhost:8080/wp-content/2012/07/ingebrigtsenshow81.mp3">Download full MP3</a></td></tr><tr><td><img src="images/podcast.png" alt=""></td><td><a href="http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewPodcast?id=304523653">Subscribe on iTunes</a></td></tr></tbody></table>

**Some irrelevant information**

The recording of this show was done a little more than a month ago. Normally I use Oovoo to do the shows with persons sitting remote, it has excellent audio and video quality. This day, my freebie account had expired - instead of opening up a new account, which I should have done (twenty twenty heinsight and all), I decided to use Skype and found a 3rd party software that could intercept Skype calls and save the streams to disk. All nice, so far.

Comes editing day; we had two takes, due to loss of connection and the application had therefore produced two AVI files. All good, at least I thought so. Turns out that it had created AVI files with multiple video and audio streams in them, two streams for video and two for audio, representing both cameras and microphones. Seemed reasonable enough. Only problem is that most editing software didn't figure this out. On top of this, it had used Microsoft MPEG4 for video and audio was supposedly in WMA format, but most applications didn't recognize it.

Anyhow, weeks went by, I went on a holiday, came back and was ready to start editing again. I figured I'd use GraphEdit that was part of the DirectShow and later in the DirectX SDK. Turns out it wasn't there anymore. Googled away and found someone who had created a nice version themselves of it and created a graph and got all the streams out into separate files. I felt really proud of myself.

It was finally time to get it all into GarageBand and edit and get it all out. Trouble was not over. The application I used that hooked into Skype and streamed it all to disk had done something quite interesting. All the four streams I was sitting with had all different framerates, and some pretty obscure framerates as well (30.118 and such). So getting this in there was not something it would cope with.

Long story short, invoking some 10 audio and video tools, I managed to extract the audio in a sensible manner and editing could finally start.

Lesson learned: be wary of nifty tools found, check references. :)

**Notes** The intro and the outro music created by [Kim M. Jensen](http://www.audioplant.no/). Please do not hesitate to leave any comments on this post. If you have ideas for people you'd like to get interviewed, please leave a comment or contact me through the contact page.

![](http://img.zemanta.com/pixy.gif?x-id=5ffd50c1-7a74-8dbd-a51a-69be87c248bb)

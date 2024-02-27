---
title: "VS2008 Xaml designer crash in Parallels"
date: "2008-08-27"
---

I've been struggling the last couple of weeks with the Xaml designer crashing in Parallels.  
Had to revert to VMWare, which I find a bit less user friendly than Parallels and slower.  
  
Turns out, the problem was that I had enabled the experimental hardware accelerated DX9 thingy in Parallels. Turning this off gave me my life back. :) Off to send an email to the Silverlight team to look away from the debug dump they got from me.  
  
So if you're in Parallels - don't enable the option with the big fat warning sign on it. :)

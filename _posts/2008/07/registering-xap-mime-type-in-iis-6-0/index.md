---
title: "Registering XAP MIME type in IIS 6.0"
date: "2008-07-07"
tags: 
  - "silverlight"
---

I’m still running Windows 2003 and IIS 6.0 on my server and needed to register XAP as a global MIME type for my server, seeing that I will be publishing a bit of Silverlight bits now and then. I’ve only come across IIS 7.0 guides for this, so I thought I’d share how to do this in IIS 6.0.

Open up IIS Manager (**mmc %systemroot%system32inetsrviis.msc**). Right click the computer name an select properties.

[![image](images/registeringxapmimetypeiniis6-0_13043_image_thumb.png "image")](http://localhost:8080/wp-content/2012/07/RegisteringXAPMIMEtypeinIIS6-0_13043_image_2.png)

Click the MIME types:

[![image](images/registeringxapmimetypeiniis6-0_13043_image_thumb_1.png "image")](http://localhost:8080/wp-content/2012/07/RegisteringXAPMIMEtypeinIIS6-0_13043_image_4.png)

Click new and type in the following:

[![image](images/registeringxapmimetypeiniis6-0_13043_image_thumb_2.png "image")](http://localhost:8080/wp-content/2012/07/RegisteringXAPMIMEtypeinIIS6-0_13043_image_6.png)

Then you will probably need to reset IIS (run->iisreset or right click computer->All Tasks->Restart IIS).

Now you can deploy your Silverlight 2 XAP application to IIS 6.0.

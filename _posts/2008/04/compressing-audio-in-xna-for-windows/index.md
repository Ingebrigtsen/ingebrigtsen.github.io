---
title: "Compressing audio in Xna for Windows"
date: "2008-04-02"
---

Xna does not support MP3 or WMA, neither on Xbox or Windows. For Xbox you have a format called XMA that is pretty much like WMA on Windows, but for Xna for Windows you have to resort to uncompressed (PCM) or close to uncompressed (ADPCM). This tutorial shows you how you can use ADPCM and get at least some compression for your sounds and save a bit of space. The average compression rate is 27% for the default settings.

We will be using XACT (Microsoft Cross-Platform Audio Creation Tool) that comes with both Xna 1.0 and 2.0.

Create a new project by going to File->New Project (Ctrl +N) and create yourself an empty project.

[![image](images/compressingaudioinxnaforwindows_fb55_image_thumb_1.png)](http://localhost:8080/wp-content/2012/07/CompressingaudioinXnaforWindows_FB55_image_4.png)

You then get a screen looking something like this:

[![image](images/compressingaudioinxnaforwindows_fb55_image_thumb_21.png)](http://localhost:8080/wp-content/2012/07/CompressingaudioinXnaforWindows_FB55_image_6.png)

First we will create a compression preset by right-clicking the compression presets and select new compression preset:

[![image](images/compressingaudioinxnaforwindows_fb55_image_thumb_41.png)](http://localhost:8080/wp-content/2012/07/CompressingaudioinXnaforWindows_FB55_image_10.png)

Give it a name, so you'll recognize it later on in the process.

Now we need to select ADPCM and samples per block:

[![image](images/compressingaudioinxnaforwindows_fb55_image_thumb_51.png)](http://localhost:8080/wp-content/2012/07/CompressingaudioinXnaforWindows_FB55_image_12.png)

We'll leave the samples per block to 128, which is default. The quality of the sound is quite good with this setting.

Now we need to create a wave bank by right-clicking the wave banks in the project and choose new wave bank:

[![image](images/compressingaudioinxnaforwindows_fb55_image_thumb_61.png)](http://localhost:8080/wp-content/2012/07/CompressingaudioinXnaforWindows_FB55_image_14.png)

Leave the default settings for now.

You're then given a window where all your wave files will exist for that particular wave bank. Here we can insert our wave files.  
Just right-click inside the window and choose to insert wave files:

[![image](images/compressingaudioinxnaforwindows_fb55_image_thumb_71.png)](http://localhost:8080/wp-content/2012/07/CompressingaudioinXnaforWindows_FB55_image_16.png)

Select your wave file:

[![image](images/compressingaudioinxnaforwindows_fb55_image_thumb_8.png)](http://localhost:8080/wp-content/2012/07/CompressingaudioinXnaforWindows_FB55_image_18.png)

We can now select the compression preset we want to use for the imported wave by selecting the wave file and then selecting the correct preset in the properties in the lower left of the application:

[![image](images/compressingaudioinxnaforwindows_fb55_image_thumb.png)](http://localhost:8080/wp-content/2012/07/CompressingaudioinXnaforWindows_FB55_image_20.png)

Now we need to create sound bank by right-clicking the sound banks and choose new sound bank:

[![image](images/compressingaudioinxnaforwindows_fb55_image_thumb_111.png)](http://localhost:8080/wp-content/2012/07/CompressingaudioinXnaforWindows_FB55_image_24.png)

Open your wave bank and select the wave file you want to be cue in the sound and drag it from the wave bank onto the cue part of the window.  
The result should be something like this:

[![image](images/compressingaudioinxnaforwindows_fb55_image_thumb_12.png)](http://localhost:8080/wp-content/2012/07/CompressingaudioinXnaforWindows_FB55_image_26.png)

You now have a project you can build and use from your solution programmatically.

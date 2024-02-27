---
title: "Silverlight 4 beta announced"
date: "2009-11-18"
categories: 
  - "net"
tags: 
  - "silverlight"
---

Today Scott Guthrie announced the beta release of Silverlight 4, the release rate for Silverlight is amazing. Its only been 4 months since we got the release of Silverlight 3 and now everyone is getting their hands on with the beta of version 4, amazing stuff - kudos to the Silverlight development team. I've been working with SL4 for a while now through early access from Microsoft, and I must say that I'm really impressed with what they have accomplished and the quality of the builds has been truly remarkable. I guess a lot of you will probably pick up the downloads and think "why don't they just release it now" or "can I get a golive license for this - like - NOW". 

Download SL4 now and get started over at the "[Getting started with Silverlight 4](http://silverlight.net/getstarted/silverlight-4-beta/)" area of Silverlight.net.

Congratulations to the Silverlight team for their achievement, its a great product and one I'm proud to be representing as an MVP. 

Even though it has only been 4 months since the previous release, the team has been able to get some really great stuff into this version already. Here are the highlights:

**Out of browser applications**

Silverlight 3 introduced the concept of out of browser, which enabled developers to have their applications installed as an offline application available without having to browse to the page the application was hosted from. In Silverlight 4 there is quite a new features related to this:

**Elevated privileges**

In Silverlight 4 you'll have the ability to get elevated privileges, this means you get to stuff one is more used to from a regular desktop application:

- Cross domain network access
- Full file path from Open/SaveFileDialog
- No user-initiation requirements for fullscreen, Open/SaveFileDialogs
- COM Interop

In addition you now have the ability host HTML in your Silverlight application.

**Media**

Silverlight started out as the "flash" killer on most lips, and with this release as previous they are doing great stuff with media support - closing the gap between what Flash and Silverlight, feature wise.

- WMS multicast support
- MP4 playback protected by PlayReady DRM
- Offline DRM
- Output protection
- WebCam/Microphone support (raw stream only)

**Printing support**

Finally - this feature is something that at least I've been missing since day one, the ability to programatically generate print documents from the client without having to rely on doing it on the server and pushing back to the browser.

**Text**

One of the coolest features with Silverlight is text - the ability to embed true-type fonts and assure the look across browsers and platforms. With Silverlight 3, they close to perfected the rendering of fonts, with this release we're therefor seeing some new and cool features:

- RichTextBox
- Arabic and Hebrew support (right to left)
- IME Improvements for TextBox
- UIElement.TextInput event

**Controls / Layout**

The gap between WPF and Silverlight is really getting tighter in this version:

- Theming via implicit styles
- ViewBox
- MouseWheel support on ScrollViewer, TextBox, ComboBox, Calendar, DatePicker
- RTL Layout via UIElement.FlowDirection property
- VisualStateGroup.CurrentStateGroup property
- Command Property on ButtonBase & Hyperlink (finally)
- SelectedValue and SelectedValuePath properties on Selector

**Networking**

- Memory usage fix during progressive downloads
- Automatically adding referrer header
- Authentication support on ClientHttpWebRequest

**Tools support**

Dispatcher support on the tools design surface

**DataBinding improvements**

- DataBinding support for DependencyObjects
- IDataErrorInfo support
- StringFormat, TargetNullValue & FallBackValue properties on Binding
- ObservableCollection<T> constructor that takes INumerable or IList
- IEditableCollectionView
- Grouping support on CollectionViewSource

**SDK**

- Astoria 2.0 Support
- MEF

**Other**

- Expose runtime version to 3rd party DLLs
- NGEN support for Core runtime binaries

Also, important to know; Silverlight 4 supports C# 4, so when doing Silverlight development from Visual Studio 2010, you'll be able to use all the cool new language features in C# 4, dynamic being one of my favorites. 

**Breaking changes from SL3**

**TabControl keyboard navigation fixed**

In SL3 navigation was broken, pressing the up key used to activate the next TabItem and down the previous, counterintuitive when TabStripPlacement was Left or Right. In SL4 pressing the up key activates the previous and down activates the next. In order for existing applications to take advantage of this fix you'll have to recompile the application.

**Toggling fullscreen mode will now result in rerunning hit-testing**

Controls that were under the mouse before toggling fullscreen will get their MouseOver state refreshed from rerunning the hit-testing.

**Windows class**

The property called WindowStartupLocation is not returning a string anymore but a WindowStartupLocation object.

**Class MS.Internal.Interop.IneropWrapper has been removed**

**Changing DisplayMemberPath and ItemTemplate properties of ItemControl now re-creates all containers**

Setting ItemTemplate and DisplayMemberPath had no effect after ListBox measuring was finished in Silverlight 3. This will now invalidate all realized containers and re-create them even after the containers were measured.

Tim Heuer has a great guide on his blog for the new features that can be found [here](http://timheuer.com/blog/archive/2009/11/18/whats-new-in-silverlight-4-complete-guide-new-features.aspx).

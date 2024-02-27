---
title: "How to build an impossible Team Foundation Server environment."
date: "2007-04-20"
---

It all started off innocently enough. The idea of having my own TFS environment instead of scaling down to CVS or similar. I've always had a server or two standing around doing basically nothing except hosting some mail server and lately I've scaled down from kick-ass configurations to laptops. The advantage of using laptops is that mobile CPUs are pretty fast considering, they have a lot of cache, they have little or no noise, they take up little space so you can put them just about anywere. Anyhow.. I had my setup with a DELL Latitude D505 running a Win2003 server acting as a primary domain controller and an Exchange 2003 server on top of it. Cool enough. Then I started fiddling about with the idea of starting up the gamecamp thing (read my previous post) and thought I get a community up and running including a team system for developers to join in on. TFS sprung to mind and seeing that I just love working with TFS at work, I decided that it was the preferred system. Now the fun begins....

TFS does not at all support installing itself on top of a domain controller. MIcrosoft removed the ability, or should I say put the breaks on for doing it on the BETA3 release of TFS. After struggling a couple of days with some pretty hairy ideas of forcing it on the domain controller, no matter what the installation said I gave that up and figured I needed another laptop for my project. I happened to have a DELL Inspiron 4100 which consisted of a PIII Mobile CPU running 1GHz with 256MB of memory. Needless to say by todays standards, this is not exactly the most speediest computer in town. Anyhow, that was the laptop I had and I started with a determined mind. After a couple of hours of installation I finally had a computer running Win2003, SQL 2005 Standard Edition, SharePoint Services 2.0 Service Pack 2 and the TFS on top of everything installed in a single server deployment. Remember, still only 256 MB of memory..  Ran pretty smooth as well, even though Microsoft minimum recommendations are 2GB of memory. Even though this worked, I decided I better try to delegate some of the tasks to my other laptop running the DC which already had the SQL 2005 installation (hosting this blog, for instance). That should be a piece of cake, I thought. A couple of months ago we did a server move for the TFS at work and ran the tfsadminutil console application and moved around stuff, and that was pretty straight forward.. 

Heres how to do it all :

Assumptions for this setup: the recommended accounts (tfssetup, tfsservice, tfsreports) are domain accounts existing on the domain controller and are available. I also made them part of the Domain Admin group, but this is probably not necessary and considered a security risk (some people probably think I should be shot for doing this. :) )

\* Detach your SQL databases (if you want to move the SharePoint databases, detach those as well, same goes for the Reporting Services databases)

\* Copy the databases to the other server and attach them, and yes, it can be a domain controller.. :)

\* Go to your TFS server and open up a CMD and go to c:Program FilesMicrosoft Visual Studio 2005 Team Foundation ServerTools

\* Run the tfsadminutil with the renamedt argument (see the documentation of the util)

\* If  you moved the reporting database you have to now go to the Reporting Services Configuration utility on your TFS computer and reconfigure it to work with the databases attached to the other SQL server. There is also a possibility of just hosting the Reports on the other server as well, then you have to modify 2 rows in the tbl\_service\_interface table in the TFSIntegration database on the SQL server. The two rows are named ReportsService and BaseReportsUrl. Modify these URLs to point to the Report server you wish to use.

\* Now.. SharePoint needs to be configured, if you moved these databases. Open up the SharePoint Admin site and go the "Set configuration database server" and enter the new database information, remember that you can't change the authentication mode, it has to be the same as before the move.

\* After changing the location of the configuration database, you need to remove the old content database and add the moved one. Go to "Configure Virtual Server Settings" on the Admin and choose the site that was configured for SharePoint (usually Default Web Site). Select "Manage content databases". Remove the existing (default : STS\_Content\_TFS) and add the newly moved one.

If you worked out all the kinks during every step and verified every step you might be the lucky owner of a dual TFS setup with one half installed on a domain controller.

My setup is now close to what I'd call optimal for my purposes. :)  I could probably do with a bit more memory for the TFS server, but it's all very responsive.

It can be done.

Alternatively, you can just go ahead and either intercept WMI when the setup selects into the SystemInformation object and asks the domain status for the computer and just give it a value the setup can live with or temporary replace the WMI object during setup with an object it will accept and go ahead and install. That ofcourse is a bit risky (I managed to wipe out mine on one of my Vista machines).

Ofcourse, there is a third option, go and install TFS on a recommended setup. But then there's just no fun..

Have a nice weekend!

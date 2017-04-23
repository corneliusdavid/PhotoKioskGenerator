# Photo Kiosk Generator

This project was built to keep up-to-date, a set of static web pages of photos for people to browse in a kiosk or information booth in a church lobby.  It has two parts, web templates and Delphi program to generate web pages from data in a spreadsheet and the web templates. Whenever updates are made to the spreadsheet (new people, changes, etc.), the program needs to run to re-generate the web pages and then the web pages need to be moved or copied out to where the kiosk or web server resides.

An additional feature of this design is that the generated web pages could even be copied to a stand-alone machine with no internet access, such as a tiny Raspberry Pi running Linux.

### The Delphi program ###

The Delphi program reads names and photo filenames from a spreadsheet and uses that data along with the web templates to build a set of web pages with thumbnails linked to the full photos. These generated web pages can then be placed on any web server, or simply stored locally on a computer with a browser pointed to them.

It is written in Delphi 10 Seattle using the Windows VCL library, but could probably be compiled in any of the "XE" versions of Delphi. The only non-standard component is is LayoutSaver from [CC Components](https://github.com/corneliusdavid/ccComponents) which is used to make it easy to recall files and paths (and could be removed if you download this and don't want to bother getting and installing those components).

The spreadsheets are expected to have specific columns from where the data is pulled. No special components are used to read the spreadsheet, just standard Windows OLE technology. However, you do have to have Excel installed--or at least the free Excel Viewer from Microsoft.

### The Web Templates ###

The web pages use jQuery and the FancyBox extension for zooming, scrolling, and page transition and Bootstrap for nice placement. This is all included in the the "web" folder and needs to be deployed the first time the generated web pages are deployed--or if any of the libraries get an update.

The templates use [WebBroker](http://docwiki.embarcadero.com/RADStudio/Tokyo/en/Using_Web_Broker_Index) technology, originally published in the 1990s with Borland Delphi but still supported today in the latest versions of Embarcadero RAD Studio.

The templates use #tags as replacement identifiers and are broken out by the type of repeatable data they represent.  The end result is two web pages consisting of the same photos, one with the names sorted by first name, and the second with the names sorted by last name, both with an index of letters at the bottom.  This is to enable a person standing in front of a touch-screen monitor with no keyboard to quickly locate a person's name in the list without having to type anything. 

The two main template files are:

- FirstNamePhotoDirectory.html
- LastNamePhotoDirectory.html

These files provide the HTML structure, link in the jQuery libraries and CSS rules, declare a local JavaScript function, and include the other templates:

- FirstNamePhotoRow.htm or LastNamePhotoRow.htm
- NavBarButtons.htm

Further documentation is not provided here. You'll need to get familiar with WebBroker technology, read the code, and follow the events.
# Photo Kiosk Generator

This project was built to keep up-to-date, a set of static web pages of photos for people to browse in a kiosk.  It has two parts, web templates and a Windows program to generate web pages using data in a set of spreadsheets matched with the web templates. Whenever updates are made to the spreadsheets (e.g. new people are added), the program needs to be run to re-generate the web pages and then the web pages need to be moved or copied out to where the kiosk or web server resides.

This was designed to generate static files instead of a dynamic site pulling names and photos out of a database. The reason is partly because the original data came from a spreadsheet and a program was written to extract that information as a separate step. But this separation also allows this set of pages to be deployed to any device or platform without any changes or dependencies or tricky installation. In fact, it could even be copied to a stand-alone machine with no internet access, such as a tiny Raspberry Pi running Linux.


### The Windows program ###

The first Delphi project, **NameSheetConverter**, reads names and photo filenames from a spreadsheet and uses that data along with the web templates to build a set of web pages with thumbnails linked to the full photos. These generated web pages can then be placed on any web server, or simply stored locally on a computer with a browser pointed to them.

It is written in Delphi XE8 using the Windows VCL library, but could probably be compiled in any version of Delphi from XE2 on (and earlier versions with minor tweaks). The only non-standard component is LayoutSaver from [CC Components](https://github.com/corneliusdavid/ccComponents) (a small freeware Delphi component set) which is used to make it easy to recall filenames and paths. This could be removed if you don't want to bother getting and installing that component set, but with frequent use of this program, you'll want some way of saving the values of the edit fields.

The spreadsheets are expected to have specific columns from where the data is pulled. No special components are used to read the spreadsheet, just standard Windows OLE technology. However, you do have to have Excel installed--or at least the free Excel Viewer from Microsoft.

### The Web Templates ###

The pages are written in HTML 5 and make use of several JavaScript libraries. They are included in the the "web" folder and need to be deployed the first time the generated web pages are deployed--or if any of the libraries get an update. Here is a list of the libraries used and their function in this project:

- **jQuery** - the underlying library for many other things
- **FancyBox** - a jQuery extension to allow picture zooming
- **BootStrap** - to provide resizable columns for fitting various sizes of devices
- **SmothScroll** - for smooth scrolling quickly up and down the list of photos

The HTMLTemplates folder contain short snippets of HTML code that have tags in them that get replaced by the Windows application described above. The format is in a structure designed for use by the [WebBroker](http://docwiki.embarcadero.com/RADStudio/Tokyo/en/Using_Web_Broker_Index) technology first published by Borland Delphi in the late 1990s and still supported by Embarcadero's RAD Studio.

The templates use #tags as replacement identifiers and are broken out by the type of repeatable data they represent.  The end result is two web pages consisting of the same photos, one with the names sorted by first name, and the second with the names sorted by last name, both with an index of letters at the bottom.  This is to enable a person standing in front of a touch-screen monitor with no keyboard to quickly locate a person's name in the list without having to type anything. 

The two main template files are:

- FirstNamePhotoDirectory.html
- LastNamePhotoDirectory.html

These files provide the HTML structure, link in the jQuery libraries and CSS rules, declare a local JavaScript function, and include the other templates:

- FirstNamePhotoRow.htm or LastNamePhotoRow.htm
- NavBarButtons.htm

Further documentation on the [WebBroker](http://docwiki.embarcadero.com/RADStudio/Tokyo/en/Using_Web_Broker_Index) technology is not provided here.

### Sample Data Generation ###

After the project was complete and in use for nearly a year, this project was made open source. I thought it would be nice to provide a sample of what the finished photo kiosk would look like and could not, of course, share the list of names and photos for which it was created. So another project was born that would supplement this, **NameSheetBuilder**.

The only requirement of this project was to be able to generate sample spreadsheets that could feed into the first Delphi program above. The easiest way I have of generating lots of good sample data quickly is a tool I purchased from [DevArt Software](https://www.devart.com/) called [dbForge Data Generator for SQL Server](https://www.devart.com/dbforge/sql/data-generator/). I use SQL Server Express for a lot of small database projects so it was the easiest thing for me to do. And of course, I decided to use Delphi once again to extract the generated sample data into the spreadsheets.

This program uses Delphi's ADO Connection and query objects to extract the data and once again uses Microsoft's OLE technology to open, clear, and fill the spreadsheets.

The `SampleData` folder contains SQL scripts for creating the table to hold the sample data, SQL scripts to extract data for both LastName order and FirstName order, and a script (`.dgen`) used by dbForge Data Generator (if you own it) that was used to fill the tables. The PicFilenames.txt file is a list of filenames that I used to apply random "photos" of the randomly generated people.

One note about the SQL to extract Last Name and First Name lists: When sorted by last name, there's one entry per family.  But when sorted by first name, each member (both parent and child) are called out.  The randomness resulted in everything from singles to couples with 3 kids (in my sample data). For the latter, there could be 5 entries for the one family.  Therefore the SQL for extracting names by first name is much more complicated and results in a lot more data.

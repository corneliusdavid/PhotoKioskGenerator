# NameSheetConverter

Written in Delphi 10 Seattle, this simple application converts a list of names and image 
filenames in a spreadsheet to web pages using HTML templates based on the old WebBroker technology.
It uses the LayoutSaver from [CC Components](https://github.com/corneliusdavid/ccComponents) for
convenience but can be easily removed.

The purpose of this application was to use a list of names for a small church kept in a spreadsheet
(yeah, I know, very inefficient, but you work with what you get) and generate a photo directory kiosk
for use in the lobby.  This program runs whenever the spreadsheet is updated and generates new HTML 
pages that are read by the kiosk computer (which could be as simple as a Raspberry Pi).

Possibly the most interesting aspect to this project (of which the NameSheetConverter app is only a part)
are the web pages. They use Bootstrap for nice placement, jQuery and the FancyBox extension for zooming, 
scrolling, and page transition all hosted in a web browser launched in kiosk mode for a nice touch-screen
interface.  This is all included here in the the "web" folder.

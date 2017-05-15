object dmNameSheetData: TdmNameSheetData
  OldCreateOrder = False
  Height = 287
  Width = 405
  object ADOConnection: TADOConnection
    ConnectionString = 
      'Provider=SQLNCLI11.1;Persist Security Info=False;User ID=davidc;' +
      'Initial Catalog=NamesWithPhotos;Data Source=corneliusadventures.' +
      'database.windows.net;Initial File Name="";Server SPN=""'
    Mode = cmRead
    Provider = 'SQLNCLI11.1'
    Left = 184
    Top = 56
  end
end

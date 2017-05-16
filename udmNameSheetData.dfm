object dmNameSheetData: TdmNameSheetData
  OldCreateOrder = False
  Height = 287
  Width = 245
  object ADOConnection: TADOConnection
    ConnectionString = 
      'Provider=SQLNCLI11.1;Persist Security Info=False;User ID=davidc;' +
      'Initial Catalog=NamesWithPhotos;Data Source=corneliusadventures.' +
      'database.windows.net;Initial File Name="";Server SPN="";'
    Mode = cmRead
    Provider = 'SQLNCLI11.1'
    Left = 112
    Top = 48
  end
  object qryLastNames: TADOQuery
    Connection = ADOConnection
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT '
      '  NULL as FirstName,'
      '  LastName,'
      '  CASE'
      '    WHEN LEN(Parent1Name) = 0 THEN Parent2Name'
      '    WHEN LEN(Parent2Name) = 0 THEN Parent1Name'
      '    ELSE Parent1Name + '#39' & '#39' + Parent2Name'
      '  END AS ParentNames,'
      
        '  Child1Name + COALESCE('#39', '#39' + Child2Name, '#39#39') + COALESCE('#39', '#39' +' +
        ' Child3Name, '#39#39') AS Children,'
      '  PictureFilename'
      'FROM NamesAndPhotos'
      'WHERE LEN(Parent1Name) > 0 OR LEN(Parent2Name) > 0'
      'ORDER By LastName')
    Left = 112
    Top = 120
  end
  object qryFirstNames: TADOQuery
    Connection = ADOConnection
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT '
      '  Parent1Name AS FirstName,'
      '  LastName,'
      '  CASE'
      '    WHEN LEN(Parent1Name) = 0 THEN Parent2Name'
      '    WHEN LEN(Parent2Name) = 0 THEN Parent1Name'
      '    ELSE Parent1Name + '#39' & '#39' + Parent2Name'
      '  END AS ParentNames,'
      
        '  Child1Name + COALESCE('#39', '#39' + Child2Name, '#39#39') + COALESCE('#39', '#39' +' +
        ' Child3Name, '#39#39') AS Children,'
      '  PictureFilename'
      'FROM NamesAndPhotos'
      'WHERE Parent1Name IS NOT NULL AND LEN(Parent1Name) > 0'
      'UNION'
      'SELECT '
      '  Parent2Name AS FirstName,'
      '  LastName,'
      '  CASE'
      '    WHEN LEN(Parent1Name) = 0 THEN Parent2Name'
      '    WHEN LEN(Parent2Name) = 0 THEN Parent1Name'
      '    ELSE Parent1Name + '#39' & '#39' + Parent2Name'
      '  END AS ParentNames,'
      
        '  Child1Name + COALESCE('#39', '#39' + Child2Name, '#39#39') + COALESCE('#39', '#39' +' +
        ' Child3Name, '#39#39') AS Children,'
      '  PictureFilename'
      'FROM NamesAndPhotos'
      'WHERE Parent2Name IS NOT NULL AND LEN(Parent2Name) > 0'
      'UNION'
      'SELECT '
      '  Child1Name AS FirstName,'
      '  LastName,'
      '  CASE'
      '    WHEN LEN(Parent1Name) = 0 THEN Parent2Name'
      '    WHEN LEN(Parent2Name) = 0 THEN Parent1Name'
      '    ELSE Parent1Name + '#39' & '#39' + Parent2Name'
      '  END AS ParentNames,'
      
        '  Child1Name + COALESCE('#39', '#39' + Child2Name, '#39#39') + COALESCE('#39', '#39' +' +
        ' Child3Name, '#39#39') AS Children,'
      '  PictureFilename'
      'FROM NamesAndPhotos'
      'WHERE Child1Name IS NOT NULL AND LEN(Child1Name) > 0 AND'
      '  (LEN(Parent1Name) > 0 OR LEN(Parent2Name) > 0)'
      'UNION'
      'SELECT '
      '  Child2Name AS FirstName,'
      '  LastName,'
      '  CASE'
      '    WHEN LEN(Parent1Name) = 0 THEN Parent2Name'
      '    WHEN LEN(Parent2Name) = 0 THEN Parent1Name'
      '    ELSE Parent1Name + '#39' & '#39' + Parent2Name'
      '  END AS ParentNames,'
      
        '  Child1Name + COALESCE('#39', '#39' + Child2Name, '#39#39') + COALESCE('#39', '#39' +' +
        ' Child3Name, '#39#39') AS Children,'
      '  PictureFilename'
      'FROM NamesAndPhotos'
      'WHERE Child2Name IS NOT NULL AND LEN(Child2Name) > 0 AND'
      '  (LEN(Parent1Name) > 0 OR LEN(Parent2Name) > 0)'
      'UNION'
      'SELECT '
      '  Child3Name AS FirstName,'
      '  LastName,'
      '  CASE'
      '    WHEN LEN(Parent1Name) = 0 THEN Parent2Name'
      '    WHEN LEN(Parent2Name) = 0 THEN Parent1Name'
      '    ELSE Parent1Name + '#39' & '#39' + Parent2Name'
      '  END AS ParentNames,'
      
        '  Child1Name + COALESCE('#39', '#39' + Child2Name, '#39#39') + COALESCE('#39', '#39' +' +
        ' Child3Name, '#39#39') AS Children,'
      '  PictureFilename'
      'FROM NamesAndPhotos'
      'WHERE Child3Name IS NOT NULL AND LEN(Child3Name) > 0 AND'
      '  (LEN(Parent1Name) > 0 OR LEN(Parent2Name) > 0)'
      'ORDER BY FirstName')
    Left = 112
    Top = 184
  end
end

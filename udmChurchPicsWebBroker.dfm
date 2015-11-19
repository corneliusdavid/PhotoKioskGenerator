object dmChurchPicsWebBroker: TdmChurchPicsWebBroker
  OldCreateOrder = True
  Height = 252
  Width = 259
  object cdsChurchPics: TClientDataSet
    PersistDataPacket.Data = {
      B20000009619E0BD010000001800000005000000000003000000B20008426F6C
      644E616D650100490000000100055749445448020002003200084C6173744E61
      6D6501004900000001000557494454480200020032000A46697273744E616D65
      7301004900000001000557494454480200020064000A4368696C644E616D6573
      01004900000001000557494454480200020064000B506963747572654E616D65
      01004900000001000557494454480200020064000000}
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'BoldName'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'LastName'
        DataType = ftString
        Size = 50
      end
      item
        Name = 'FirstNames'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'ChildNames'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'PictureName'
        DataType = ftString
        Size = 100
      end>
    IndexDefs = <
      item
        Name = 'idxLastName'
        Fields = 'LastName;FirstNames'
      end
      item
        Name = 'idxChurchPicsIndexChar'
        Fields = 'BoldName;LastName;FirstNames'
      end>
    IndexName = 'idxChurchPicsIndexChar'
    Params = <>
    StoreDefs = True
    Left = 72
    Top = 40
    object cdsChurchPicsBoldName: TStringField
      FieldName = 'BoldName'
      Size = 50
    end
    object cdsChurchPicsLastName: TStringField
      FieldName = 'LastName'
      Size = 50
    end
    object cdsChurchPicsFirstNames: TStringField
      FieldName = 'FirstNames'
      Size = 100
    end
    object cdsChurchPicsChildNames: TStringField
      FieldName = 'ChildNames'
      Size = 100
    end
    object cdsChurchPicsPictureName: TStringField
      FieldName = 'PictureName'
      Size = 100
    end
  end
  object ppPhotoDirList: TPageProducer
    OnHTMLTag = ppPhotoDirListHTMLTag
    Left = 72
    Top = 96
  end
  object ppPhotoRow: TPageProducer
    OnHTMLTag = ppPhotoRowHTMLTag
    Left = 160
    Top = 128
  end
  object ppNavButtons: TPageProducer
    OnHTMLTag = ppNavButtonsHTMLTag
    Left = 160
    Top = 184
  end
end

object dmChurchPicsWebBroker: TdmChurchPicsWebBroker
  OldCreateOrder = True
  Height = 231
  Width = 259
  object cdsChurchPics: TClientDataSet
    PersistDataPacket.Data = {
      950000009619E0BD0100000018000000040000000000030000009500084C6173
      744E616D6501004900000001000557494454480200020032000A46697273744E
      616D657301004900000001000557494454480200020064000A4368696C644E61
      6D657301004900000001000557494454480200020064000B506963747572654E
      616D6501004900000001000557494454480200020064000000}
    Active = True
    Aggregates = <>
    FieldDefs = <
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
      end>
    IndexName = 'idxLastName'
    Params = <>
    StoreDefs = True
    Left = 72
    Top = 40
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
end

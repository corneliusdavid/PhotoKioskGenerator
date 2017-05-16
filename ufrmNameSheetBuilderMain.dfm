object frmNameSheetBuilder: TfrmNameSheetBuilder
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  BorderWidth = 10
  Caption = 'Name Sheet Builder'
  ClientHeight = 471
  ClientWidth = 499
  Color = clBtnFace
  Constraints.MinWidth = 480
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnClose = FormClose
  DesignSize = (
    499
    471)
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 0
    Top = 0
    Width = 499
    Height = 48
    Align = alTop
    Caption = 
      'This program takes data from SQL Server and creates two spreadsh' +
      'eets needed for the NameSheetConverter. The idea is to fill or c' +
      'hange the SQL Server database with random data and create differ' +
      'ent spreadsheets for testing.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    WordWrap = True
    ExplicitWidth = 487
  end
  object grpDatabase: TGroupBox
    Left = 34
    Top = 80
    Width = 417
    Height = 143
    Anchors = [akTop]
    Caption = 'Database'
    TabOrder = 0
    object edtDBServerName: TLabeledEdit
      Left = 96
      Top = 40
      Width = 305
      Height = 24
      EditLabel.Width = 80
      EditLabel.Height = 16
      EditLabel.Caption = '&Server Name:'
      LabelPosition = lpLeft
      TabOrder = 0
    end
    object edtDBUsername: TLabeledEdit
      Left = 96
      Top = 67
      Width = 137
      Height = 24
      EditLabel.Width = 63
      EditLabel.Height = 16
      EditLabel.Caption = '&Username:'
      LabelPosition = lpLeft
      TabOrder = 1
    end
    object edtDBPassword: TLabeledEdit
      Left = 96
      Top = 94
      Width = 137
      Height = 24
      EditLabel.Width = 60
      EditLabel.Height = 16
      EditLabel.Caption = '&Password:'
      LabelPosition = lpLeft
      PasswordChar = '*'
      TabOrder = 2
    end
  end
  object GroupBox1: TGroupBox
    Left = 34
    Top = 229
    Width = 417
    Height = 164
    Anchors = [akTop]
    Caption = 'Spreadsheets (configured in Picture Spreadsheet Converter)'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGrayText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    TabOrder = 1
    object edtLastNamesSpreadsheetFile: TLabeledEdit
      Left = 14
      Top = 56
      Width = 387
      Height = 22
      Ctl3D = False
      EditLabel.Width = 178
      EditLabel.Height = 16
      EditLabel.Caption = '"&Last Names" Spreadsheet file:'
      EditLabel.Color = clBtnFace
      EditLabel.Font.Charset = DEFAULT_CHARSET
      EditLabel.Font.Color = clGrayText
      EditLabel.Font.Height = -13
      EditLabel.Font.Name = 'Tahoma'
      EditLabel.Font.Style = []
      EditLabel.ParentColor = False
      EditLabel.ParentFont = False
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGrayText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 0
    end
    object edtFirstNamesSpreadsheetFile: TLabeledEdit
      Left = 14
      Top = 116
      Width = 387
      Height = 22
      Ctl3D = False
      EditLabel.Width = 180
      EditLabel.Height = 16
      EditLabel.Caption = '"&First Names" Spreadsheet file:'
      EditLabel.Color = clBtnFace
      EditLabel.Font.Charset = DEFAULT_CHARSET
      EditLabel.Font.Color = clGrayText
      EditLabel.Font.Height = -13
      EditLabel.Font.Name = 'Tahoma'
      EditLabel.Font.Style = []
      EditLabel.ParentColor = False
      EditLabel.ParentFont = False
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGrayText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 1
    end
  end
  object btnGenSpreadsheets: TBitBtn
    Left = 37
    Top = 399
    Width = 177
    Height = 35
    Caption = '&Generate Spreadsheets'
    Glyph.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      1800000000000003000000000000000000000000000000000000FFFFFFFFFFFF
      478DE65396E8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFA8CDF329BEEC5AAAECFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFF93BDF127FFFF90A2E9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFF3FC2BE7F70CE3F8D8D6F4FF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFF85A1E924FFFF259CE8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDFE3F92AD8F408FFFF47
      9EEDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFF96AFEB21FFFF00D2FF7E93E2FFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDDDAF639B4EB0C
      FFFF06A8F37076D6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFF9CD2F5008AE5008AE5129CEA08DBFD00DDFF06A8F36262CCFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5F6FD76DFF641FFFF00D4FA00
      D4FA00D4FA00CFFF06A8F38093DFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFEEF2FC9CF4F857FFFF3DD8F846D5F734E8FF23E3FF06A8F3ACAF
      E7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC5D4F498FFFF4C
      F0FE53EAFE68BCEE699DE0B3CDF0888DDDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFEFEFFA0CBF16CFCFF37E2FC51DEFD7E9DE1FFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDEE6F890
      E0F75EF4FF3CE1FF54D0FA849AE0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCDE1F78AF0FE49EAFF36ECFF47BEF17CA3
      E1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFA6CAF07DD2F57AC7F275C8F36AA9E392BEEAFFFFFFFFFFFF}
    TabOrder = 2
    OnClick = btnGenSpreadsheetsClick
  end
  object ccRegistryLayoutSaver: TccRegistryLayoutSaver
    Left = 424
    Top = 80
  end
  object ccRegistrySheetSaver: TccRegistryLayoutSaver
    Location = 'Software\NameSheetConverter'
    Section = 'frmPicSSConvert'
    UseDefaultNames = False
    AutoSave = False
    AutoRestore = False
    Left = 424
    Top = 160
  end
end

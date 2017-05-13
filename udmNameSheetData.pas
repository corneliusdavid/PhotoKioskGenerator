unit udmNameSheetData;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB;

type
  TdmNameSheetData = class(TDataModule)
    ADOConnection: TADOConnection;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmNameSheetData: TdmNameSheetData;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.

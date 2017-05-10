unit udmNameSheetData;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB;

type
  TdmNameSheetDAta = class(TDataModule)
    ADOConnection: TADOConnection;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmNameSheetDAta: TdmNameSheetDAta;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.

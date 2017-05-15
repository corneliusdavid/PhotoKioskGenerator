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
    procedure Connect(const ServerName, UserName, Password: string);
    procedure PrepareLastNameList;
    procedure PrepareFirstNameList;
  end;

var
  dmNameSheetData: TdmNameSheetData;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TdmNameSheetData }

procedure TdmNameSheetData.Connect(const ServerName, UserName, Password: string);
const
  CnStr = 'Provider=SQLNCLI11.1;Persist Security Info=False;Data Source=%s;Initial File Name="";Server SPN=""';
begin
  ADOConnection.ConnectionString := Format(CnStr, [ServerName]);
  ADOConnection.Open(UserName, Password);
end;

procedure TdmNameSheetData.PrepareFirstNameList;
begin

end;

procedure TdmNameSheetData.PrepareLastNameList;
begin

end;

end.

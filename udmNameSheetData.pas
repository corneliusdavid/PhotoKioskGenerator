unit udmNameSheetData;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB;

type
  TPhotoEntry = record
    LastName: string;
    FirstName: string;
    ParentNames: string;
    ChildNames: string;
    PhotoFilename: string;
  end;

  TdmNameSheetData = class(TDataModule)
    ADOConnection: TADOConnection;
    qryLastNames: TADOQuery;
    qryFirstNames: TADOQuery;
  private
    FPhotoEntry: TPhotoEntry;
    FCurrQry: TADOQuery;
  public
    procedure Connect(const ServerName, UserName, Password: string);
    procedure PrepareLastNameList;
    procedure PrepareFirstNameList;
    function  GetNextRow: Boolean;
    procedure CloseNameList;
    property  PhotoEntry: TPhotoEntry read FPhotoEntry write FPhotoEntry;
  end;

var
  dmNameSheetData: TdmNameSheetData;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TdmNameSheetData }

procedure TdmNameSheetData.Connect(const ServerName, UserName, Password: string);
const
  CnStr = 'Provider=SQLNCLI11.1;Persist Security Info=False;User ID=%s;Initial Catalog=NamesWithPhotos;Data Source=%s;Initial File Name="";Server SPN=""';
begin
  ADOConnection.ConnectionString := Format(CnStr, [UserName, ServerName]);
  ADOConnection.Open(UserName, Password);
end;

procedure TdmNameSheetData.CloseNameList;
begin
  FCurrQry.Close;
end;

function TdmNameSheetData.GetNextRow: Boolean;
var
  s: string;
begin
  // fill all fields of record from database row
  FPhotoEntry.FirstName     := FCurrQry.FieldByName('FirstName').AsString;
  FPhotoEntry.LastName      := FCurrQry.FieldByName('LastName').AsString;
  FPhotoEntry.ParentNames   := FCurrQry.FieldByName('ParentNames').AsString;
  FPhotoEntry.ChildNames    := FCurrQry.FieldByName('Children').AsString;

  s := FCurrQry.FieldByName('PictureFilename').AsString;
  if Length(s) = 0 then
    s := 'pics\NOPIC.jpg';
  FPhotoEntry.PhotoFilename := s;

  FCurrQry.Next;

  // True means we're all done--no more records
  Result := FCurrQry.Eof;
end;

procedure TdmNameSheetData.PrepareFirstNameList;
begin
  qryFirstNames.Open;
  FCurrQry := qryFirstNames;
end;

procedure TdmNameSheetData.PrepareLastNameList;
begin
  qryLastNames.Open;
  FCurrQry := qryLastNames;
end;

end.

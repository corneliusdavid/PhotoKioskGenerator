unit udmChurchPicsWebBroker;

interface

uses
  MidasLib,
  System.SysUtils, System.Classes,
  Web.DBWeb, Web.HTTPApp, Web.HTTPProd, Web.DSProd, Data.DB, Datasnap.DBClient;

type
  TdmChurchPicsWebBroker = class(TDataModule)
    cdsChurchPics: TClientDataSet;
    cdsChurchPicsLastName: TStringField;
    cdsChurchPicsFirstNames: TStringField;
    cdsChurchPicsChildNames: TStringField;
    cdsChurchPicsPictureName: TStringField;
    ppPhotoDirList: TPageProducer;
    ppPhotoRow: TPageProducer;
    cdsChurchPicsBoldName: TStringField;
    ppNavButtons: TPageProducer;
    procedure ppPhotoDirListHTMLTag(Sender: TObject; Tag: TTag; const TagString: string; TagParams: TStrings; var ReplaceText: string);
    procedure ppPhotoRowHTMLTag(Sender: TObject; Tag: TTag; const TagString: string; TagParams: TStrings;
      var ReplaceText: string);
    procedure ppNavButtonsHTMLTag(Sender: TObject; Tag: TTag; const TagString: string; TagParams: TStrings;
      var ReplaceText: string);
  private
    FTemplateFolder: string;
    FCurrIndexChar: string;
    FPriorIndexChar: string;
    FIndexCharList: TStringList;
    function ProduceIndexChar: string;
    function ProduceFirstName: string;
    function ProduceLastName: string;
    function ProduceFirstNames: string;
    function ProduceChildNames: string;
    function ProduceCombinedNames: string;
    function ProducePictureFilename: string;
  public
    procedure ProcessFile(const InputFilename, OutputFilename: string);
  end;

var
  dmChurchPicsWebBroker: TdmChurchPicsWebBroker;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
  System.StrUtils, System.IOUtils;

{ TdmChurchPicsWebBroker }

procedure TdmChurchPicsWebBroker.ppNavButtonsHTMLTag(Sender: TObject; Tag: TTag; const TagString: string;
  TagParams: TStrings; var ReplaceText: string);
begin
  if SameText(TagString, 'IndexChar') then
    ReplaceText := FCurrIndexChar
  else
    ReplaceText := EmptyStr;
end;

procedure TdmChurchPicsWebBroker.ppPhotoDirListHTMLTag(Sender: TObject; Tag: TTag; const TagString: string;
  TagParams: TStrings; var ReplaceText: string);
var
  i: Integer;
begin
  ReplaceText := EmptyStr;

  if SameText(TagString, 'PhotoList') then begin
    ppPhotoRow.HTMLFile := TPath.Combine(FTemplateFolder, TagParams.Values['PhotoRowTemplate']);

    cdsChurchPics.First;
    while not cdsChurchPics.Eof do begin
      ReplaceText := ReplaceText + ppPhotoRow.Content;
      cdsChurchPics.Next;
    end;
  end else if SameText(TagString, 'IndexButtons') then begin
    ppNavButtons.HTMLFile := TPath.Combine(FTemplateFolder, TagParams.Values['NavBarTemplate']);
    for i := 0 to FIndexCharList.Count - 1 do begin
      FCurrIndexChar := FIndexCharList[i];
      ReplaceText := ReplaceText + ppNavButtons.Content;
    end;
  end;
end;

procedure TdmChurchPicsWebBroker.ppPhotoRowHTMLTag(Sender: TObject; Tag: TTag; const TagString: string;
  TagParams: TStrings; var ReplaceText: string);
begin
  if SameText(TagString, 'IndexChar') then
    ReplaceText := ProduceIndexChar
  else if SameText(TagString, 'FirstName') then
    ReplaceText := ProduceFirstName
  else if SameText(TagString, 'LastName') then
    ReplaceText := ProduceLastName
  else if SameText(TagString, 'FirstNames') then
    ReplaceText := ProduceFirstNames
  else if SameText(TagString, 'ChildNames') then
    ReplaceText := ProduceChildNames
  else if SameText(TagString, 'CombinedNames') then
    ReplaceText := ProduceCombinedNames
  else if SameText(TagString, 'PictureFile') then
    ReplaceText := ProducePictureFilename;
end;

procedure TdmChurchPicsWebBroker.ProcessFile(const InputFilename, OutputFilename: string);
var
  OutputWebPage: TextFile;
begin
  FTemplateFolder := ExtractFilePath(InputFilename);
  FPriorIndexChar := EmptyStr;
  FIndexCharList := TStringList.Create;
  try
    AssignFile(OutputWebPage, OutputFilename);
    Rewrite(OutputWebPage);

    ppPhotoDirList.HTMLFile := InputFilename;
    Write(OutputWebPage, ppPhotoDirList.Content);

    CloseFile(OutputWebPage);
  finally
    FIndexCharList.Free;
  end;
end;

function TdmChurchPicsWebBroker.ProduceFirstName: string;
begin
  Result := cdsChurchPicsBoldName.AsString;
end;

function TdmChurchPicsWebBroker.ProduceChildNames: string;
begin
  Result := cdsChurchPicsChildNames.AsString;
end;

function TdmChurchPicsWebBroker.ProduceCombinedNames: string;
begin
  Result := UpperCase(cdsChurchPicsLastName.AsString);

  if Length(cdsChurchPicsFirstNames.AsString) > 0 then
    Result := Result + ', ' + cdsChurchPicsFirstNames.AsString;

  if Length(cdsChurchPicsChildNames.AsString) > 0 then
    Result := Result + ', ' + cdsChurchPicsChildNames.AsString;
end;

function TdmChurchPicsWebBroker.ProduceFirstNames: string;
begin
  Result := cdsChurchPicsFirstNames.AsString;
end;

function TdmChurchPicsWebBroker.ProduceIndexChar: string;
begin
  FCurrIndexChar := UpperCase(LeftStr(cdsChurchPicsBoldName.AsString, 1));
  if Length(FCurrIndexChar) = 0 then
    FCurrIndexChar := UpperCase(LeftStr(cdsChurchPicsLastName.AsString, 1));

  if SameText(FCurrIndexChar, FPriorIndexChar) then
    Result := EmptyStr
  else begin
    Result := FCurrIndexChar;
    FPriorIndexChar := Result;
    FIndexCharList.Add(FCurrIndexChar);
  end;
end;

function TdmChurchPicsWebBroker.ProduceLastName: string;
begin
  Result := cdsChurchPicsLastName.AsString;
end;

function TdmChurchPicsWebBroker.ProducePictureFilename: string;

  function RandPicNum: string;
  var
    s: string;
  begin
    s := IntToStr(Random(100) + 1);
    Result := DupeString('0', 3 - Length(s)) + s;
  end;

begin
  Result := ReplaceStr(cdsChurchPicsPictureName.AsString, '\', '/');

  if LeftStr(Result, 1) <> '/' then
    Result := './' + Result
  else
    Result := '.' + Result;
end;

end.

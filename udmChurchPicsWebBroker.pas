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
    procedure ppPhotoDirListHTMLTag(Sender: TObject; Tag: TTag; const TagString: string; TagParams: TStrings; var ReplaceText: string);
    procedure ppPhotoRowHTMLTag(Sender: TObject; Tag: TTag; const TagString: string; TagParams: TStrings;
      var ReplaceText: string);
  private
    FTemplateFolder: string;
    FPriorIndexChar: string;
    FRandomKidPics: Boolean;
    function ProduceIndexChar: string;
    function ProduceLastName: string;
    function ProduceFirstNames: string;
    function ProduceChildNames: string;
    function ProducePictureFilename: string;
  public
    procedure ProcessFile(const InputFilename, OutputFilename: string; const TestMode: Boolean);
  end;

var
  dmChurchPicsWebBroker: TdmChurchPicsWebBroker;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
  System.StrUtils, System.IOUtils;

{ TdmChurchPicsWebBroker }

procedure TdmChurchPicsWebBroker.ppPhotoDirListHTMLTag(Sender: TObject; Tag: TTag; const TagString: string;
  TagParams: TStrings; var ReplaceText: string);
begin
  ReplaceText := EmptyStr;

  if SameText(TagString, 'PhotoList') then begin

    cdsChurchPics.First;
    while not cdsChurchPics.Eof do begin
      ppPhotoRow.HTMLFile := TPath.Combine(FTemplateFolder, TagParams.Values['PhotoRowTemplate']);
      ReplaceText := ReplaceText + ppPhotoRow.Content;

      cdsChurchPics.Next;
    end;
  end;
end;

procedure TdmChurchPicsWebBroker.ppPhotoRowHTMLTag(Sender: TObject; Tag: TTag; const TagString: string;
  TagParams: TStrings; var ReplaceText: string);
begin
  if SameText(TagString, 'IndexChar') then
    ReplaceText := ProduceIndexChar
  else if SameText(TagString, 'LastName') then
    ReplaceText := ProduceLastName
  else if SameText(TagString, 'FirstNames') then
    ReplaceText := ProduceFirstNames
  else if SameText(TagString, 'ChildNames') then
    ReplaceText := ProduceChildNames
  else if SameText(TagString, 'PictureFile') then
    ReplaceText := ProducePictureFilename;
end;

procedure TdmChurchPicsWebBroker.ProcessFile(const InputFilename, OutputFilename: string; const TestMode: Boolean);
var
  OutputWebPage: TextFile;
begin
  FTemplateFolder := ExtractFilePath(InputFilename);
  FRandomKidPics := TestMode;

  AssignFile(OutputWebPage, OutputFilename);
  Rewrite(OutputWebPage);

  ppPhotoDirList.HTMLFile := InputFilename;
  Write(OutputWebPage, ppPhotoDirList.Content);

  CloseFile(OutputWebPage);
end;

function TdmChurchPicsWebBroker.ProduceChildNames: string;
begin
  Result := cdsChurchPicsChildNames.AsString;
end;

function TdmChurchPicsWebBroker.ProduceFirstNames: string;
begin
  Result := cdsChurchPicsFirstNames.AsString;
end;

function TdmChurchPicsWebBroker.ProduceIndexChar: string;
begin
  Result := RightStr(cdsChurchPicsLastName.AsString, 1);

  if SameText(FPriorIndexChar, Result) then
    Result := EmptyStr;

  FPriorIndexChar := Result;
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
  if FRandomKidPics then
    Result := '.\pictures\KIDS' + RandPicNum + '.JPG'
  else
    Result := '.' + cdsChurchPicsPictureName.AsString;
end;

end.

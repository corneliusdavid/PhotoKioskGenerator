unit udmChurchPicsWebBroker;

interface

uses
  System.SysUtils, System.Classes,
  Web.DBWeb, Web.HTTPApp, Web.HTTPProd;

type
  TdmChurchPicsWebBroker = class(TDataModule)
    PageProducer: TPageProducer;
    procedure PageProducerHTMLTag(Sender: TObject; Tag: TTag; const TagString: string; TagParams: TStrings;
      var ReplaceText: string);
  private
    FPicFolder: string;
    function ProduceIndexChar: string;
    function ProduceLastName: string;
    function ProduceFirstNames: string;
    function ProduceChildNames: string;
  public
    procedure ProcessFile(const InputFilename, OutputFilename, PicFolder: string);
  end;

var
  dmChurchPicsWebBroker: TdmChurchPicsWebBroker;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TdmChurchPicsWebBroker }

procedure TdmChurchPicsWebBroker.PageProducerHTMLTag(Sender: TObject; Tag: TTag; const TagString: string;
  TagParams: TStrings; var ReplaceText: string);
begin
  if SameText(TagString, 'IndexChar') then
    ReplaceText := ProduceIndexChar
  else if SameText(TagString, 'LastName') then
    ReplaceText := ProduceLastName
  else if SameText(TagString, 'FirstNames') then
    ReplaceText := ProduceFirstNames
  else if SameText(TagString, 'ChildNames') then
    ReplaceText := ProduceChildNames;
end;

procedure TdmChurchPicsWebBroker.ProcessFile(const InputFilename, OutputFilename, PicFolder: string);
var
  OutputWebPage: TextFile;
begin
  PageProducer.HTMLFile := InputFilename;
  FPicFolder := PicFolder;

  AssignFile(OutputWebPage, OutputFilename);
  Rewrite(OutputWebPage);
  Write(OutputWebPage, PageProducer.Content);
  CloseFile(OutputWebPage);
end;

function TdmChurchPicsWebBroker.ProduceChildNames: string;
begin
  Result := 'Billy, Joey, Sally';
end;

function TdmChurchPicsWebBroker.ProduceFirstNames: string;
begin
  Result := 'Bob &amp; Sue';
end;

function TdmChurchPicsWebBroker.ProduceIndexChar: string;
begin
  Result := 'A';
end;

function TdmChurchPicsWebBroker.ProduceLastName: string;
begin
  Result := 'Anderson';
end;

end.

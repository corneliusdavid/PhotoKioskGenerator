unit ufrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  System.Actions, Vcl.ActnList, System.ImageList, Vcl.ImgList, Vcl.Buttons, Vcl.StdActns,
  LayoutSaver;

type
  TfrmPicSSConvert = class(TForm)
    Label1: TLabel;
    edtSpreadsheetFile: TLabeledEdit;
    btnFindSpreadsheet: TSpeedButton;
    aclMain: TActionList;
    imlMain: TImageList;
    actFindSpreadsheet: TAction;
    lbConvertLog: TListBox;
    ccRegistryLayoutSaver: TccRegistryLayoutSaver;
    dlgOpenSpreadsheet: TOpenDialog;
    btnOpen: TBitBtn;
    actParseSpreadsheet: TAction;
    edtRootPicFolder: TLabeledEdit;
    SpeedButton1: TSpeedButton;
    actSetRootPicFolder: TBrowseForFolder;
    edtHTMLTemplateFolder: TLabeledEdit;
    SpeedButton2: TSpeedButton;
    edtHTMLOutputFolder: TLabeledEdit;
    SpeedButton3: TSpeedButton;
    actSetWebTemplateFolder: TBrowseForFolder;
    actSetWebOutputFolder: TBrowseForFolder;
    BitBtn1: TBitBtn;
    actGenerateWebPages: TAction;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actFindSpreadsheetExecute(Sender: TObject);
    procedure actParseSpreadsheetExecute(Sender: TObject);
    procedure actGenerateWebPagesExecute(Sender: TObject);
    procedure actSetRootPicFolderBeforeExecute(Sender: TObject);
    procedure actSetRootPicFolderAccept(Sender: TObject);
    procedure actSetWebTemplateFolderBeforeExecute(Sender: TObject);
    procedure actSetWebTemplateFolderAccept(Sender: TObject);
    procedure actSetWebOutputFolderBeforeExecute(Sender: TObject);
    procedure actSetWebOutputFolderAccept(Sender: TObject);
  private
    FCurrTemplateFolder: string;
    FCurrOutputFolder: string;
    FCurrPicFolder: string;
    procedure AddStatus(const NewStatus: string);
    procedure ParseSpreadsheetTMS(const AFilename: string);
    procedure GenerateWebPagesFromTemplates(const TemplateFolder, OutputFolder,
                                                  PictureFolder, SpreadsheetFilename: string);
    procedure WebTemplateFound(const Path: string; var Stop: Boolean);
    procedure WebTemplateProcess(FileInfo: TSearchRec);
  end;

var
  frmPicSSConvert: TfrmPicSSConvert;

implementation

{$R *.dfm}

uses
  System.IOUtils,
  FlexCel.XlsAdapter, FlexCel.Core,
  udmChurchPicsWebBroker,
  uSearchRecList;

procedure TfrmPicSSConvert.FormCreate(Sender: TObject);
begin
  edtSpreadsheetFile.Text := ccRegistryLayoutSaver.RestoreStrValue('SpreadsheetFilename');
  edtRootPicFolder.Text := ccRegistryLayoutSaver.RestoreStrValue('PictureFolder');
  edtHTMLTemplateFolder.Text := ccRegistryLayoutSaver.RestoreStrValue('WebTemplatFolder');
  edtHTMLOutputFolder.Text := ccRegistryLayoutSaver.RestoreStrValue('WebOutputFolder');
end;

procedure TfrmPicSSConvert.FormDestroy(Sender: TObject);
begin
  ccRegistryLayoutSaver.SaveStrValue('SpreadsheetFilename', edtSpreadsheetFile.Text);
  ccRegistryLayoutSaver.SaveStrValue('PictureFolder', edtRootPicFolder.Text);
  ccRegistryLayoutSaver.SaveStrValue('WebTemplatFolder', edtHTMLTemplateFolder.Text);
  ccRegistryLayoutSaver.SaveStrValue('WebOutputFolder', edtHTMLOutputFolder.Text);
end;

procedure TfrmPicSSConvert.actFindSpreadsheetExecute(Sender: TObject);
begin
  if Length(edtSpreadsheetFile.Text) > 0 then
    dlgOpenSpreadsheet.FileName := edtSpreadsheetFile.Text;

  if dlgOpenSpreadsheet.Execute then
    edtSpreadsheetFile.Text := dlgOpenSpreadsheet.FileName;
end;

procedure TfrmPicSSConvert.actParseSpreadsheetExecute(Sender: TObject);
begin
  if Length(edtSpreadsheetFile.Text) = 0 then
    ShowMessage('Please select a spreadsheet file first.')
  else if not FileExists(edtSpreadsheetFile.Text) then
    ShowMessage('The file doesn''t exist.')
  else
    ParseSpreadsheetTMS(edtSpreadsheetFile.Text);
end;

procedure TfrmPicSSConvert.actSetRootPicFolderAccept(Sender: TObject);
begin
  edtRootPicFolder.Text := actSetRootPicFolder.Folder;
end;

procedure TfrmPicSSConvert.actSetRootPicFolderBeforeExecute(Sender: TObject);
begin
  actSetRootPicFolder.Folder := edtRootPicFolder.Text;
end;

procedure TfrmPicSSConvert.actSetWebOutputFolderAccept(Sender: TObject);
begin
  edtHTMLOutputFolder.Text := actSetWebOutputFolder.Folder;
end;

procedure TfrmPicSSConvert.actSetWebOutputFolderBeforeExecute(Sender: TObject);
begin
  actSetWebOutputFolder.Folder := edtHTMLOutputFolder.Text;
end;

procedure TfrmPicSSConvert.actSetWebTemplateFolderAccept(Sender: TObject);
begin
  edtHTMLTemplateFolder.Text := actSetWebTemplateFolder.Folder;
end;

procedure TfrmPicSSConvert.actSetWebTemplateFolderBeforeExecute(Sender: TObject);
begin
  actSetWebTemplateFolder.Folder := edtHTMLTemplateFolder.Text;
end;

procedure TfrmPicSSConvert.AddStatus(const NewStatus: string);
begin
  lbConvertLog.Items.Add(NewStatus);
  lbConvertLog.ItemIndex := lbConvertLog.Items.Count - 1;
end;

procedure TfrmPicSSConvert.ParseSpreadsheetTMS(const AFilename: string);
var
  Xls: TExcelFile;
  r: Integer;
begin
  Xls := TXlsFile.Create;
  xls.Open(AFileName);
  AddStatus('Reading rows: ' + IntToStr(xls.RowCount));

  for r := 1 to xls.RowCount do
    if xls.ColCountInRow(r) >= 4 then
      AddStatus(Format('Surname=%s, Primary=%s, Secondary=%s, Filename=%s',
                      [xls.GetStringFromCell(r, 1).ToString,
                       xls.GetStringFromCell(r, 2).ToString,
                       xls.GetStringFromCell(r, 3).ToString,
                       xls.GetStringFromCell(r, 4).ToString]));
end;

procedure TfrmPicSSConvert.WebTemplateFound(const Path: string; var Stop: Boolean);
begin
  AddStatus('Processing files in: ' + Path);
  Stop := False;
end;

procedure TfrmPicSSConvert.WebTemplateProcess(FileInfo: TSearchRec);
begin
  dmChurchPicsWebBroker.ProcessFile(TPath.Combine(FCurrTemplateFolder, FileInfo.Name),
                                    TPath.Combine(FCurrOutputFolder, FileInfo.Name),
                                    FCurrPicFolder);
  AddStatus('Generated ' + FileInfo.Name);
end;

procedure TfrmPicSSConvert.actGenerateWebPagesExecute(Sender: TObject);
begin
  if Length(edtRootPicFolder.Text) = 0 then
    ShowMessage('Please specify the root picture folder.')
  else if Length(edtHTMLTemplateFolder.Text) = 0 then
    ShowMessage('Please specify the HTML Template Folder.')
  else if Length(edtHTMLOutputFolder.Text) = 0 then
    ShowMessage('Please specify the output folder for generated HTML pages.')
  else if not TDirectory.Exists(edtRootPicFolder.Text) then
    ShowMessage('Please select a valid folder where the pictures are store.')
  else
    GenerateWebPagesFromTemplates(edtHTMLTemplateFolder.Text,
                                  edtHTMLOutputFolder.Text,
                                  edtRootPicFolder.Text,
                                  edtSpreadsheetFile.Text);
end;

procedure TfrmPicSSConvert.GenerateWebPagesFromTemplates(const TemplateFolder,
                                                               OutputFolder,
                                                               PictureFolder,
                                                               SpreadsheetFilename: string);
begin
  FCurrTemplateFolder := TemplateFolder;
  FCurrOutputFolder := OutputFolder;
  FCurrPicFolder := PictureFolder;
  GetSearchRecs(TemplateFolder, '*.html', False, WebTemplateFound, WebTemplateProcess);
end;

end.

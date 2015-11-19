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
    edtLastNamesSpreadsheetFile: TLabeledEdit;
    btnFindSpreadsheet: TSpeedButton;
    aclMain: TActionList;
    imlMain: TImageList;
    actFindLastNamesSpreadsheet: TAction;
    lbConvertLog: TListBox;
    ccRegistryLayoutSaver: TccRegistryLayoutSaver;
    dlgOpenSpreadsheet: TOpenDialog;
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
    Label5: TLabel;
    cbTestMode: TCheckBox;
    edtFirstNamesSpreadsheetFile: TLabeledEdit;
    Label4: TLabel;
    SpeedButton1: TSpeedButton;
    actFindFirstNamesSpreadsheet: TAction;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actFindLastNamesSpreadsheetExecute(Sender: TObject);
    procedure actGenerateWebPagesExecute(Sender: TObject);
    procedure actSetWebTemplateFolderBeforeExecute(Sender: TObject);
    procedure actSetWebTemplateFolderAccept(Sender: TObject);
    procedure actSetWebOutputFolderBeforeExecute(Sender: TObject);
    procedure actSetWebOutputFolderAccept(Sender: TObject);
    procedure actFindFirstNamesSpreadsheetExecute(Sender: TObject);
  private
    type
      SpreadSheetFormat = (ssfLastFirst, ssfFirstLastFirst);
    var
      FCurrTemplateFolder: string;
      FCurrOutputFolder: string;
    procedure AddStatus(const NewStatus: string);
    procedure ParseSpreadsheetToDataSet(const AFilename: string; const SSFormat: SpreadSheetFormat);
    procedure GenerateWebPagesFromTemplates(const TemplateFolder, OutputFolder,
                                                  SpreadsheetFilename: string;
                                                  const SSFormat: SpreadSheetFormat);
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
  edtLastNamesSpreadsheetFile.Text := ccRegistryLayoutSaver.RestoreStrValue('LastNamesSpreadsheetFilename');
  edtFirstNamesSpreadsheetFile.Text := ccRegistryLayoutSaver.RestoreStrValue('FirstNamesSpreadsheetFilename');
  edtHTMLTemplateFolder.Text := ccRegistryLayoutSaver.RestoreStrValue('WebTemplatFolder');
  edtHTMLOutputFolder.Text := ccRegistryLayoutSaver.RestoreStrValue('WebOutputFolder');
  cbTestMode.Checked := ccRegistryLayoutSaver.RestoreBoolValue('RandPicNames');
end;

procedure TfrmPicSSConvert.FormDestroy(Sender: TObject);
begin
  ccRegistryLayoutSaver.SaveStrValue('LastNamesSpreadsheetFilename', edtLastNamesSpreadsheetFile.Text);
  ccRegistryLayoutSaver.SaveStrValue('FirstNamesSpreadsheetFilename', edtFirstNamesSpreadsheetFile.Text);
  ccRegistryLayoutSaver.SaveStrValue('WebTemplatFolder', edtHTMLTemplateFolder.Text);
  ccRegistryLayoutSaver.SaveStrValue('WebOutputFolder', edtHTMLOutputFolder.Text);
  ccRegistryLayoutSaver.SaveBoolValue('RandPicNames', cbTestMode.Checked);
end;

procedure TfrmPicSSConvert.actFindFirstNamesSpreadsheetExecute(Sender: TObject);
begin
  if Length(edtFirstNamesSpreadsheetFile.Text) > 0 then
    dlgOpenSpreadsheet.FileName := edtFirstNamesSpreadsheetFile.Text;

  if dlgOpenSpreadsheet.Execute then
    edtFirstNamesSpreadsheetFile.Text := dlgOpenSpreadsheet.FileName;
end;

procedure TfrmPicSSConvert.actFindLastNamesSpreadsheetExecute(Sender: TObject);
begin
  if Length(edtLastNamesSpreadsheetFile.Text) > 0 then
    dlgOpenSpreadsheet.FileName := edtLastNamesSpreadsheetFile.Text;

  if dlgOpenSpreadsheet.Execute then
    edtLastNamesSpreadsheetFile.Text := dlgOpenSpreadsheet.FileName;
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

procedure TfrmPicSSConvert.ParseSpreadsheetToDataSet(const AFilename: string; const SSFormat: SpreadSheetFormat);
var
  Xls: TExcelFile;
  r: Integer;
  LastNameColumn: Integer;
begin
  Xls := TXlsFile.Create;
  xls.Open(AFileName);
  AddStatus('Reading rows: ' + IntToStr(xls.RowCount));

  dmChurchPicsWebBroker.cdsChurchPics.EmptyDataSet;

  case SSFormat of
    ssfLastFirst:
      LastNameColumn := 1;
    ssfFirstLastFirst:
      LastNameColumn := 2;
    else
      LastNameColumn := 1;
  end;


  for r := 1 to xls.RowCount do
    if xls.ColCountInRow(r) > 1 then begin
      AddStatus(Format('  %s (%s)',
                      [xls.GetStringFromCell(r, 1).ToString,
                       xls.GetStringFromCell(r, 2).ToString]));

      dmChurchPicsWebBroker.cdsChurchPics.Append;
      if SSFormat = ssfFirstLastFirst then
        dmChurchPicsWebBroker.cdsChurchPicsBoldName.AsString := xls.GetStringFromCell(r, 1).ToString;
      dmChurchPicsWebBroker.cdsChurchPicsLastName.AsString := xls.GetStringFromCell(r, LastNameColumn).ToString;
      dmChurchPicsWebBroker.cdsChurchPicsFirstNames.AsString := xls.GetStringFromCell(r, LastNameColumn + 1).ToString;
      dmChurchPicsWebBroker.cdsChurchPicsChildNames.AsString := xls.GetStringFromCell(r, LastNameColumn + 2).ToString;
      dmChurchPicsWebBroker.cdsChurchPicsPictureName.AsString := xls.GetStringFromCell(r, LastNameColumn + 1).ToString;
      dmChurchPicsWebBroker.cdsChurchPics.Post;
    end;
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
                                    cbTestMode.Checked);
  AddStatus('Generated ' + FileInfo.Name);
end;

procedure TfrmPicSSConvert.actGenerateWebPagesExecute(Sender: TObject);
begin
  if Length(edtHTMLTemplateFolder.Text) = 0 then
    ShowMessage('Please specify the HTML Template Folder.')
  else if Length(edtHTMLOutputFolder.Text) = 0 then
    ShowMessage('Please specify the output folder for generated HTML pages.')
  else begin
    GenerateWebPagesFromTemplates(edtHTMLTemplateFolder.Text,
                                  edtHTMLOutputFolder.Text,
                                  edtLastNamesSpreadsheetFile.Text,
                                  ssfLastFirst);
    GenerateWebPagesFromTemplates(edtHTMLTemplateFolder.Text,
                                  edtHTMLOutputFolder.Text,
                                  edtFirstNamesSpreadsheetFile.Text,
                                  ssfFirstLastFirst);
  end;
end;

procedure TfrmPicSSConvert.GenerateWebPagesFromTemplates(const TemplateFolder, OutputFolder,
                                                  SpreadsheetFilename: string;
                                                  const SSFormat: SpreadSheetFormat);
begin
  ParseSpreadsheetToDataSet(SpreadsheetFilename, SSFormat);

  if dmChurchPicsWebBroker.cdsChurchPics.RecordCount = 0 then
    ShowMessage('No data found in spreadsheet.')
  else begin
    AddStatus(Format('Generating web pages for %d directory entries.', [dmChurchPicsWebBroker.cdsChurchPics.RecordCount]));

    FCurrTemplateFolder := TemplateFolder;
    FCurrOutputFolder := OutputFolder;

    case SSFormat of
      ssfLastFirst: begin
        dmChurchPicsWebBroker.cdsChurchPics.IndexName := 'idxLastName';
        GetSearchRecs(TemplateFolder, 'LastName*.html', False, WebTemplateFound, WebTemplateProcess);
      end;
      ssfFirstLastFirst: begin
        dmChurchPicsWebBroker.cdsChurchPics.IndexName := 'idxChurchPicsIndexChar';
        GetSearchRecs(TemplateFolder, 'FirstName*.html', False, WebTemplateFound, WebTemplateProcess);
      end;
    end;
  end;
end;

end.

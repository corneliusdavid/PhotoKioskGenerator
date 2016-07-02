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
    Panel1: TPanel;
    lbConvertLog: TListBox;
    lbConvertStatus: TListBox;
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
    procedure AddLog(const NewLog: string);
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
  System.IOUtils, System.Win.ComObj,
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

procedure TfrmPicSSConvert.AddLog(const NewLog: string);
begin
  lbConvertLog.Items.Add(NewLog);
  lbConvertLog.ItemIndex := lbConvertLog.Items.Count - 1;
  lbConvertLog.Update;
end;

procedure TfrmPicSSConvert.AddStatus(const NewStatus: string);
begin
  lbConvertStatus.Items.Add(NewStatus);
  lbConvertStatus.ItemIndex := lbConvertStatus.Items.Count - 1;
  lbConvertStatus.Update;
end;

procedure TfrmPicSSConvert.ParseSpreadsheetToDataSet(const AFilename: string; const SSFormat: SpreadSheetFormat);
var
  ExcelApp: OleVariant;
  CurrRow: Integer;
  LastNameColumn: Integer;
  done: Boolean;
  name1, name2: string;
begin
  ExcelApp := CreateOleObject('Excel.Application');

  ExcelApp.Workbooks.Open(AFilename);

  dmChurchPicsWebBroker.cdsChurchPics.EmptyDataSet;

  case SSFormat of
    ssfLastFirst:
      LastNameColumn := 1;
    ssfFirstLastFirst:
      LastNameColumn := 2;
    else
      LastNameColumn := 1;
  end;

  done := False;
  Currrow := 1;
  while not done do begin
    name1 := ExcelApp.Cells[CurrRow, 1];
    name2 := ExcelApp.Cells[CurrRow, 2];

    if (Length(name1) = 0) or (Length(name2) = 0) then
      done := True
    else begin
      AddStatus(Format('  %s (%s)',
                      [name1, name2]));

      dmChurchPicsWebBroker.cdsChurchPics.Append;
      if SSFormat = ssfFirstLastFirst then
        dmChurchPicsWebBroker.cdsChurchPicsBoldName.AsString := ExcelApp.Cells[Currrow, 1];
      dmChurchPicsWebBroker.cdsChurchPicsLastName.AsString := ExcelApp.Cells[Currrow, LastNameColumn];
      dmChurchPicsWebBroker.cdsChurchPicsFirstNames.AsString := ExcelApp.Cells[Currrow, LastNameColumn + 1];
      dmChurchPicsWebBroker.cdsChurchPicsChildNames.AsString := ExcelApp.Cells[Currrow, LastNameColumn + 2];
      dmChurchPicsWebBroker.cdsChurchPicsPictureName.AsString := ExcelApp.Cells[Currrow, 5];
      dmChurchPicsWebBroker.cdsChurchPics.Post;
    end;

    Inc(CurrRow);
  end;

  ExcelApp := NULL;
end;

procedure TfrmPicSSConvert.WebTemplateFound(const Path: string; var Stop: Boolean);
begin
  AddLog('Processing files in: ' + Path);
  Stop := False;
end;

procedure TfrmPicSSConvert.WebTemplateProcess(FileInfo: TSearchRec);
begin
  dmChurchPicsWebBroker.ProcessFile(TPath.Combine(FCurrTemplateFolder, FileInfo.Name),
                                    TPath.Combine(FCurrOutputFolder, FileInfo.Name),
                                    cbTestMode.Checked);
  AddLog('Generated ' + FileInfo.Name);
end;

procedure TfrmPicSSConvert.actGenerateWebPagesExecute(Sender: TObject);
begin
  if Length(edtHTMLTemplateFolder.Text) = 0 then
    ShowMessage('Please specify the HTML Template Folder.')
  else if Length(edtHTMLOutputFolder.Text) = 0 then
    ShowMessage('Please specify the output folder for generated HTML pages.')
  else begin
    Screen.Cursor := crHourGlass;
    try
      GenerateWebPagesFromTemplates(edtHTMLTemplateFolder.Text,
                                    edtHTMLOutputFolder.Text,
                                    edtLastNamesSpreadsheetFile.Text,
                                    ssfLastFirst);
      GenerateWebPagesFromTemplates(edtHTMLTemplateFolder.Text,
                                    edtHTMLOutputFolder.Text,
                                    edtFirstNamesSpreadsheetFile.Text,
                                    ssfFirstLastFirst);
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TfrmPicSSConvert.GenerateWebPagesFromTemplates(const TemplateFolder, OutputFolder,
                                                  SpreadsheetFilename: string;
                                                  const SSFormat: SpreadSheetFormat);
begin
  AddLog(Format('Reading spreadsheet: %s', [SpreadsheetFilename]));
  ParseSpreadsheetToDataSet(SpreadsheetFilename, SSFormat);

  if dmChurchPicsWebBroker.cdsChurchPics.RecordCount = 0 then
    ShowMessage('No data found in spreadsheet.')
  else begin
    AddLog(Format('Generating web pages for %d directory entries.', [dmChurchPicsWebBroker.cdsChurchPics.RecordCount]));

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

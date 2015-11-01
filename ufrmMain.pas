unit ufrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, JvBaseDlg,
  JvSelectDirectory, LayoutSaver, System.Actions, Vcl.ActnList,
  System.ImageList, Vcl.ImgList, Vcl.Buttons, Data.Win.ADODB, Data.DB, MemDS,
  DBAccess, Uni, UniProvider, SQLiteUniProvider, FMX.FlexCel.DocExport,
  VCL.FlexCel.Core, FlexCel.XlsAdapter, FlexCel.Render, FlexCel.Preview;

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
    actOpenSpreadsheet: TAction;
    SQLiteUniProvider: TSQLiteUniProvider;
    UniConnection1: TUniConnection;
    UniTable1: TUniTable;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actFindSpreadsheetExecute(Sender: TObject);
    procedure actOpenSpreadsheetExecute(Sender: TObject);
  private
    procedure ConvertSpreadsheetTMS(const AFilename: string);
  end;

var
  frmPicSSConvert: TfrmPicSSConvert;

implementation

{$R *.dfm}

uses
  System.IOUtils,
  FlexCel.Core;

procedure TfrmPicSSConvert.actFindSpreadsheetExecute(Sender: TObject);
begin
  if Length(edtSpreadsheetFile.Text) > 0 then
    dlgOpenSpreadsheet.FileName := edtSpreadsheetFile.Text;

  if dlgOpenSpreadsheet.Execute then
    edtSpreadsheetFile.Text := dlgOpenSpreadsheet.FileName;
end;

procedure TfrmPicSSConvert.actOpenSpreadsheetExecute(Sender: TObject);
begin
  if Length(edtSpreadsheetFile.Text) = 0 then
    ShowMessage('Please select a spreadsheet file first.')
  else if not FileExists(edtSpreadsheetFile.Text) then
    ShowMessage('The file doesn''t exist.')
  else
    ConvertSpreadsheetTMS(edtSpreadsheetFile.Text);
end;

procedure TfrmPicSSConvert.ConvertSpreadsheetTMS(const AFilename: string);
var
  Xls: TExcelFile;
  r: Integer;
begin
  Xls := TXlsFile.Create;
  xls.Open(AFileName);
  lbConvertLog.Items.Add('Reading rows: ' + IntToStr(xls.RowCount));

  for r := 1 to xls.RowCount do
    if xls.ColCountInRow(r) >= 4 then
      lbConvertLog.Items.Add(Format('Surname=%s, Primary=%s, Secondary=%s, Filename=%s',
                      [xls.GetStringFromCell(r, 1).ToString,
                       xls.GetStringFromCell(r, 2).ToString,
                       xls.GetStringFromCell(r, 3).ToString,
                       xls.GetStringFromCell(r, 4).ToString]));
end;

procedure TfrmPicSSConvert.FormCreate(Sender: TObject);
begin
  edtSpreadsheetFile.Text := ccRegistryLayoutSaver.ResstoreStrValue('SpreadsheetFilename');
end;

procedure TfrmPicSSConvert.FormDestroy(Sender: TObject);
begin
  ccRegistryLayoutSaver.SaveStrValue('SpreadsheetFilename', edtSpreadsheetFile.Text);
end;

end.

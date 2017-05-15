unit ufrmNameSheetBuilderMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, LayoutSaver, Vcl.Buttons;

type
  TfrmNameSheetBuilder = class(TForm)
    Label1: TLabel;
    ccRegistryLayoutSaver: TccRegistryLayoutSaver;
    grpDatabase: TGroupBox;
    edtDBServerName: TLabeledEdit;
    edtDBUsername: TLabeledEdit;
    edtDBPassword: TLabeledEdit;
    ccRegistrySheetSaver: TccRegistryLayoutSaver;
    GroupBox1: TGroupBox;
    edtLastNamesSpreadsheetFile: TLabeledEdit;
    edtFirstNamesSpreadsheetFile: TLabeledEdit;
    btnGenSpreadsheets: TBitBtn;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnGenSpreadsheetsClick(Sender: TObject);
  private
    const
      REGVAL_DBServerName = 'Database Server Name';
      REGVAL_DBUserName = 'Database User Name';
    procedure ClearExistingSpreadsheet(var ExcelApp: OleVariant);
    procedure GenerateSpreadsheets;
    procedure CreateLastNamesSpreadsheet;
    procedure CreateFirstNamesSpreadsheet;
  end;

var
  frmNameSheetBuilder: TfrmNameSheetBuilder;

implementation

{$R *.dfm}

uses
  System.Win.ComObj,
  udmNameSheetData,
  uPhotoData;

procedure TfrmNameSheetBuilder.btnGenSpreadsheetsClick(Sender: TObject);
begin
  GenerateSpreadsheets;
end;

procedure TfrmNameSheetBuilder.ClearExistingSpreadsheet(var ExcelApp: OleVariant);
var
  done: Boolean;
  row: Integer;
  col: Integer;
begin
  // clear out old data
  done := False;
  row := 1;
  while not done do   begin
    // each row should have something in either the first or second column
    if (Length(ExcelApp.Cells[row, 1]) = 0) or (Length(ExcelApp.Cells[row, 2]) = 0) then
      done := True;

    // set all fields in the row to blank
    for col := 1 to 5 do
      ExcelApp.Cells[row, col] := EmptyStr;

    Inc(row);
  end;
end;

procedure TfrmNameSheetBuilder.CreateFirstNamesSpreadsheet;
var
  ExcelApp: OleVariant;
  row, col: Integer;
  done: Boolean;
begin
  ExcelApp := CreateOleObject('Excel.Application');
  ExcelApp.Workbooks.Open(edtFirstNamesSpreadsheetFile.Text);

  ClearExistingSpreadsheet(ExcelApp);


  ExcelApp.Cells[3, 3] := 'Test';

  ExcelApp.ActiveWorkbook.Save;
  ExcelApp.Workbooks.Close;
  ExcelApp := null;
end;

procedure TfrmNameSheetBuilder.CreateLastNamesSpreadsheet;
var
  ExcelApp: OleVariant;
begin
  ExcelApp := CreateOleObject('Excel.Application');
  ExcelApp.Workbooks.Open(edtLastNamesSpreadsheetFile.Text);

  ClearExistingSpreadsheet(ExcelApp);

  ExcelApp.Cells[2, 2] := 'Test';

  ExcelApp.ActiveWorkbook.Save;
  ExcelApp.Workbooks.Close;
  ExcelApp := null;
end;

procedure TfrmNameSheetBuilder.FormActivate(Sender: TObject);
begin
  edtDBServerName.Text := ccRegistryLayoutSaver.RestoreStrValue(REGVAL_DBServerName);
  edtDBUsername.Text := ccRegistryLayoutSaver.RestoreStrValue(REGVAL_DBUserName);

  edtLastNamesSpreadsheetFile.Text := ccRegistrySheetSaver.RestoreStrValue('LastNamesSpreadsheetFilename');
  edtFirstNamesSpreadsheetFile.Text := ccRegistrySheetSaver.RestoreStrValue('FirstNamesSpreadsheetFilename');
end;

procedure TfrmNameSheetBuilder.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ccRegistryLayoutSaver.SaveStrValue(REGVAL_DBServerName, edtDBServerName.Text);
  ccRegistryLayoutSaver.SaveStrValue(REGVAL_DBUserName, edtDBUsername.Text);
end;

procedure TfrmNameSheetBuilder.GenerateSpreadsheets;
begin
  dmNameSheetData.Connect(edtDBServerName.Text, edtDBUsername.Text, edtDBPassword.Text);
  CreateLastNamesSpreadsheet;
  CreateFirstNamesSpreadsheet;
end;

end.

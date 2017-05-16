unit ufrmNameSheetBuilderMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics,
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
      REGVAL_DBPassword = 'Database Password';
  end;

var
  frmNameSheetBuilder: TfrmNameSheetBuilder;

implementation

{$R *.dfm}

uses
  uNameSheetBuilder;

procedure TfrmNameSheetBuilder.btnGenSpreadsheetsClick(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  try
    GenerateSpreadsheets(edtDBServerName.Text, edtDBUsername.Text, edtDBPassword.Text,
                         edtLastNamesSpreadsheetFile.Text, edtFirstNamesSpreadsheetFile.Text);
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmNameSheetBuilder.FormActivate(Sender: TObject);
begin
  edtDBServerName.Text := ccRegistryLayoutSaver.RestoreStrValue(REGVAL_DBServerName);
  edtDBUsername.Text := ccRegistryLayoutSaver.RestoreStrValue(REGVAL_DBUserName);
  edtDBPassword.Text := ccRegistryLayoutSaver.RestoreStrValue(REGVAL_DBPassword);

  edtLastNamesSpreadsheetFile.Text := ccRegistrySheetSaver.RestoreStrValue('LastNamesSpreadsheetFilename');
  edtFirstNamesSpreadsheetFile.Text := ccRegistrySheetSaver.RestoreStrValue('FirstNamesSpreadsheetFilename');
end;

procedure TfrmNameSheetBuilder.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ccRegistryLayoutSaver.SaveStrValue(REGVAL_DBServerName, edtDBServerName.Text);
  ccRegistryLayoutSaver.SaveStrValue(REGVAL_DBUserName, edtDBUsername.Text);
  ccRegistryLayoutSaver.SaveStrValue(REGVAL_DBPassword, edtDBPassword.Text);
end;

end.

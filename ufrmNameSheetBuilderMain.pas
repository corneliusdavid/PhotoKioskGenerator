unit ufrmNameSheetBuilderMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, LayoutSaver, Vcl.Buttons,
  Vcl.ComCtrls;

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
    pbLastNames: TProgressBar;
    pbFirstNames: TProgressBar;
    lblGenStatus: TLabel;
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

var
  TotalRecsGenerated: Integer;

procedure UpdateTotalRecordsStatus;
begin
  frmNameSheetBuilder.lblGenStatus.Caption := 'Records generated: ' + IntToStr(TotalRecsGenerated);
  frmNameSheetBuilder.lblGenStatus.Update;
end;

procedure IncrementTotalRecordsGenerated;
begin
  Inc(TotalRecsGenerated);
  if TotalRecsGenerated mod 10 = 0 then
    UpdateTotalRecordsStatus;
end;

procedure UpdateLastNameProgressBar(const CurrPos, MaxPos: Integer);
begin
  frmNameSheetBuilder.pbLastNames.Max := MaxPos;
  frmNameSheetBuilder.pbLastNames.Position := CurrPos;
  frmNameSheetBuilder.pbLastNames.Update;
  IncrementTotalRecordsGenerated;
end;

procedure UpdateFirstNameProgressBar(const CurrPos, MaxPos: Integer);
begin
  frmNameSheetBuilder.pbFirstNames.Max := MaxPos;
  frmNameSheetBuilder.pbFirstNames.Position := CurrPos;
  frmNameSheetBuilder.pbFirstNames.Update;
  IncrementTotalRecordsGenerated;
end;

procedure TfrmNameSheetBuilder.btnGenSpreadsheetsClick(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  TotalRecsGenerated := 0;
  pbLastNames.Position := 0;
  pbFirstNames.Position := 0;
  pbLastNames.Visible := True;
  pbFirstNames.Visible := True;
  try
    ConnectToDatabase(edtDBServerName.Text, edtDBUsername.Text, edtDBPassword.Text);
    CreateLastNamesSpreadsheet(edtLastNamesSpreadsheetFile.Text, UpdateLastNameProgressBar);
    CreateFirstNamesSpreadsheet(edtFirstNamesSpreadsheetFile.Text, UpdateFirstNameProgressBar);
    UpdateTotalRecordsStatus;
  finally
    DisconnectFromDatabase;
    pbLastNames.Visible := False;
    pbFirstNames.Visible := False;
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

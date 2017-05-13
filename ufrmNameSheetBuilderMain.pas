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
    BitBtn1: TBitBtn;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    const
      REGVAL_DBServerName = 'Database Server Name';
      REGVAL_DBUserName = 'Database User Name';
  end;

var
  frmNameSheetBuilder: TfrmNameSheetBuilder;

implementation

{$R *.dfm}

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

end.

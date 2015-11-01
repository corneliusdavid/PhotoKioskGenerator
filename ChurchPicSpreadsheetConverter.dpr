program ChurchPicSpreadsheetConverter;

uses
  Vcl.Forms,
  ufrmMain in 'ufrmMain.pas' {frmPicSSConvert};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPicSSConvert, frmPicSSConvert);
  Application.Run;
end.

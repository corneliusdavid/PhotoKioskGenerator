program NameSheetConverter;

uses
  Vcl.Forms,
  ufrmMain in 'ufrmMain.pas' {frmPicSSConvert},
  udmChurchPicsWebBroker in 'udmChurchPicsWebBroker.pas' {dmChurchPicsWebBroker: TDataModule},
  uSearchRecList in 'V:\lib\CorneliusConcepts\uSearchRecList.pas',
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Cyan Night');
  Application.CreateForm(TfrmPicSSConvert, frmPicSSConvert);
  Application.CreateForm(TdmChurchPicsWebBroker, dmChurchPicsWebBroker);
  Application.Run;
end.

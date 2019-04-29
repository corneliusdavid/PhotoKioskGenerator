program NameSheetConverter;

uses
  Vcl.Forms,
  ufrmMain in 'ufrmMain.pas' {frmPicSSConvert},
  udmChurchPicsWebBroker in 'udmChurchPicsWebBroker.pas' {dmChurchPicsWebBroker: TDataModule},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Amethyst Kamri');
  Application.CreateForm(TfrmPicSSConvert, frmPicSSConvert);
  Application.CreateForm(TdmChurchPicsWebBroker, dmChurchPicsWebBroker);
  Application.Run;
end.

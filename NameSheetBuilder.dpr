program NameSheetBuilder;

uses
  Vcl.Forms,
  ufrmNameSheetBuilderMain in 'ufrmNameSheetBuilderMain.pas' {frmNameSheetBuilder},
  udmNameSheetData in 'udmNameSheetData.pas' {dmNameSheetData: TDataModule},
  uPhotoData in 'uPhotoData.pas',
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Cyan Night');
  Application.CreateForm(TfrmNameSheetBuilder, frmNameSheetBuilder);
  Application.CreateForm(TdmNameSheetData, dmNameSheetData);
  Application.Run;
end.

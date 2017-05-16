program NameSheetBuilder;

uses
  Vcl.Forms,
  ufrmNameSheetBuilderMain in 'ufrmNameSheetBuilderMain.pas' {frmNameSheetBuilder},
  udmNameSheetData in 'udmNameSheetData.pas' {dmNameSheetData: TDataModule},
  Vcl.Themes,
  Vcl.Styles,
  uNameSheetBuilder in 'uNameSheetBuilder.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Cyan Night');
  Application.CreateForm(TfrmNameSheetBuilder, frmNameSheetBuilder);
  Application.CreateForm(TdmNameSheetData, dmNameSheetData);
  Application.Run;
end.

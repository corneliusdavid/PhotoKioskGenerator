program NameSheetBuilder;

uses
  Vcl.Forms,
  ufrmNameSheetBuilderMain in 'ufrmNameSheetBuilderMain.pas' {frmNameSheetBuilder},
  udmNameSheetData in 'udmNameSheetData.pas' {dmNameSheetDAta: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmNameSheetBuilder, frmNameSheetBuilder);
  Application.CreateForm(TdmNameSheetDAta, dmNameSheetDAta);
  Application.Run;
end.

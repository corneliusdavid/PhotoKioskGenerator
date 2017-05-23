unit uNameSheetBuilder;

interface

type
  ProgressUpdateProc = procedure (const CurrPos, MaxPos: Integer);

procedure ConnectToDatabase(const DBServer, DBUser, DBPassword: string);
procedure DisconnectFromDatabase;

procedure CreateFirstNamesSpreadsheet(const SpreadsheetFilename: string; UpdateProgressBar: ProgressUpdateProc);
procedure CreateLastNamesSpreadsheet(const SpreadsheetFilename: string; UpdateProgressBar: ProgressUpdateProc);


implementation

uses
  System.Variants, System.Win.ComObj, System.SysUtils,
  udmNameSheetData;

procedure ConnectToDatabase(const DBServer, DBUser, DBPassword: string);
begin
  dmNameSheetData.Connect(DBServer, DBUser, DBPassword);
end;

procedure DisconnectFromDatabase;
begin
  dmNameSheetData.ADOConnection.Close;
end;

procedure ClearExistingSpreadsheet(var ExcelApp: OleVariant);
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

procedure CreateFirstNamesSpreadsheet(const SpreadsheetFilename: string; UpdateProgressBar: ProgressUpdateProc);
var
  ExcelApp, Books, ActiveBk: OleVariant;
  row, maxrow: Integer;
  done: Boolean;
begin
  ExcelApp := CreateOleObject('Excel.Application');
  Books := ExcelApp.Workbooks;
  try
    Books.Open(SpreadsheetFilename);

    ClearExistingSpreadsheet(ExcelApp);

    dmNameSheetData.PrepareFirstNameList;
    maxrow := dmNameSheetData.qryFirstNames.RecordCount;

    row := 1;
    repeat
      done := dmNameSheetData.GetNextRow;

      ExcelApp.Cells[row, 1] := dmNameSheetData.PhotoEntry.FirstName;
      ExcelApp.Cells[row, 2] := dmNameSheetData.PhotoEntry.LastName;
      ExcelApp.Cells[row, 3] := dmNameSheetData.PhotoEntry.ParentNames;
      ExcelApp.Cells[row, 4] := dmNameSheetData.PhotoEntry.ChildNames;
      ExcelApp.Cells[row, 5] := dmNameSheetData.PhotoEntry.PhotoFilename;

      UpdateProgressBar(row, maxrow);

      Inc(row);
    until done;

    ExcelApp.ActiveWorkbook.Save;
    ExcelApp.Workbooks.Close;
    ExcelApp.Quit;
  finally
    Books := null;
    ExcelApp := null;
  end;
end;

procedure CreateLastNamesSpreadsheet(const SpreadsheetFilename: string; UpdateProgressBar: ProgressUpdateProc);
var
  ExcelApp, Books: OleVariant;
  row, maxrow: Integer;
  done: Boolean;
begin
  ExcelApp := CreateOleObject('Excel.Application');
  try
    Books := ExcelApp.Workbooks;
    Books.Open(SpreadsheetFilename);

    ClearExistingSpreadsheet(ExcelApp);

    dmNameSheetData.PrepareLastNameList;
    maxrow := dmNameSheetData.qryLastNames.RecordCount;

    row := 1;
    repeat
      done := dmNameSheetData.GetNextRow;

      ExcelApp.Cells[row, 1] := dmNameSheetData.PhotoEntry.LastName;
      ExcelApp.Cells[row, 2] := dmNameSheetData.PhotoEntry.ParentNames;
      ExcelApp.Cells[row, 3] := dmNameSheetData.PhotoEntry.ChildNames;
      ExcelApp.Cells[row, 5] := dmNameSheetData.PhotoEntry.PhotoFilename;

      UpdateProgressBar(row, maxrow);

      Inc(row);
    until done;

    ExcelApp.ActiveWorkbook.Save;
    ExcelApp.Workbooks.Close;
    ExcelApp.Quit;
  finally
    Books := null;
    ExcelApp := null;
  end;
end;

end.

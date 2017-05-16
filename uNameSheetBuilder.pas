unit uNameSheetBuilder;

interface

procedure GenerateSpreadsheets(const DBServer, DBUser, DBPassword, LastNamesSpreadsheet, FirstNamesSpreadsheet: string);

implementation

uses
  System.Variants, System.Win.ComObj, System.SysUtils,
  udmNameSheetData;

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

procedure CreateFirstNamesSpreadsheet(const SpreadsheetFilename: string);
var
  ExcelApp: OleVariant;
  row, col: Integer;
  done: Boolean;
begin
  ExcelApp := CreateOleObject('Excel.Application');
  ExcelApp.Workbooks.Open(SpreadsheetFilename);

  ClearExistingSpreadsheet(ExcelApp);

  dmNameSheetData.PrepareFirstNameList;

  row := 1;
  done := False;
  repeat
    done := dmNameSheetData.GetNextRow;

    ExcelApp.Cells[row, 1] := dmNameSheetData.PhotoEntry.FirstName;
    ExcelApp.Cells[row, 2] := dmNameSheetData.PhotoEntry.LastName;
    ExcelApp.Cells[row, 3] := dmNameSheetData.PhotoEntry.ParentNames;
    ExcelApp.Cells[row, 4] := dmNameSheetData.PhotoEntry.ChildNames;
    ExcelApp.Cells[row, 5] := dmNameSheetData.PhotoEntry.PhotoFilename;

    Inc(row);
  until done;

  ExcelApp.ActiveWorkbook.Save;
  ExcelApp.Workbooks.Close;
  ExcelApp := null;
end;

procedure CreateLastNamesSpreadsheet(const SpreadsheetFilename: string);
var
  ExcelApp: OleVariant;
  row: Integer;
  done: Boolean;
begin
  ExcelApp := CreateOleObject('Excel.Application');
  ExcelApp.Workbooks.Open(SpreadsheetFilename);

  ClearExistingSpreadsheet(ExcelApp);
  dmNameSheetData.PrepareLastNameList;

  row := 1;
  done := False;
  repeat
    done := dmNameSheetData.GetNextRow;

    ExcelApp.Cells[row, 1] := dmNameSheetData.PhotoEntry.LastName;
    ExcelApp.Cells[row, 2] := dmNameSheetData.PhotoEntry.ParentNames;
    ExcelApp.Cells[row, 3] := dmNameSheetData.PhotoEntry.ChildNames;
    ExcelApp.Cells[row, 5] := dmNameSheetData.PhotoEntry.PhotoFilename;

    Inc(row);
  until done;

  ExcelApp.ActiveWorkbook.Save;
  ExcelApp.Workbooks.Close;
  ExcelApp := null;
end;

procedure GenerateSpreadsheets(const DBServer, DBUser, DBPassword, LastNamesSpreadsheet, FirstNamesSpreadsheet: string);
begin
  dmNameSheetData.Connect(DBServer, DBUser, DBPassword);
  CreateLastNamesSpreadsheet(LastNamesSpreadsheet);
  CreateFirstNamesSpreadsheet(FirstNamesSpreadsheet);
end;

end.

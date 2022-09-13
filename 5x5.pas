{$mode objfpc}{$M+}
uses Crt;

type
  Cell = record
    Check: (Checked, Unchecked);
    CellIndex: Integer;
  end;


  Field = array[0..24] of Cell;

  Row = array[0..4] of Cell;

var
  Input: Char;
  CursorPosition: Integer;

function SubArray(Ary: Field; Start, Count: Integer): Row;
var
  i: Integer;
begin
  for i := Start to Start + Count do
    Result[i - Start] := Ary[i];
end;


procedure CreateField(var MainField: Field);
var
  i: Integer;
begin
  for i := 0 to 24 do
  begin
    MainField[i].Check := Unchecked;
    MainField[i].CellIndex := i;
  end;
end;

procedure DisplayRow(var CurrentRow: Row);
var
  i: Integer;
  j: Integer;
  CurrentCell: Cell;
begin
  for i:=0 to 2 do
  begin
    for j :=0 to 4 do
    begin
      CurrentCell := CurrentRow[j];
      if (CurrentCell.CellIndex = CursorPosition) then
        TextColor(Green);
      if (CurrentCell.Check = Checked) then
        Write('# # #')
      else
        Write('* * *');
      TextColor(White);
      Write(' | ')
    end;
    WriteLn();
  end;
  WriteLn('---------------------------------------');
end;

procedure DisplayField(var MainField: Field);
var
  i, start, count: Integer;
  CurrentCells: Row;
begin
  ClrScr;
  for i := 0 to 4 do
  begin
    start := 5 * i;
    count := 4;
    CurrentCells := SubArray(MainField, start, count);
    DisplayRow(CurrentCells);
  end;
end;

procedure MoveLeft();
begin
  CursorPosition := CursorPosition - 1;
  if (CursorPosition < 0) then
    CursorPosition := 0;
  WriteLn(CursorPosition);
end;

procedure MoveRight();
begin
  CursorPosition := CursorPosition + 1;
  if (CursorPosition > 24) then
    CursorPosition := 24;
end;

procedure MoveDown();
begin
  CursorPosition := CursorPosition + 5;
  if (CursorPosition > 24) then
    CursorPosition := CursorPosition - 5;
  WriteLn(CursorPosition);
end;

procedure MoveUp();
begin
  CursorPosition := CursorPosition - 5;
  if (CursorPosition < 0) then
    CursorPosition := CursorPosition + 5;
  WriteLn(CursorPosition);
end;

procedure InputHandler(Input: Char);
begin
  case Input of
    'a': MoveLeft();
    'd': MoveRight();
    's': MoveDown();
    'w': MoveUp();
    ' ': SelectCell();
  end;
end;

procedure ClearCmd();
begin
  Write(Chr(27), '[', 5, 'A');
  Write(Chr(27), '[', 5 * 3, 'D');
end;

var
  MainField: Field;
begin
  CursorPosition := 0;
  CreateField(MainField);
  DisplayField(MainField);
  while true do
  begin
    Input := ReadKey;
    InputHandler(Input);
    ClearCmd();
    DisplayField(MainField);
    if Input = #27 then
      Break;
  end;
end.

{$mode objfpc}{$M+}
uses Crt;

type
  Cell = record
    Check: (Checked, Unchecked);
    CellIndex: Integer;
  end;

  CellPointer = ^Cell;

  Field = array[0..24] of Cell;

  Row = array[0..4] of Cell;

  CellPtrPtr = ^ CellPointer;

  RowOfPntrs = array[0..4] of CellPointer;

var
  Input: Char;
  CursorPosition: Integer;
  MainField: Field;

function SubArray(Ary: Field; Start, Count: Integer): Row;
var
  i: Integer;
begin
  for i := Start to Start + Count do
    Result[i - Start] := Ary[i];
end;

function SubArrayOfPntrs(Start, Count: Integer): RowOfPntrs;
var
  i: Integer;
begin
  for i := Start to Start + Count do
  begin
    Result[i - Start] := @MainField[i];
  end;
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
end;

procedure MoveUp();
begin
  CursorPosition := CursorPosition - 5;
  if (CursorPosition < 0) then
    CursorPosition := CursorPosition + 5;
end;

procedure CheckVerticalNbrs();
var
  UpperCell: CellPointer;
  LowerCell: CellPointer;
begin
  try
    UpperCell := @MainField[CursorPosition - 5];
    if (UpperCell^.Check = Checked) then
      UpperCell^.Check := Unchecked
    else
      UpperCell^.Check := Checked;
  except
  end;
  try
    LowerCell := @MainField[CursorPosition + 5];
    if (LowerCell^.Check = Checked) then
      LowerCell^.Check := Unchecked
    else
      LowerCell^.Check := Checked;
  except
  end;

end;

procedure CheckHorizontalNbrs();
var
  CurrentRow: RowOfPntrs;
  CurrentRowIndex, LeftIndex, RightIndex: Integer;
  LeftCell, RightCell: CellPointer;
begin
  CurrentRowIndex := CursorPosition div 5 * 5;
  LeftIndex := CursorPosition mod 5 - 1;
  RightIndex := CursorPosition mod 5 + 1;
  CurrentRow := SubArrayOfPntrs(CurrentRowIndex, 4);
  if (LeftIndex >= 0) then
  begin
    LeftCell := CurrentRow[LeftIndex];
    case LeftCell^.Check of
      Checked: LeftCell^.Check := Unchecked;
      Unchecked: LeftCell^.Check := Checked;
    end;
  end;
  if (RightIndex <= 4) then
  begin
    RightCell := CurrentRow[RightIndex];
    case RightCell^.Check of
      Checked: RightCell^.Check := Unchecked;
      Unchecked: RightCell^.Check := Checked;
    end;
  end;

end;

procedure CheckCell();
var
  CurrentCell: CellPointer;
begin
  CurrentCell := @MainField[CursorPosition];
  if (CurrentCell^.Check = Checked) then
    CurrentCell^.Check := Unchecked
  else
    CurrentCell^.Check := Checked;
  CheckVerticalNbrs();
  CheckHorizontalNbrs();
end;

procedure InputHandler(Input: Char);
begin
  case Input of
    'a': MoveLeft();
    'd': MoveRight();
    's': MoveDown();
    'w': MoveUp();
    'f': CheckCell();
  end;
end;

procedure ClearCmd();
begin
  Write(Chr(27), '[', 5, 'A');
  Write(Chr(27), '[', 5 * 3, 'D');
end;


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

{$mode objfpc}{$M+}
uses Crt;

type
  Cell = (Checked, Unchecked);

  Field = array[0..24] of Cell;

  Row = array[0..4] of Cell;

var
  Input: Char;

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
    MainField[i] := Unchecked;
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
      if (CurrentCell = Checked) then
        Write('# # #')
      else
        Write('* * *');
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
  for i := 0 to 4 do
  begin
    start := 5 * i;
    count := 4;
    CurrentCells := SubArray(MainField, start, count);
    DisplayRow(CurrentCells);
  end;
end;

procedure InputHandler(Input: Char);
begin
  case Input of
    'a' : WriteLn('Left');
  end;
end;

var
  MainField: Field;
begin
  CreateField(MainField);
  DisplayField(MainField);
  while true do
  begin
    Input := ReadKey;
    InputHandler(Input);
    if Input = #27 then
      Break;
  end;
end.

{$MODE FPC}
{$MODESWITCH DEFAULTPARAMETERS}
{$MODESWITCH OUT}
{$MODESWITCH RESULT}

{$ASSERTIONS ON}

uses
  dtinyroman in '../dtinyroman.pas';

procedure Test(Value: PtrInt; const Canon: AnsiString);
begin
  Writeln(Value, ' -> ', Romanize(Value));
  Assert(Romanize(Value) = Canon);
end;

begin
  Test(0, '');
  Test(10, 'X');
  Test(1990, 'MCMXC');
  Test(2008, 'MMVIII');
  Test(99, 'XCIX');
  Test(47, 'XLVII');
end.

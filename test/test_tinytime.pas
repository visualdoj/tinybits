{$MODE FPC}
{$MODESWITCH DEFAULTPARAMETERS}
{$MODESWITCH OUT}
{$MODESWITCH RESULT}

uses
  dtinytime in '../dtinytime.pas';

procedure example;
begin
  sleep(0.1234);
end;

var
  t0, t1: Double;
begin
  t0 := now;
  Writeln(bench(@example):0:6, ' s.');
  t1 := now;
  Writeln(t1 - t0 :0:6, ' s.');
end.

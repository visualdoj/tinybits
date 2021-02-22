unit dtinytime;

// Tiny timing utilities. rlyeh, public domain | wtrmrkrlyeh
// ported to pascal by Doj

{$MODE FPC}
{$MODESWITCH DEFAULTPARAMETERS}
{$MODESWITCH OUT}
{$MODESWITCH RESULT}

interface

type
  TProcedure = procedure;

function now: Double;
function bench(fn: TProcedure): Double;
procedure sleep(secs: Double);

implementation

uses
  SysUtils,
  DateUtils;

function now: Double;
var
  Timestamp: TTimeStamp;
begin
  TimeStamp := DateTimeToTimeStamp(SysUtils.Now);
  Exit(TimeStamp.Date * 24*60*60 + TimeStamp.Time / 1000);
end;

function bench(fn: TProcedure): Double;
var
  start: TDateTime;
begin
  start := SysUtils.Now;
  fn;
  Exit(DateUtils.MilliSecondsBetween(start, SysUtils.Now) / 1000);
end;

procedure sleep(secs: Double);
begin
  SysUtils.Sleep(Trunc(secs * 1000));
end;

// procedure example;
// begin
//   sleep(0.1234);
// end;
//
// var
//   t0, t1: Double;
// begin
//   t0 := now;
//   Writeln(bench(@example):0:6, ' s.');
//   t1 := now;
//   Writeln(t1 - t0 :0:6, ' s.');
// end.

end.

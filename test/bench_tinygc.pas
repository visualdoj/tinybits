{$MODE OBJFPC}
{$MODESWITCH DEFAULTPARAMETERS}
{$MODESWITCH NESTEDPROCVARS}
{$MODESWITCH OUT}
{$MODESWITCH RESULT}

uses
  dtinygc in '../dtinygc.pas',
  {$IF Defined(WINDOWS)} windows, {$ENDIF}
  SysUtils,
  DateUtils;

type
TTimer = record {$IFDEF WINDOWS} T: PtrUInt; {$ELSE} D: TDateTimer; {$ENDIF} end;

{$IF Defined(WINDOWS)}
function SystemTimer: PtrUInt;
var
  T, F: LARGE_INTEGER;
begin
  QueryPerformanceFrequency(@F);
  QueryPerformanceCounter(@T);
  Result := Trunc(1000 * T.QuadPart / F.QuadPart);
end;
{$ENDIF}

procedure StartTimer(var Timer: TTimer);
begin
  {$IFDEF WINDOWS} Timer.T:= SystemTimer; {$ELSE} Timer.D:= SysUtils.Now; {$ENDIF}
end;

function GetTimer(const Timer: TTimer): PtrUInt;
begin
  {$IF Defined(WINDOWS)} Exit(SystemTimer - Timer.T);
  {$ELSE}                Exit(DateUtils.MilliSecondsBetween(T.DateTime, SysUtils.Now));
  {$ENDIF}
end;

type
  TProc = procedure is nested;
function benchmark(const beg: TTimer; Proc: TProc): Double;
var
  delta: PtrUInt;
begin
  delta := GetTimer(beg);
  while delta = 0 do begin
    Proc;
    delta := GetTimer(beg);
  end;
  Exit(delta / 1000.0);
end;

const
  FRAMES = 30;
  COUNT = 1000000;

procedure bench;
var
  beg: TTimer;
  baseline, gctime: Double;
  Frame, n: LongInt;
begin
  StartTimer(beg);
  Write(Trunc(FRAMES * COUNT * 2 / 1000000.0), 'M allocs+frees (baseline; regular malloc)');
  for frame := 0 to FRAMES - 1 do begin
    for n := 0 to COUNT - 1 do begin
      FreeMem(GetMem(16));
    end;
  end;
  baseline := GetTimer(beg) / 1000.0;
  Writeln(' ', baseline:5:2, 's');

  StartTimer(beg);
  Write(Trunc(FRAMES * COUNT * 2 / 1000000.0), 'M allocs+frees (gc)');
  for frame := 0 to FRAMES - 1 do begin
    for n := 0 to COUNT - 1 do begin
      gc_malloc(16);
    end;
  end;
  gc_run();
  gctime := GetTimer(beg) / 1000.0;
  Writeln(' ', gctime:5:2, 's');

       if baseline <= gctime then Writeln('gc is x', gctime/baseline:0:2, ' times slower')
  else if baseline  > gctime then Writeln('gc is x', baseline/gctime:0:2, ' times faster!');
end;

procedure main;
var
  StackTop: Pointer;
begin
  gc_init(@StackTop, 256);
  bench;
  gc_stop;
end;

begin
  main;
end.

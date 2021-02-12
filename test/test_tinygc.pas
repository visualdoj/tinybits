{$MODE FPC}
{$MODESWITCH DEFAULTPARAMETERS}
{$MODESWITCH OUT}
{$MODESWITCH RESULT}

uses
  dtinygc in '../dtinygc.pas';

procedure demo;
var
  memory: Pointer;
  s: PAnsiChar;
  x: PAnsiChar;
begin
  memory := gc_malloc(1024);     // will be collected
  s := gc_strdup('hello world'); // will be collected
  x := gc_strdup('Hi');          // will be collected.
  Byte(x[0]) := Ord(x[0]) or 32; // note: indexing is ok; pointer arithmetic is forbidden.
  gc_run();

  Writeln(HexStr(PtrUInt(memory), 2 * SizeOf(PtrUInt)));
  Writeln(s);
  Writeln(x);
  gc_run();
end;

procedure Main;
var
  StackTop: Pointer;
begin
  gc_init(@StackTop, 256);

  demo;

  gc_stop;
end;

begin
  Main;
end.

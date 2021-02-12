unit dtinygc;

// tiny garbage collector (<200 LOCs). Genius code tricks by @orangeduck (see: https://github.com/orangeduck/tgc README)
// - rlyeh, public domain.
// - ported to pascal by Doj

{$MODE FPC}
{$MODESWITCH DEFAULTPARAMETERS}
{$MODESWITCH OUT}
{$MODESWITCH RESULT}

interface

procedure gc_init(argc: Pointer; InitialMBytesReserved: SizeUInt); // pointer to argc (from main), and initial MiB reserved
procedure gc_run;                                     // mark & sweep
procedure gc_stop;                                    // sweep

function gc_malloc(Sz: SizeUInt): Pointer;            // allocator
function gc_strdup(S: PAnsiChar): PAnsiChar;          // util

implementation

function GC_REALLOC(P: Pointer; S: SizeUInt): Pointer;
begin
  Exit(ReAllocMem(P, S));
end;

var
  gc_inuse: array of Pointer; // TODO use some set structure for better perf
  gc_inuse_count: PtrUInt = 0;
  gc_spawned: array of Pointer;
  gc_top: Pointer = nil;
  gc_min: Pointer = nil;
  gc_max: Pointer = Pointer(High(PtrUInt));

function gc_is_inuse(P: Pointer): Boolean; inline;
var
  i: PtrUInt;
begin
  i := 0;
  while i < gc_inuse_count do begin
    if gc_inuse[i] = P then
      Exit(True);
    Inc(i);
  end;
  Exit(False);
end;

procedure gc_add_inuse(P: Pointer); inline;
begin
  if Length(gc_inuse) = 0 then
    SetLength(gc_inuse, 1024);
  if gc_inuse_count >= Length(gc_inuse) then
    SetLength(gc_inuse, 2 * Length(gc_inuse));
  gc_inuse[gc_inuse_count - 1] := P;
  Inc(gc_inuse_count);
end;

procedure gc_clear_inuse; inline;
begin
  SetLength(gc_inuse, 0);
  gc_inuse_count := 0;
end;

procedure gc_mark_stack;
label
  LContinue;
var
  bot, top, last, p, e, ptr: Pointer;
begin
  bot := gc_top;
  top := @bot;
  last := nil;

  if bot < top then begin
    p := bot;
    e := top;
  end else begin
    p := top;
    e := bot;
  end;
  while p < e do begin
    ptr := Pointer(p^);

    if ptr = last   then goto LContinue; // already checked
    if ptr < gc_min then goto LContinue; // out of gc_spawned bounds. also, nullptr check included here
    if ptr > gc_max then goto LContinue; // out of gc_spawned bounds.
{$IF Defined(CPU64)}
    if PtrUInt(ptr) and $7 <> 0 then goto LContinue; // 64-bit unaligned (not a pointer).
{$ENDIF}

    last := ptr;
    gc_add_inuse(last);

  LContinue:
    Inc(p, SizeOf(Pointer));
  end;
end;

procedure gc_mark; // mark reachable stack pointers
var
  env: jmp_buf;
  check: procedure;
begin
  check := @gc_mark_stack;
  SetJmp(env);
  check;
end;
procedure gc_sweep(); // sweep unreachable stack pointers
var
  back, i: SizeInt;
  ptr, swap: Pointer;
  used: Boolean;
  collected: SizeUInt;
begin
  gc_min := Pointer(High(PtrUInt));
  gc_max := nil;

  back := Length(gc_spawned);
  i := 0;
  while i < back do begin
    ptr := gc_spawned[i];

    if ptr > gc_max then gc_max := ptr;
    if ptr < gc_min then gc_min := ptr;

    used := gc_is_inuse(ptr);
    if not used then begin
      GC_REALLOC(gc_spawned[i], 0); //free

      Dec(back);
      swap := gc_spawned[back]; // vector erase
      gc_spawned[back] := gc_spawned[i];
      gc_spawned[i] := swap;
    end else
      Inc(i);
  end;

  collected := Length(gc_spawned) - back;
  //if collected > 0 then
  //  Writeln('gc: ', collected, ' objects collected');

  SetLength(gc_spawned, back);
  gc_clear_inuse;
end;

procedure gc_init(argc: Pointer; InitialMBytesReserved: SizeUInt); // pointer to argc (from main), and initial MiB reserved
begin
  gc_top := argc;
  // gc_spawned.reserve((InitialMBytesReserved > 0) * InitialMBytesReserved * 1024 * 1024 / SizeOf(Pointer));
end;
procedure gc_run;
begin
  gc_mark;
  gc_sweep;
end;
procedure gc_stop;
begin
  gc_sweep;
end;

function gc_malloc(Sz: SizeUInt): Pointer;
begin
  Result := GC_REALLOC(nil, Sz); // malloc
  if Result <> nil then begin
    SetLength(gc_spawned, Length(gc_spawned) + 1);
    gc_spawned[High(gc_spawned)] := Result;
  end;
end;
function gc_strdup(S: PAnsiChar): PAnsiChar;
var
  bytes: SizeInt;
begin
  bytes := StrLen(S) + 1;
  Result := gc_malloc(bytes);
  Move(s^, Result^, bytes);
end;

// ----------------------------------------------------------------------------
//
// procedure demo;
// var
//   memory: Pointer;
//   s: PAnsiChar;
//   x: PAnsiChar;
// begin
//   memory := gc_malloc(1024);     // will be collected
//   s := gc_strdup('hello world'); // will be collected
//   x := gc_strdup('Hi');          // will be collected.
//   Byte(x[0]) := Ord(x[0]) or 32; // note: indexing is ok; pointer arithmetic is forbidden.
//   gc_run();
//
//   Writeln(HexStr(PtrUInt(memory), 2 * SizeOf(PtrUInt)));
//   Writeln(s);
//   Writeln(x);
//   gc_run();
// end;
//
// procedure Main;
// var
//   StackTop: Pointer;
// begin
//   gc_init(@StackTop, 256);
//
//   demo;
//
//   gc_stop;
// end;

// ----------------------------------------------------------------------------
//
// procedure bench;
// const
//   FRAMES = 30;
//   COUNT = 1000000;
// var
//   beg: TDateTimer;
//   baseline, gctime: Double;
//   Frame, n: LongInt;
// begin
//   beg := SysUtils.Now;
//   Write(Trunc(FRAMES * COUNT * 2 / 1000000.0), 'M allocs+frees (baseline; regular malloc)');
//   for frame := 0 to FRAMES - 1 do begin
//     for n := 0 to COUNT - 1 do begin
//       FreeMem(GetMem(16));
//     end;
//   end;
//   baseline := DateUtils.MilliSecondsBetween(Timer, SysUtils.Now) / 1000.0;
//   Writeln(' ', baseline:5:2, 's');
//
//   beg := SysUtils.Now;
//   Write(Trunc(FRAMES * COUNT * 2 / 1000000.0), 'M allocs+frees (gc)');
//   for frame := 0 to FRAMES - 1 do begin
//     for n := 0 to COUNT - 1 do begin
//       gc_malloc(16);
//     end;
//   end;
//   gc_run();
//   gctime := DateUtils.MilliSecondsBetween(Timer, SysUtils.Now) / 1000.0;
//   Writeln(' ', gctime:5:2, 's');
//
//        if baseline <= gctime then Writeln('gc is x', gctime/baseline:0:2, ' times slower')
//   else if baseline  > gctime then Writeln('gc is x', baseline/gctime:0:2, ' times faster!');
// end;

end.

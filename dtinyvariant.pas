unit dtinyvariant;

// Tiny variant class. rlyeh, public domain | wtrmrkrlyeh

{$MODE OBJFPC}
{$MODESWITCH ADVANCEDRECORDS}
{$MODESWITCH DEFAULTPARAMETERS}
{$MODESWITCH OUT}
{$MODESWITCH RESULT}

interface

type
Tvar = record
public type
  TCallback = procedure;
  procedure Init; overload;
  procedure InitInt(value: PtrInt); overload;
  procedure InitDouble(value: Double); overload;
  procedure InitString(const value: AnsiString); overload;
  procedure InitCallback(value: TCallback); overload;
  procedure Init(const other: Tvar); overload;
  procedure Done;
  procedure cleanup;
  procedure Assign(const other: Tvar);
  procedure Call;
  function ToString: AnsiString;
  function IsInt: Boolean; inline;
  function IsDouble: Boolean; inline;
  function IsString: Boolean; inline;
  function IsCallback: Boolean; inline;
{$IF FPC_FULLVERSION > 30101}
  class operator Initialize(var v: Tvar);
  class operator Finalize(var v: Tvar);
  class operator Copy(constref Src: Tvar; var Dst: Tvar);
{$ENDIF}
public case _type: PtrInt of
  0: (i: PtrInt);
  1: (d: {$IF Defined(CPU32)}Single{$ELSE}Double{$ENDIF});
  2: (s: PAnsiString);
  3: (c: TCallback);
end;

operator = (const A, B: Tvar): Boolean;
operator := (const v: Tvar): PtrInt;
operator := (const v: Tvar): Double;
operator := (const v: Tvar): AnsiString;
operator := (const v: Tvar): Tvar.TCallback;

implementation

procedure Tvar.Init;
begin
  _type := 0;
  i := 0;
end;

procedure Tvar.InitInt(value: PtrInt);
begin
  _type := 0;
  i := value;
end;

procedure Tvar.InitDouble(value: Double);
begin
  _type := 1;
  d := value;
end;

procedure Tvar.InitString(const value: AnsiString);
begin
  _type := 2;
  New(s);
  s^ := value;
end;

procedure Tvar.InitCallback(value: TCallback);
begin
  _type := 3;
  c := value;
end;

procedure Tvar.Init(const other: Tvar);
begin
  Init;
  Assign(other);
end;

procedure Tvar.Done;
begin
  cleanup;
end;

procedure Tvar.cleanup;
begin
  if _type = 2 then
    Dispose(s);
  _type := 0;
end;

procedure Tvar.Assign(const other: Tvar);
begin
  if other <> Self then begin
    cleanup();
    _type := other._type;
    case _type of
    0: i := other.i;
    1: d := other.d;
    2: begin
         New(s);
         s^ := other.s^;
       end;
    3: c := other.c
    end;
  end;
end;

procedure Tvar.Call;
begin
  if _type = 3 then
    c();
end;

function Tvar.ToString: AnsiString;
begin
  case _type of
  0: str(i, Result);
  1: str(d, Result);
  2: Exit(s^);
  3: Exit('$' + HexStr(PtrUInt(c), 2 * SizeOf(PtrUInt)));
  else
    Exit('undefined');
  end;
end;

function Tvar.IsInt: Boolean;
begin
  Exit(_type = 0);
end;

function Tvar.IsDouble: Boolean;
begin
  Exit(_Type = 1);
end;

function Tvar.IsString: Boolean;
begin
  Exit(_type = 2)
end;

function Tvar.IsCallback: Boolean;
begin
  Exit(_type = 3)
end;

operator = (const A, B: Tvar): Boolean;
begin
  if A._type = B._type then begin
    case A._type of
    0: Exit(A.i = B.i);
    1: Exit(A.d = B.d);
    2: Exit(A.s^ = B.s^);
    3: Exit(A.c = B.c);
    else
      Exit(False);
    end;
  end else
    Exit(False);
end;

operator := (const v: Tvar): PtrInt;
begin
  Exit(v.i);
end;

operator := (const v: Tvar): Double;
begin
  Exit(v.d);
end;

operator := (const v: Tvar): AnsiString;
begin
  Exit(v.s^);
end;

operator := (const v: Tvar): Tvar.TCallback;
begin
  Exit(v.c);
end;

{$IF FPC_FULLVERSION > 30101}
class operator Tvar.Initialize(var v: Tvar);
begin
  v.Init;
end;

class operator Tvar.Finalize(var v: Tvar);
begin
  v.Done;
end;

class operator Tvar.Copy(constref Src: Tvar; var Dst: Tvar);
begin
  Dst.Assign(Src);
end;
{$ENDIF}

end.

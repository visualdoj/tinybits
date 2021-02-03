unit dtinyendian;

// Tiny endianness. rlyeh, public domain | wtrmrkrlyeh
// Ported to pascal by Doj

{$MODE FPC}
{$MODESWITCH DEFAULTPARAMETERS}
{$MODESWITCH OUT}
{$MODESWITCH RESULT}

interface

function swap16(x: UInt16): UInt16; inline;
function swap32(x: UInt32): UInt32; inline;
function swap64(x: UInt64): UInt64; inline;

{$IF Defined(ENDIAN_BIG)}
function tole16(x: UInt16): UInt16; inline;
function tole32(x: UInt32): UInt32; inline;
function tole64(x: UInt64): UInt64; inline;
type
  tobe16 = UInt16;
  tobe32 = UInt32;
  tobe64 = UInt64;
{$ELSE}
type
  tole16 = UInt16;
  tole32 = UInt32;
  tole64 = UInt64;
function tobe16(x: UInt16): UInt16; inline;
function tobe32(x: UInt32): UInt32; inline;
function tobe64(x: UInt64): UInt64; inline;
{$ENDIF}

implementation

function swap16(x: UInt16): UInt16; inline;
begin
  Exit((x shl 8) or (x shr 8));
end;

function swap32(x: UInt32): UInt32; inline;
begin
  Exit((x shl 24)
    or (x shr 24)
    or ((x and $ff00) shl 8)
    or ((x shr 8) and $ff00));
end;

function swap64(x: UInt64): UInt64; inline;
begin
  Exit((x shl 56)
    or (x shr 56)
    or ((x and $ff00) shl 40)
    or ((x shr 40) and $ff00)
    or ((x and $ff0000) shl 24)
    or ((x shr 24) and $ff0000)
    or ((x and $ff000000) shl 8)
    or ((x shr 8) and $ff000000));
end;

{$IF Defined(ENDIAN_BIG)}
function tole16(x: UInt16): UInt16; inline;
begin
  Exit(swap16(x));
end;

function tole32(x: UInt32): UInt32; inline;
begin
  Exit(swap32(x));
end;

function tole64(x: UInt64): UInt64; inline;
begin
  Exit(swap64(x));
end;

{$ELSE}
function tobe16(x: UInt16): UInt16; inline;
begin
  Exit(swap16(x));
end;

function tobe32(x: UInt32): UInt32; inline;
begin
  Exit(swap32(x));
end;

function tobe64(x: UInt64): UInt64; inline;
begin
  Exit(swap64(x));
end;

{$ENDIF}

// begin
//   Writeln('$', HexStr(swap16($1234), 4));
//   Writeln('$', HexStr(swap32($12345678), 8));
//   Writeln('$', HexStr(swap64($123456789ABCDEF0), 16));
//   Writeln('$', HexStr(tole16($1234), 4));
//   Writeln('$', HexStr(tole32($12345678), 8));
//   Writeln('$', HexStr(tole64($123456789ABCDEF0), 16));
//   Writeln('$', HexStr(tobe16($1234), 4));
//   Writeln('$', HexStr(tobe32($12345678), 8));
//   Writeln('$', HexStr(tobe64($123456789ABCDEF0), 16));
// end.

end.

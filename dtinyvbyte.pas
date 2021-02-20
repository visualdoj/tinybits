unit dtinyvbyte;

// tiny variable byte length encoder/decoder (vbyte)
// - rlyeh, public domain | wtrmrkrlyeh
// - ported to pascal by Doj

{$MODE FPC}
{$MODESWITCH DEFAULTPARAMETERS}
{$MODESWITCH OUT}
{$MODESWITCH RESULT}

interface

const
  VBYTE_MIN_REQ_BYTES = 1;
  VBYTE_MAX_REQ_BYTES = 10;

function vbuencode(Buffer: PByte; Value: UInt64): UInt64;
function vbudecode(Value: PUInt64; Buffer: PByte): UInt64;
function vbiencode(buffer: PUInt8; value: Int64): UInt64;
function vbidecode(value: PInt64; buffer: PUInt8): UInt64;

implementation

function vbuencode(Buffer: PByte; Value: UInt64): UInt64;
var
  Buffer0: PByte;
begin
  // 7-bit packing. MSB terminates stream
  Buffer0 := Buffer;
  repeat
    Buffer^ := Byte($80 or (Value and $7f));
    Inc(Buffer);
    Value := Value shr 7;
  until value <= 0;
  (Buffer - 1)^ := (Buffer - 1)^ xor $80;
  Exit(Buffer - Buffer0);
end;

function vbudecode(Value: PUInt64; Buffer: PByte): UInt64;
var
  Buffer0: PByte;
  _out, j: UInt64;
begin
  // 7-bit unpacking. MSB terminates stream
  Buffer0 := Buffer;
  _out := 0;
  j := 0;
  repeat
    _out := _out or ((UInt64(Buffer^) and $7f) shl j);
    Inc(Buffer);
    Inc(j, 7);
  until (Buffer - 1)^ and $80 = 0;
  Value^ := _out;
  Exit(Buffer - Buffer0);
end;

function vbiencode(buffer: PUInt8; value: Int64): UInt64;
begin
  // convert sign|magnitude to magnitude|sign, encode unsigned
  Exit(vbuencode(buffer, UInt64(SarInt64(value, 63) xor (value shl 1))));
end;
function vbidecode(value: PInt64; buffer: PUInt8): UInt64;
var
  nv: UInt64;
begin
  // decode unsigned
  Result := vbudecode(@nv, buffer);
  // convert magnitude|sign to sign|magnitude
  value^ := Int64((nv shr 1) xor -(nv and 1));
end;

end.

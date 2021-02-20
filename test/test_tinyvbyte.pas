{$MODE FPC}
{$MODESWITCH DEFAULTPARAMETERS}
{$MODESWITCH OUT}
{$MODESWITCH RESULT}

uses
  dtinyvbyte in '../dtinyvbyte.pas';

procedure test_i(number: Int64);
var
  copy: Int64;
  buf: array[0 .. 16 - 1] of Byte;
  written, i: PtrInt;
begin
  written := vbiencode(@buf[0], number);
  vbidecode(@copy, @buf[0]);
  if copy = number then begin
    Write('[ OK ]  Int64: ', number, ' -> ');
  end else
    Write('[FAIL]  Int64: ', number, ' -> ');
  for i := 0 to written - 1 do
    Write(HexStr(buf[i], 2), ',');
  Writeln(' -> ', copy);
end;

procedure test_u(number: UInt64);
var
  copy: UInt64;
  buf: array[0 .. 16 - 1] of Byte;
  written, i: PtrInt;
begin
  written := vbuencode(@buf[0], number);
  vbudecode(@copy, @buf[0]);
  if copy = number then begin
    Write('[ OK ] UInt64: ', number, ' -> ');
  end else
    Write('[FAIL] UInt64: ', number, ' -> ');
  for i := 0 to written - 1 do
    Write(HexStr(buf[i], 2));
  Writeln(' -> ', copy);
end;

begin
  test_i( 0);
  test_i(-1);
  test_i(+1);
  test_i(-2);
  test_i(+2);
  test_i(Low(Int8));
  test_i(High(Int8));
  test_i(Low(Int16));
  test_i(High(Int16));
  test_i(Low(Int32));
  test_i(High(Int32));
  test_i(Low(Int64));
  test_i(High(Int64));

  test_u(0);
  test_u(1);
  test_u(2);
  test_u(3);
  test_u(4);
  test_u(High(UInt8));
  test_u(High(UInt16));
  test_u(High(UInt32));
  test_u(High(UInt64));
end.

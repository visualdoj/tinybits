unit dtinyarc4;

// tinyARC4, ARC4 stream cypher. based on code by Mike Shaffer.
// - rlyeh, public domain ~~ listening to Black Belt - Leeds | wtrmrkrlyeh
// - ported to pascal by Doj

{$MODE FPC}
{$MODESWITCH DEFAULTPARAMETERS}
{$MODESWITCH OUT}
{$MODESWITCH RESULT}

interface

function tinyARC4(const Text, PassKey: AnsiString): AnsiString;

implementation

function tinyARC4(const Text, PassKey: AnsiString): AnsiString;
var
  sbox: array[0 .. 256 - 1] of UInt8;
  Temp: UInt8;
  plen, tlen: SizeInt;
  a, b, i, j, k: SizeInt;
begin
  tlen := Length(Text);
  plen := Length(PassKey);
  if plen <> 0 then begin
    SetLength(Result, tlen);
    for a := 0 to 256 - 1 do
      sbox[a] := a;
    b := 0;
    for a := 0 to 256 - 1 do begin
      b := (b + sbox[a] + Ord(PassKey[(a mod plen) + 1])) mod 256;
      Temp := sbox[a];
      sbox[a] := sbox[b];
      sbox[b] := Temp;
    end;
    i := 0;
    j := 0;
    for a := 0 to tlen - 1 do begin
      i := (i + 1) mod 256;
      j := (j + sbox[i]) mod 256;
      Temp := sbox[i];
      sbox[i] := sbox[j];
      sbox[j] := Temp;
      k := sbox[(sbox[i] + sbox[j]) mod 256];
      Result[a + 1] := AnsiChar(Ord(Text[a + 1]) xor k);
    end;
  end else
    Exit(Text);
end;

//
// var
//   Encrypted, Decrypted: AnsiString;
//
// begin
//   // sample
//   Encrypted := tinyARC4('Hello world.', 'my-password');
//   Decrypted := tinyARC4(Encrypted, 'my-password');
//
//   Writeln('ARC4 Encrypted text: ', Encrypted);
//   Writeln('ARC4 Decrypted text: ', Decrypted);
//
//   // tests
//   Assert(tinyARC4('hello world', 'my key') <> 'hello world');
//   assert(tinyARC4(tinyARC4('hello world', 'my key'), 'my key') = 'hello world');
// end.
//

end.

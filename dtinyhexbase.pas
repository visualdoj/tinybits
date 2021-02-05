unit dtinyhexbase;

// hexBASE
// Very simple binary to ascii encoding. 0 to 2+100% bytes overhead (worst case)
//
// Specification:
// if char in [32..126] range then print "%c", char ('~' escaped as "~~"),
// else print "~%02x[...]~", for all remaining bytes.
//
// - rlyeh, public domain.
// - poarted to pascal by Doj

{$MODE FPC}
{$MODESWITCH DEFAULTPARAMETERS}
{$MODESWITCH OUT}
{$MODESWITCH RESULT}

interface

procedure hexbasenl(var f: TextFile; ptr: PAnsiChar; len: SizeInt); inline;
procedure hexbase(var F: TextFile; ptr: PAnsiChar; len: SizeInt); inline;

implementation

procedure hexbasenl(var f: TextFile; ptr: PAnsiChar; len: SizeInt); inline;
var
  C: AnsiChar;
begin
  while len > 0 do begin
    C := PAnsiChar(ptr)^;
    if C in [#32..#126] then begin
      Write(F, C);
    end else if C = #126 then begin
      Write(F, '~~');
    end else begin
      Write(F, '~');
      while len > 0 do begin
        Write(F, HexStr(PByte(ptr)^, 2));
        Inc(ptr);
        Dec(len);
      end;
      Write(F, '~');
    end;
    Inc(ptr);
    Dec(len);
  end;
end;

procedure hexbase(var F: TextFile; ptr: PAnsiChar; len: SizeInt); inline;
begin
  hexbasenl(F, ptr, len);
  Writeln(F);
end;

// begin
//   hexbase(output, 'hello world', strlen('hello world'));
//   // --> hello world
//   hexbase(output, 'hello world \x1\x2\x3\xff', strlen('hello world') + 5);
//   // --> hello world ~010203ff~
//   hexbase(output, 'hello~world', strlen('hello~world'));
//   // --> hello~~world
//   hexbase(output, '\xa1\2\3', 3 );
//   // --> ~a10203~
//   hexbase(output, '\1\2\3hello world', 3 + strlen('hello world'));
//   // --> ~01020368656c6c6f20776f726c64~
//   hexbase(output, '\1\2\3hello world\xf0', 4 + strlen('hello world') );
//   // --> ~01020368656c6c6f20776f726c64f0~
// end.

end.

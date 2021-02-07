unit dtinyhexdump;

// Tiny hexdump viewer. rlyeh, public domain | wtrmrkrlyeh
// Ported to pascal by Doj

{$MODE FPC}
{$MODESWITCH DEFAULTPARAMETERS}
{$MODESWITCH OUT}
{$MODESWITCH RESULT}

interface

procedure hexdump(var F: TextFile; ptr: Pointer; Len, Width: SizeInt);

implementation

procedure hexdump(var F: TextFile; ptr: Pointer; Len, Width: SizeInt);
var
  jt, it: LongInt;
begin
  jt := 0;
  while jt < Len do begin
    Write(F, '; ', jt:5, ' ');
    for it := jt to Len - 1 do begin
      if it >= jt + Width then
        break;
      Write(F, HexStr(PByte(ptr)[it], 2), ' ');
      if 1 + it < len then begin
        if (1 + it) mod width = 0 then
          Writeln(' ');
      end else
        Writeln('...');
    end;
    Write(F, '; ', jt:5, ' ');
    for it := jt to len - 1 do begin
      if it >= jt + Width then
        break;
      if PByte(ptr)[it] in [32 .. 127] then begin
        Write(' ', PAnsiChar(ptr)[it], ' ');
      end else
        Write(' . ');
      if 1 + it < len then begin
        if (1 + it) mod width = 0 then
          Writeln(' ');
      end else
        Writeln('...');
    end;
    Inc(jt, width);
  end;
end;

// const
//   sample: PAnsiChar = {$I %FILE%} + '/' + {$I %LINE%} + '/' + {$I %DATE%};
// begin
//   hexdump(output, sample, strlen(sample), 16);
// end.

end.

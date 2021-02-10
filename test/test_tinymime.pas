uses
  dtinymime in '../dtinymime.pas';

var
  F: File;
  Buf: array[0 .. 512 - 1] of AnsiChar;
  Len: SizeUInt;
begin
  if ParamCount > 0 then begin
    Assign(F, ParamStr(1));
    Reset(F, 1);
    BlockRead(F, Buf[0], 512, Len);
    Writeln(tinymime(@Buf[0], Len));
    Close(F);
  end else
    Writeln(stderr, 'Usage: test_tinymime <filename>');
end.

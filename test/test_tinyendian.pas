{$MODE FPC}
{$MODESWITCH DEFAULTPARAMETERS}
{$MODESWITCH OUT}
{$MODESWITCH RESULT}

uses
  dtinyendian in '../dtinyendian.pas';

begin
  Writeln('$', HexStr(swap16($1234), 4));
  Writeln('$', HexStr(swap32($12345678), 8));
  Writeln('$', HexStr(swap64($123456789ABCDEF0), 16));
  Writeln('$', HexStr(tole16($1234), 4));
  Writeln('$', HexStr(tole32($12345678), 8));
  Writeln('$', HexStr(tole64($123456789ABCDEF0), 16));
  Writeln('$', HexStr(tobe16($1234), 4));
  Writeln('$', HexStr(tobe32($12345678), 8));
  Writeln('$', HexStr(tobe64($123456789ABCDEF0), 16));
end.

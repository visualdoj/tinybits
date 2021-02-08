unit dtinyhuman;

// tiny de/humanized numbers. based on freebsd implementation.
// - rlyeh, public domain | wtrmrkrlyeh
// - ported to pascal by Doj

{$MODE FPC}
{$MODESWITCH DEFAULTPARAMETERS}
{$MODESWITCH OUT}
{$MODESWITCH RESULT}

interface

function humanize(num: UInt64; suffix: PAnsiChar = ' '): AnsiString;
function dehumanize(const str: AnsiString): UInt64;

implementation

function humanize(num: UInt64; suffix: PAnsiChar = ' '): AnsiString;
const
  prefixes = ' KMGTPE';
var
  i, d: UInt64;
  prefixp: PAnsiChar;
  i_str, d_str: ShortString;
begin
  prefixp := @(prefixes[1]);
  i := num;
  d := 0;
  while (i > 1024) and (prefixp^ <> #0) do begin
    Inc(prefixp);
    d := (i mod 1024) div 10;
    i := i div 1024;
  end;
  if d > 0 then begin
    str(i, i_str);
    str(d, d_str);
    Exit(i_str + '.' + d_str + suffix + prefixp^);
  end else begin
    str(i, i_str);
    Exit(i_str + suffix + prefixp^);
  end;
end;

function dehumanize(const str: AnsiString): UInt64;
var
  sz, mul: SizeInt;
  num: Double;
begin
  sz := 1;
  mul := 0;
  while (sz <= Length(str)) and (str[sz] in ['0'..'9','.','e','E']) do
    Inc(sz);
  val(Copy(str, 1, sz - 1), num);
  while (sz <= Length(str)) and (str[sz] = ' ') do
    Inc(sz);
  case str[sz] of
    'B', 'b': mul := 0;
    'K', 'k': mul := 1;
    'M', 'm': mul := 2;
    'G', 'g': mul := 3;
    'T', 't': mul := 4;
    'P', 'p': mul := 5;
    'E', 'e': mul := 6; // may overflow
  else
    mul := 0;
  end;
  while mul > 0 do begin
    if num * 1024 < num then begin
      Exit(0);
    end else
      num := num * 1024;
    Dec(mul);
  end;
  Exit(Round(num));
end;

// begin
//   Writeln({$I %LINE%}, ' ', humanize(1238), 'm');
//   Writeln({$I %LINE%}, ' ', humanize(123823), 'l');
//   Writeln({$I %LINE%}, ' ', humanize(123828328), 'bytes');
//   Writeln('---');
//
//   Writeln({$I %LINE%}, ' ', dehumanize('118 km'));
//   Writeln({$I %LINE%}, ' ', dehumanize('118.9M'));
//   Writeln({$I %LINE%}, ' ', dehumanize('118M'));
//   Writeln({$I %LINE%}, ' ', dehumanize('118b'));
//   Writeln({$I %LINE%}, ' ', dehumanize('118k'));
//   Writeln({$I %LINE%}, ' ', dehumanize('118mb'));
//   Writeln({$I %LINE%}, ' ', dehumanize('118gb'));
//   Writeln({$I %LINE%}, ' ', dehumanize('118tb'));
//   Writeln({$I %LINE%}, ' ', dehumanize('118pb'));
// end.

end.

unit dtinyroman;

// Tiny integer to roman numerals converter (roughly tested).
// - rlyeh, public domain | wtrmrkrlyeh
// - pascal port by Doj

{$MODE FPC}
{$MODESWITCH DEFAULTPARAMETERS}
{$MODESWITCH OUT}
{$MODESWITCH RESULT}

interface

function Romanize(i: PtrInt): AnsiString;

implementation

const
table: array[0 .. 31 - 1] of AnsiString = (
  'I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII', 'IX',
  'X', 'XX', 'XXX', 'XL', 'L', 'LX', 'LXX', 'LXXX', 'XC',
  'C', 'CC', 'CCC', 'CD', 'D', 'DC', 'DCC', 'DCCC', 'CM',
  'M', 'MM', 'MMM', 'MMMM'
);

function Romanize(i: PtrInt): AnsiString;
var
  base, _mod: PtrInt;
begin
  Result := '';
  base := 0;
  while i > 0 do begin
    _mod := i mod 10;
    if _mod > 0 then
      Result := table[(_mod - 1) + base * 9] + Result;
    Inc(base);
    i := i div 10;
  end;
end;

// begin
//   Assert(Romanize(0) = '' );
//   Assert(Romanize(10) = 'X' );
//   Assert(Romanize(1990) = 'MCMXC' );
//   Assert(Romanize(2008) = 'MMVIII' );
//   Assert(Romanize(99) = 'XCIX' );
//   Assert(Romanize(47) = 'XLVII' );
// end.

end.

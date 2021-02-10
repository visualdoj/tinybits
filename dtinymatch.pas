unit dtinymatch;

// tiny wildcard/pattern matching. Based on anonymous souce code (Rob Pike's ?).
// - rlyeh. public domain | wtrmrkrlyeh
// - pascal port by Doj

{$MODE FPC}
{$MODESWITCH DEFAULTPARAMETERS}
{$MODESWITCH OUT}
{$MODESWITCH RESULT}

interface

function Match(Pattern, S: PAnsiChar): Boolean;

implementation

function Match(Pattern, S: PAnsiChar): Boolean;
begin
  if Pattern^ = #0 then
    Exit(S^ = #0);
  if Pattern^ = '*' then
    Exit(Match(Pattern + 1, S) or ((S^ <> #0) and Match(Pattern, S + 1)));
  if Pattern^ = '?' then
    Exit((S^ <> #0) and (S^ <> '.') and Match(Pattern + 1, S + 1));
  Exit((S^ = Pattern^) and Match(Pattern + 1, S + 1));
end;

// procedure Example(Pattern, S: PAnsiChar);
// begin
//   if Match(Pattern, S) then begin
//     Writeln(Pattern, ' found in ', S);
//   end else
//     Writeln(Pattern, ' not found in ', S);
// end;
//
// begin
//   Example('abc', 'abc');
//   Example('abc*', 'abcd');
//   Example('*bc', 'abc');
//   Example('*bc*', 'abc');
//   Example('*b?d*', 'abcdef');
// end.

end.

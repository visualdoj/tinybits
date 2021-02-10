uses
  dtinymatch in '../dtinymatch.pas';

procedure Example(Pattern, S: PAnsiChar);
begin
  if Match(Pattern, S) then begin
    Writeln(Pattern, ' found in ', S);
  end else
    Writeln(Pattern, ' not found in ', S);
end;

begin
  Example('abc', 'abc');
  Example('abc*', 'abcd');
  Example('*bc', 'abc');
  Example('*bc*', 'abc');
  Example('*b?d*', 'abcdef');
  Example('abcd', 'abc');
  Example('abc*', 'abdd');
  Example('*bc', 'dbc');
  Example('*bc*', 'cb');
  Example('*b?d*', 'baad');
end.

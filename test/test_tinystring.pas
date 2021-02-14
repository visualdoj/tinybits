{$MODE FPC}
{$MODESWITCH DEFAULTPARAMETERS}
{$MODESWITCH OUT}
{$MODESWITCH RESULT}

uses
  dtinystring in '../dtinystring.pas';

var
  Parts: TArrayOfStrings;
  Part: AnsiString;

begin
  Parts := Tokenize('a/b/c/\d\e,f,g,', '/\,');
  for Part in Parts do
    Write('"', Part, '" ');
  Writeln;
  // "a" "b" "c" "d" "e" "f" "g"

  Parts := Split('a/b/c/\d\e,f,g,', '/\,');
  for Part in Parts do
    Write('"', Part, '" ');
  Writeln;
  // "a" "/" "b" "/" "c" "/" "\" "d" "\" "e" "," "f" "," "g" ","

  Writeln('"', LeftOf('beginning', 'in the beginning'), '"'); // "in the "
  Writeln('"', RightOf('in the ', 'in the beginning'), '"'); // "beginning"
  Writeln('"', ReplaceOne('0cad0', '0', 'abra'), '"'); // "abracad0"
  Writeln('"', ReplaceAll('0cad0', '0', 'abra'), '"'); // "abracadabra"
end.

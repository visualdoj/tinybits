{$MODE FPC}
{$MODESWITCH DEFAULTPARAMETERS}
{$MODESWITCH OUT}
{$MODESWITCH RESULT}

{$ASSERTIONS ON}

uses
  dtinyarc4 in '../dtinyarc4.pas';

var
  Encrypted, Decrypted: AnsiString;

function Escaped(const BinaryString: AnsiString): AnsiString;
var
  C: AnsiChar;
begin
  Result := '';
  for C in BinaryString do begin
    if C in ['a'..'z','A'..'Z','0'..'9',' ','.','-','_'] then begin
      Result := Result + C;
    end else
      Result := Result + '$' + HexStr(Ord(C), 2);
  end;
end;

begin
  // sample
  Encrypted := tinyARC4('Hello world.', 'my-password');
  Decrypted := tinyARC4(Encrypted, 'my-password');

  Writeln('ARC4 Encrypted text: ', Escaped(Encrypted));
  Writeln('ARC4 Decrypted text: ', Escaped(Decrypted));

  // tests
  Assert(tinyARC4('hello world', 'my key') <> 'hello world');
  Assert(tinyARC4(tinyARC4('hello world', 'my key'), 'my key') = 'hello world');
end.

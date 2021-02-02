{$MODE FPC}
{$MODESWITCH DEFAULTPARAMETERS}
{$MODESWITCH OUT}
{$MODESWITCH RESULT}

uses
  dtinydixy in '../dtinydixy';

function puts2(key: PAnsiChar; val: PAnsiChar): Boolean;
begin
  Writeln(key, ':''', val, '');
  Exit(False);
end;

const
Sample =
  '# Dixy 1.0' + #13 +
  '' + #13 +
  'name: Taylor Swift' + #13 +
  'age: 27' + #13 +
  'phones:' + #13 +
  '    0: 555-SWIFT' + #13 +
  '    1: 900-SWIFT' + #13 +
  '    2: 800-TAYLOR' + #13 +
  'body:' + #13 +
  '    height: 6 ft' + #13 +
  '    weight: 120 lbs' + #13 +
  'pets:' + #13 +
  '    0:' + #13 +
  '        name: Fido' + #13 +
  '        breed: chihuahua' + #13 +
  '    1:' + #13 +
  '        name: Tinkerbell' + #13 +
  '        breed: bulldog' + #13;

begin
  Writeln(tinydixy(Sample, @puts2), ' keys found');
end.

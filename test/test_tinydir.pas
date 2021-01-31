{$MODE FPC}
{$MODESWITCH DEFAULTPARAMETERS}
{$MODESWITCH OUT}
{$MODESWITCH RESULT}

uses
  dtinydir in '../dtinydir.pas';

procedure Callback(Name: PAnsiChar; IsDir: Boolean);
begin
  if IsDir then
    Write('<dir> ');
  Writeln(Name);
end;

procedure CallbackRecursive(Name: PAnsiChar; IsDir: Boolean);
begin
  Callback(Name, IsDir);
  if IsDir then
    tinydir(Name, @CallbackRecursive);
end;

begin
  tinydir('./', @CallbackRecursive);
end.

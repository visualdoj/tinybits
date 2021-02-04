{$MODE FPC}
{$MODESWITCH DEFAULTPARAMETERS}
{$MODESWITCH OUT}
{$MODESWITCH RESULT}

uses
  dtinyerror in '../dtinyerror.pas';

function try_open_missing_file(var F: File; FileName: PAnsiChar): Boolean;
begin
  Error(0);
  Assign(F, FileName);
{$PUSH}{$I-}
  Reset(F, 1);
{$POP}
  if IOResult <> 0 then begin
    Error(404, 'Cannot open file');
    Exit(False);
  end;
end;

var
  F: File;
begin
  try_open_missing_file(F, 'missing.txt');

  if ErrorCode = 0 then begin
    Writeln('ok');
  end;
  if ErrorCode <> 0 then begin
    Writeln(ErrorCode);
  end;
  Writeln(ErrorText);
end.

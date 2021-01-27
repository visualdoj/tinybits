{$MODE FPC}
{$MODESWITCH DEFAULTPARAMETERS}
{$MODESWITCH OUT}
{$MODESWITCH RESULT}

{$ASSERTIONS ON}

uses
  dtinyatoi in '../dtinyatoi.pas';

begin
  Assert(1230  = tinyatoi('01230'));
  Assert(-1230 = tinyatoi('-01230'));
  Assert(1230  = tinyatoi('--01230'));
  Assert(-1230 = tinyatoi('---01230'));
end.

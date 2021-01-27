unit dtinyatoi;

// Tiny atoi() replacement. rlyeh, public domain | wtrmrkrlyeh
// Ported to pascal by Doj

{$MODE FPC}
{$MODESWITCH DEFAULTPARAMETERS}
{$MODESWITCH OUT}
{$MODESWITCH RESULT}

interface

function tinyatoi(S: PAnsiChar): PtrInt;

implementation

function tinyatoi(S: PAnsiChar): PtrInt;
var
  v, n: PtrInt;
begin
  v := 0;
  n := 1;
  if s <> nil then begin
    while s^ = '-' do begin
      n := - n;
      Inc(s);
    end;
    while (s^ >= '0') and (s^ <= '9') do begin
      v := (10 * v) + (Ord(s^) - Ord('0'));
      Inc(s);
    end;
  end;
  Exit(n * v);
end;

//
// begin
//   Assert(1230  = tinyatoi('01230'));
//   Assert(-1230 = tinyatoi('-01230'));
//   Assert(1230  = tinyatoi('--01230'));
//   Assert(-1230 = tinyatoi('---01230'));
// end;
//

end.

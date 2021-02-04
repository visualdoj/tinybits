unit dtinyerror;

// simple error handling api: error(N, "optional description"), errorcode, errortext
// - rlyeh, public domain.
// - ported to pascal by Doj

{$MODE FPC}
{$MODESWITCH DEFAULTPARAMETERS}
{$MODESWITCH OUT}
{$MODESWITCH RESULT}

interface

var
  ErrorText: AnsiString;

procedure Error(rc: PtrUInt; Msg: PAnsiChar = '');
function ErrorCode: PtrUInt;

implementation

procedure Error(rc: PtrUInt; Msg: PAnsiChar = '');
var
  S: ShortString;
begin
  if rc = 0 then begin
    ErrorText := 'No error 0';
  end else begin
    Str(rc, S);
    ErrorText := 'Error -- ' + S + ': ' + Msg;
  end;
end;

function ErrorCode: PtrUInt;
var
  I: LongInt;
  S: ShortString;
begin
  S := '';
  I := 10;
  while ErrorText[I] in ['0'..'9'] do begin
    S := S + ErrorText[I];
    Inc(I);
  end;
  Val(S, Result);
end;

// function try_open_missing_file(var F: File; FileName: PAnsiChar): Boolean;
// begin
//   Error(0);
//   Assign(F, FileName);
// {$PUSH}{$I-}
//   Reset(F, 1);
// {$POP}
//   if IOResult <> 0 then begin
//     Error(404, 'Cannot open file');
//     Exit(False);
//   end;
// end;
//
// var
//   F: File;
// begin
//   try_open_missing_file(F, 'missing.txt');
//
//   if ErrorCode = 0 then begin
//     Writeln('ok');
//   end;
//   if ErrorCode <> 0 then begin
//     Writeln(ErrorCode);
//   end;
//   Writeln(ErrorText);
// end.

end.

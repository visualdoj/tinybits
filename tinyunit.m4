// Tiny unittest suite. rlyeh, public domain | wtrmrkrlyeh
// Ported to pascal by Doj

//
// Example:
// ```
//
//    // {$I tinyunit.m4} // fallback
//    include(tinyunit.m4)
// 
//    begin
//      // orphan test
//      test(1<2);
//      // grouped tests
//      suite('grouped tests 1/1');
//      test(1<2);
//      test(1<2);
// 
//      suite('grouped tests 1/2');
//      test(1<2);
//      test(1<2);
// 
//      summary;
//    end.
//
//  '''
//
//  Usage:
//
//      m4 program.pas > generated.pas
//      fpc generated.pas
//

{$IF True}
const
  M4_ENABLED_CONST = False;
{$ELSE}
changequote(`<',`>')
changequote(<`>,<&>)
define(`test&,`CurrentFileName := '__file__'; CurrentLine := __line__; writeln_test($*, '$*')&)
define(`M4_ENABLED_CONST&,`True&)
{$ENDIF}

{$IF M4_ENABLED_CONST}
{$DEFINE M4_ENABLED}
{$ENDIF}

var
  errno, tst, err: PtrUInt;
  ok: Boolean;
  CurrentFileName: AnsiString;
  CurrentLine: PtrInt;

{$MACRO ON}
{$DEFINE suite := Write('------ '); Writeln}

procedure summary;
begin
  suite('summary');
  if err > 0 then begin
    Write('[FAIL] ');
  end else
    Write('[ OK ] ');
  Writeln(tst, ' tests = ', tst - err, ' passed + ', err, ' errors');
  errno := 0;
end;

procedure writeln_test(ok: Boolean; const Condition: AnsiString);
begin
  Inc(tst);
  if not ok then
    Inc(err);
  if ok then begin
    Write('[ OK ] ');
  end else
    Write('[FAIL] ');
  Writeln(CurrentFileName, ':', CurrentLine, '   ', Condition);
  // printf('L%d %s (%s)\n',ok?" OK ":"FAIL",__LINE__,#__VA_ARGS__,strerror(errno))
  errno := 0;
end;

{$IF not Defined(M4_ENABLED)}
procedure test(ok: Boolean);
begin
  CurrentFileName := '';
  CurrentLine := 0;
  writeln_test(ok, '');
end;
{$ENDIF}

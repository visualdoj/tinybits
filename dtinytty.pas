unit dtinytty;

// Tiny terminal utilities. rlyeh, public domain | wtrmrkrlyeh
// Ported to pascal by Doj

{$CODEPAGE UTF8}
{$MODE FPC}
{$MODESWITCH DEFAULTPARAMETERS}
{$MODESWITCH OUT}
{$MODESWITCH RESULT}

interface

// A few unicode characters and ANSI colors
const
  tick  : PAnsiChar = {$IF Defined(WINDOWS)} '[v]' {$ELSE} #$E2#$9C#$93 {$ENDIF};
  cross : PAnsiChar = {$IF Defined(WINDOWS)} '[x]' {$ELSE} #$E2#$9E#$94 {$ENDIF};
  red     = {$IF Defined(WINDOWS)} ''    {$ELSE} #27'[1;31m' {$ENDIF};
  green   = {$IF Defined(WINDOWS)} ''    {$ELSE} #27'[1;32m' {$ENDIF};
  blue    = {$IF Defined(WINDOWS)} ''    {$ELSE} #27'[1;34m' {$ENDIF};
  yellow  = {$IF Defined(WINDOWS)} ''    {$ELSE} #27'[1;33m' {$ENDIF};
  magenta = {$IF Defined(WINDOWS)} ''    {$ELSE} #27'[1;35m' {$ENDIF};
  cyan    = {$IF Defined(WINDOWS)} ''    {$ELSE} #27'[1;36m' {$ENDIF};
  _end    = {$IF Defined(WINDOWS)} ''    {$ELSE} #27'[1;0m'  {$ENDIF};

procedure tty256(R, G, B: Byte);
// 256-color terminal

procedure tty(const Txt: AnsiString);
// terminal writer w/ console width clamping

implementation

{$IF Defined(UNIX)}
uses
  termio;
{$ELSEIF Defined(WINDOWS)}
uses
  windows;
{$ENDIF}

procedure tty256(R, G, B: Byte);
begin
{$IF not Defined(WINDOWS)}
  Write(#27'[38;5;', (R div 51) * 36 + (g div 51) * 6 + (b div 51) + 16, 'm');
{$ENDIF}
end;

procedure tty(const Txt: AnsiString);
{$IF Defined(WINDOWS)}
var
  c: CONSOLE_SCREEN_BUFFER_INFO;
  len: SizeUInt;
  w: PtrInt;
{$ENDIF}
begin
{$IF Defined(WINDOWS)}
  if GetConsoleScreenBufferInfo(GetStdHandle(STD_OUTPUT_HANDLE), @c) then begin
    len := Length(Txt);
    w := c.srWindow.Right - c.srWindow.Left - c.dwCursorPosition.X;
    if len > w then begin
      Writeln(Copy(Txt, 1, w - 3), '...');
    end else
      Writeln(Txt);
    Exit;
  end;
{$ENDIF}
  Writeln(Txt);
end;

// begin
//   Writeln('No color');
//   // usage:
//   Writeln(green, tick,  yellow, ' passed', _end);
//   Writeln(red,   cross, yellow, ' failed', _end);
//   // or:
//   tty256(255, 192, 0);
//   Writeln('256 colors', _end);
//   // also:
//   tty('DECREASE WINDOW WIDTH AND RUN THE APP AGAIN! DECREASE WINDOW WIDTH AND RUN THE APP AGAIN! DECREASE WINDOW WIDTH AND RUN THE APP AGAIN! DECREASE WINDOW WIDTH AND RUN THE APP AGAIN!');
//   // more tests:
//   tty('hey');
//   Writeln('[test] ');
//   tty('DECREASE WINDOW WIDTH AND RUN THE APP AGAIN! DECREASE WINDOW WIDTH AND RUN THE APP AGAIN! DECREASE WINDOW WIDTH AND RUN THE APP AGAIN! DECREASE WINDOW WIDTH AND RUN THE APP AGAIN!');
// end.

end.

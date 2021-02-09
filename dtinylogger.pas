unit dtinylogger;

// Tiny session logger. rlyeh, public domain | wtrmrkrlyeh
// Pascal port by Doj

{$MODE OBJFPC}
{$MODESWITCH ADVANCEDRECORDS}
{$MODESWITCH DEFAULTPARAMETERS}
{$MODESWITCH OUT}
{$MODESWITCH RESULT}

interface

type
TLogger = record
  procedure Init;
  procedure Done;
private
  Buffer: array[0 .. 16 * 1024 - 1] of Byte;
{$IF FPC_FULLVERSION > 30101}
  Initialized: Boolean;
  class operator Initialize(var Logger: TLogger);
  class operator Finalize(var Logger: TLogger);
{$ENDIF}
end;

implementation

procedure TLogger.Init;
begin
{$IF FPC_FULLVERSION > 30101}
  if Initialized then
    Exit;
  Initialized := True;
{$ENDIF}

{$IF Defined(SHIPPING)}
  Close(output);
{$ELSE}
{$IF Defined(PSVITA)}
  Assign(output, 'host0://log_vita.txt');
{$ELSEIF Defined(PS3)}
  Assign(output, '/app_home/log_ps3.txt');
{$ELSEIF Defined(PS4)}
  Assign(output, '/hostapp/log_ps4.txt');
{$ELSE}
  Assign(output, 'log_desktop.txt');
{$ENDIF}
  {$PUSH}{$I-} Append(output); {$POP}
  if IOResult <> 0 then
    ReWrite(output);
  // Flush automatically every 16 KiB from now
  SetTextBuf(output, Buffer[0], Length(Buffer));
  // Header
  Writeln(';; New session');
  Flush(output);
{$ENDIF}
end;

procedure TLogger.Done;
begin
{$IF FPC_FULLVERSION > 30101}
  if not Initialized then
    Exit;
  Initialized := False;
{$ENDIF}

{$IF not Defined(SHIPPING)}
  Flush(output);
{$ENDIF}
end;

{$IF FPC_FULLVERSION > 30101}
class operator TLogger.Initialize(var Logger: TLogger);
begin
  Logger.Initialized := False;
  Logger.Init;
end;

class operator TLogger.Finalize(var Logger: TLogger);
begin
  Logger.Done;
end;
{$ENDIF}

//
// var
//   resident: TLogger;
// begin
//   resident.Init;
//   Writeln("hello world");
//   resident.Done
// end;
//

end.

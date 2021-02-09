{$MODE FPC}
{$MODESWITCH DEFAULTPARAMETERS}
{$MODESWITCH OUT}
{$MODESWITCH RESULT}

uses
  dtinylogger in '../dtinylogger.pas';

var
  Logger: TLogger;

begin
  Logger.Init;
  Writeln('hello world');
  Logger.Done;
end.

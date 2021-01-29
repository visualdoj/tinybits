{$MODE FPC}
{$MODESWITCH DEFAULTPARAMETERS}
{$MODESWITCH OUT}
{$MODESWITCH RESULT}

{$I ../dtinydebug.inc}

procedure strcat(var buf: PAnsiChar; s: PAnsiChar);
begin
  Move(s^, buf^, StrLen(s));
  Inc(buf, StrLen(s));
end;

var
  collected_flags: array[0 .. 128 - 1] of AnsiChar;
  buf: PAnsiChar;
begin
  DBG      Writeln('shown in debug builds');
  REL      Writeln('shown in release builds');
  DEV      Writeln('shown in internal development builds');
  DEV OPT0 Writeln('shown in internal development builds, with no optimization level');
  PUB OPT3 Writeln('shown in public builds with optimization level >= 3');
  SHIPPING Writeln('shown in final builds');

  FillChar(collected_flags, Length(collected_flags), 0);
  buf := @collected_flags[0];

  DBG  strcat(buf, 'DEBUG,');
  REL  strcat(buf, 'RELEASE,');

  DBG0 strcat(buf, 'DEBUG >= 0,');
  DBG1 strcat(buf, 'DEBUG >= 1,');
  DBG2 strcat(buf, 'DEBUG >= 2,');
  DBG3 strcat(buf, 'DEBUG >= 3,');
  DBG4 strcat(buf, 'DEBUG >= 4,');

  OPT0 strcat(buf, 'OPTIM = 0,');
  OPT1 strcat(buf, 'OPTIM = 1,');
  OPT2 strcat(buf, 'OPTIM = 2,');
  OPT3 strcat(buf, 'OPTIM = 3,');
  OPT4 strcat(buf, 'OPTIM = 4,');

  OPT0 DBG strcat(buf, 'DEVELDBG (OPT0 && DBG && DEV),');
  OPT2 DBG strcat(buf, 'DEVELOPT (OPT2 && DBG && DEV),');
  OPT2 REL strcat(buf, 'OPTIMSYM (OPT2 && REL && DEV),');
  SHIPPING strcat(buf, 'SHIPPING (OPT3 && REL && PUB),');

  Writeln(PAnsiChar(@collected_flags[0]));
end.

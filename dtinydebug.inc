// Tiny debug macros
// - rlyeh, public domain | wtrmrkrlyeh
// - ported to pascal by Doj
//
// Build cube of 3 dimensions, 5 levels each:
//
//     . PUBLIC AXIS: 0 STUDIO/INTERNAL, 1 QA, 2 USER-TESTING, 3 SHOWCASE, 4 SHIPPING/MASTER
//    /
//   /
//  +--------> DEBUG AXIS: 0 FATAL, 1 ERROR, 2 WARN, 3 INFO, 4 VERBOSE
//  |
//  |
//  |
//  V OPTIMIZATION AXIS: 0 DEBUG, 1 DEBUGOPT, 2 OPTSYM, 3 OPTMAX, 4 STRIPPED
//
// Example: a RETAIL build might be PUB>=3 DBG<=1 OPT>=3

{$MACRO ON}

{$warn 6018 off} // warning: unreachable code

{$IF Defined(DBGLVL_0) and not Declared(DBGLVL)}const DBGLVL = 0;{$ENDIF}
{$IF Defined(DBGLVL_1) and not Declared(DBGLVL)}const DBGLVL = 1;{$ENDIF}
{$IF Defined(DBGLVL_2) and not Declared(DBGLVL)}const DBGLVL = 2;{$ENDIF}
{$IF Defined(DBGLVL_3) and not Declared(DBGLVL)}const DBGLVL = 3;{$ENDIF}
{$IF Defined(DBGLVL_4) and not Declared(DBGLVL)}const DBGLVL = 4;{$ENDIF}
{$IF not Declared(DBGLVL)}const DBGLVL = 0;{$ENDIF}

{$IF Defined(OPTLVL_0) and not Declared(OPTLVL)}const OPTLVL = 0;{$ENDIF}
{$IF Defined(OPTLVL_1) and not Declared(OPTLVL)}const OPTLVL = 1;{$ENDIF}
{$IF Defined(OPTLVL_2) and not Declared(OPTLVL)}const OPTLVL = 2;{$ENDIF}
{$IF Defined(OPTLVL_3) and not Declared(OPTLVL)}const OPTLVL = 3;{$ENDIF}
{$IF Defined(OPTLVL_4) and not Declared(OPTLVL)}const OPTLVL = 4;{$ENDIF}
{$IF not Declared(OPTLVL)}const OPTLVL = 0;{$ENDIF}

{$IF Defined(PUBLVL_0) and not Declared(PUBLVL)}const PUBLVL = 0;{$ENDIF}
{$IF Defined(PUBLVL_1) and not Declared(PUBLVL)}const PUBLVL = 1;{$ENDIF}
{$IF Defined(PUBLVL_2) and not Declared(PUBLVL)}const PUBLVL = 2;{$ENDIF}
{$IF Defined(PUBLVL_3) and not Declared(PUBLVL)}const PUBLVL = 3;{$ENDIF}
{$IF Defined(PUBLVL_4) and not Declared(PUBLVL)}const PUBLVL = 4;{$ENDIF}
{$IF not Declared(PUBLVL)}const PUBLVL = 0;{$ENDIF}

{$IF DBGLVL > 0}
{$DEFINE REL  := if False then}
{$DEFINE DBG  := if True then}
{$DEFINE DBG0 := if (DBGLVL >= 0) then}
{$DEFINE DBG1 := if (DBGLVL >= 1) then}
{$DEFINE DBG2 := if (DBGLVL >= 2) then}
{$DEFINE DBG3 := if (DBGLVL >= 3) then}
{$DEFINE DBG4 := if (DBGLVL >= 4) then}
{$ELSE}
{$DEFINE REL  := if True  then}
{$DEFINE DBG  := if False then}
{$DEFINE DBG0 := if False then}
{$DEFINE DBG1 := if False then}
{$DEFINE DBG2 := if False then}
{$DEFINE DBG3 := if False then}
{$DEFINE DBG4 := if False then}
{$ENDIF}

{$IF OPTLVL > 0}
{$DEFINE OPT  := if True  then}
{$DEFINE OPT0 := if OPTLVL =  0 then}
{$DEFINE OPT1 := if OPTLVL >= 1 then}
{$DEFINE OPT2 := if OPTLVL >= 2 then}
{$DEFINE OPT3 := if OPTLVL >= 3 then}
{$DEFINE OPT4 := if OPTLVL >= 4 then}
{$ELSE}
{$DEFINE OPT  := if False then}
{$DEFINE OPT0 := if True  then}
{$DEFINE OPT1 := if False then}
{$DEFINE OPT2 := if False then}
{$DEFINE OPT3 := if False then}
{$DEFINE OPT4 := if False then}
{$ENDIF}

{$IF PUBLVL > 0}
{$DEFINE DEV  := if False then}
{$DEFINE PUB  := if True  then}
{$DEFINE PUB0 := if PUBLVL >= 0 then}
{$DEFINE PUB1 := if PUBLVL >= 1 then}
{$DEFINE PUB2 := if PUBLVL >= 2 then}
{$DEFINE PUB3 := if PUBLVL >= 3 then}
{$DEFINE PUB4 := if PUBLVL >= 4 then}
{$ELSE}
{$DEFINE DEV  := if True  then}
{$DEFINE PUB  := if False then}
{$DEFINE PUB0 := if False then}
{$DEFINE PUB1 := if False then}
{$DEFINE PUB2 := if False then}
{$DEFINE PUB3 := if False then}
{$DEFINE PUB4 := if False then}
{$ENDIF}

// aliases
{$DEFINE DEBUGSYM := DEV DBG OPT0}
{$DEFINE DEBUGOPT := DEV DBG OPT2}
{$DEFINE DEVELSYM := DEV REL OPT0}
{$DEFINE DEVELOPT := DEV REL OPT2}
{$DEFINE SHIPPING := PUB REL OPT3}

// {$I ../dtinydebug.inc}
//
// procedure strcat(var buf: PAnsiChar; s: PAnsiChar);
// begin
//   Move(s^, buf^, StrLen(s));
//   Inc(buf, StrLen(s));
// end;
//
// var
//   collected_flags: array[0 .. 128 - 1] of AnsiChar;
//   buf: PAnsiChar;
// begin
//   DBG      Writeln('shown in debug builds');
//   REL      Writeln('shown in release builds');
//   DEV      Writeln('shown in internal development builds');
//   DEV OPT0 Writeln('shown in internal development builds, with no optimization level');
//   PUB OPT3 Writeln('shown in public builds with optimization level >= 3');
//   SHIPPING Writeln('shown in final builds');
//
//   FillChar(collected_flags, Length(collected_flags), 0);
//   buf := @collected_flags[0];
//
//   DBG  strcat(buf, 'DEBUG,');
//   REL  strcat(buf, 'RELEASE,');
//
//   DBG0 strcat(buf, 'DEBUG >= 0,');
//   DBG1 strcat(buf, 'DEBUG >= 1,');
//   DBG2 strcat(buf, 'DEBUG >= 2,');
//   DBG3 strcat(buf, 'DEBUG >= 3,');
//   DBG4 strcat(buf, 'DEBUG >= 4,');
//
//   OPT0 strcat(buf, 'OPTIM = 0,');
//   OPT1 strcat(buf, 'OPTIM = 1,');
//   OPT2 strcat(buf, 'OPTIM = 2,');
//   OPT3 strcat(buf, 'OPTIM = 3,');
//   OPT4 strcat(buf, 'OPTIM = 4,');
//
//   OPT0 DBG strcat(buf, 'DEVELDBG (OPT0 && DBG && DEV),');
//   OPT2 DBG strcat(buf, 'DEVELOPT (OPT2 && DBG && DEV),');
//   OPT2 REL strcat(buf, 'OPTIMSYM (OPT2 && REL && DEV),');
//   SHIPPING strcat(buf, 'SHIPPING (OPT3 && REL && PUB),');
//
//   Writeln(PAnsiChar(@collected_flags[0]));
// end.

// Tiny buildinfo macros
// - rlyeh, public domain | wtrmrkrlyeh
// - ported to pascal by Doj

{$IF not Declared(BUILD_GIT_BRANCH)}
const
  BUILD_GIT_BRANCH = 'n/a';
{$ENDIF}

{$IF not Declared(BUILD_GIT_REVISION)}
const
  BUILD_GIT_REVISION = 'NaN';
{$ENDIF}

{$IF not Declared(BUILD_BITS)}
{$IF Defined(CPU64)}
const
  BUILD_BITS = 64;
  {$IF not Declared(BUILD_ARCH)} BUILD_ARCH = '64-bit'; {$ENDIF}
{$ELSEIF Defined(CPU32)}
const
  BUILD_BITS = 32;
  {$IF not Declared(BUILD_ARCH)} BUILD_ARCH = '32-bit'; {$ENDIF}
{$ELSEIF Defined(CPU16)}
const
  BUILD_BITS = 16;
  {$IF not Declared(BUILD_ARCH)} BUILD_ARCH = '16-bit'; {$ENDIF}
{$ELSE}
const
  BUILD_BITS = 0;
  {$IF not Declared(BUILD_ARCH)} BUILD_ARCH = '0-bit'; {$ENDIF}
{$ENDIF}
{$ENDIF}

{$IF not Declared(BUILD_PROJECT)}
const
  BUILD_PROJECT = 'UNNAMED';
{$ENDIF}

{$IF not Declared(BUILD_VERSION)}
const
  BUILD_VERSION = '0.0.0';
{$ENDIF}

{$IF not Declared(BUILD_URL)}
const
  BUILD_URL = 'https://';
{$ENDIF}

{$IF not Declared(BUILD_STAMP)}
const
  BUILD_STAMP = {$I %DATE%} + ' ' + {$I %TIME%};
{$ENDIF}

{$IF not Declared(BUILD_TYPE)}
const
  BUILD_TYPE = 'DEBUG';
{$ENDIF}

{$IF not Declared(BUILD_INFO)}
const
  BUILD_INFO = BUILD_PROJECT + ' ' + BUILD_VERSION
             + ' (' + BUILD_ARCH + ' ' + BUILD_TYPE + ')'
             + ' (' + BUILD_STAMP + ')'
             + ' (git:' + BUILD_GIT_BRANCH + ' rev:' + BUILD_GIT_REVISION + ')';
{$ENDIF}

// begin
//   Writeln(BUILD_INFO);
// end.

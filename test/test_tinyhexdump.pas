{$MODE FPC}
{$MODESWITCH DEFAULTPARAMETERS}
{$MODESWITCH OUT}
{$MODESWITCH RESULT}

uses
  dtinyhexdump in '../dtinyhexdump.pas';

const
  sample: PAnsiChar = {$I %FILE%} + '/' + {$I %LINE%} + '/' + {$I %DATE%};
begin
  hexdump(output, sample, strlen(sample), 16);
end.

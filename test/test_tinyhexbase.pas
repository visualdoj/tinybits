{$MODE FPC}
{$MODESWITCH DEFAULTPARAMETERS}
{$MODESWITCH OUT}
{$MODESWITCH RESULT}

uses
  dtinyhexbase in '../dtinyhexbase.pas';

begin
  hexbase(output, 'hello world', strlen('hello world'));
  // --> hello world
  hexbase(output, 'hello world '#$1#$2#$3#$ff, strlen('hello world') + 5);
  // --> hello world ~010203ff~
  hexbase(output, 'hello~world', strlen('hello~world'));
  // --> hello~~world
  hexbase(output, #$a1#$2#$3, 3 );
  // --> ~a10203~
  hexbase(output, #$1#$2#$3'hello world', 3 + strlen('hello world'));
  // --> ~01020368656c6c6f20776f726c64~
  hexbase(output, #$1#$2#$3'hello world'#$f0, 4 + strlen('hello world') );
  // --> ~01020368656c6c6f20776f726c64f0~
end.

{$MODE FPC}
{$MODESWITCH DEFAULTPARAMETERS}
{$MODESWITCH OUT}
{$MODESWITCH RESULT}

uses
  dtinyhuman in '../dtinyhuman.pas';

begin
  Writeln({$I %LINE%}, ' ', humanize(1238), 'm');
  Writeln({$I %LINE%}, ' ', humanize(123823), 'l');
  Writeln({$I %LINE%}, ' ', humanize(123828328), 'bytes');
  Writeln('---');

  Writeln({$I %LINE%}, ' ', dehumanize('118 km'));
  Writeln({$I %LINE%}, ' ', dehumanize('118.9M'));
  Writeln({$I %LINE%}, ' ', dehumanize('118M'));
  Writeln({$I %LINE%}, ' ', dehumanize('118b'));
  Writeln({$I %LINE%}, ' ', dehumanize('118k'));
  Writeln({$I %LINE%}, ' ', dehumanize('118mb'));
  Writeln({$I %LINE%}, ' ', dehumanize('118gb'));
  Writeln({$I %LINE%}, ' ', dehumanize('118tb'));
  Writeln({$I %LINE%}, ' ', dehumanize('118pb'));
end.

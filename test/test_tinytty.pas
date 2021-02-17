{$MODE FPC}
{$MODESWITCH DEFAULTPARAMETERS}
{$MODESWITCH OUT}
{$MODESWITCH RESULT}

uses
  dtinytty in '../dtinytty.pas';

begin
  Writeln('No color');
  // usage:
  Writeln(green, tick,  yellow, ' passed', _end);
  Writeln(red,   cross, yellow, ' failed', _end);
  // or:
  tty256(255, 192, 0);
  Writeln('256 colors', _end);
  // also:
  tty('DECREASE WINDOW WIDTH AND RUN THE APP AGAIN! DECREASE WINDOW WIDTH AND RUN THE APP AGAIN! DECREASE WINDOW WIDTH AND RUN THE APP AGAIN! DECREASE WINDOW WIDTH AND RUN THE APP AGAIN!');
  // more tests:
  tty('hey');
  Writeln('[test] ');
  tty('DECREASE WINDOW WIDTH AND RUN THE APP AGAIN! DECREASE WINDOW WIDTH AND RUN THE APP AGAIN! DECREASE WINDOW WIDTH AND RUN THE APP AGAIN! DECREASE WINDOW WIDTH AND RUN THE APP AGAIN!');
end.

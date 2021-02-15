// Tiny digital pulses/signals. rlyeh, public domain | wtrmrkrlyeh
// Pascal port by Doj

{$MODE FPC}
{$MODESWITCH DEFAULTPARAMETERS}
{$MODESWITCH OUT}
{$MODESWITCH RESULT}

procedure pulse(state: PPtrInt);
begin
  case state[1] * 2 + state[0] of
    0: Writeln('pulse OFF');
    1: Writeln('pulse UP');
    2: Writeln('pulse DOWN');
    3: Writeln('pulse ON');
  end;
  state[1] := state[0];
end;

var
  state: array[0 .. 1] of PtrInt;
begin
  FillChar(state, SizeOf(state), 0);

  state[0] := 0;
  pulse(state);

  state[0] := 1;
  pulse(state);

  state[0] := 1;
  pulse(state);

  state[0] := 0;
  pulse(state);

  state[0] := 0;
  pulse(state);
end.

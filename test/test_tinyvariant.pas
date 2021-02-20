{$MODE FPC}
{$MODESWITCH DEFAULTPARAMETERS}
{$MODESWITCH OUT}
{$MODESWITCH RESULT}

uses
  dtinyvariant in '../dtinyvariant.pas';

procedure Callback;
begin
  Writeln('Callback!');
end;

var
  digit, other: Tvar;
begin
  Writeln('sizeof(Tvar)=', SizeOf(Tvar));

  digit.InitInt(42);
  other.InitString('hello world');

  Writeln(digit.ToString);
  Assert(digit.IsInt);
  Writeln(other.ToString);
  Assert(other.IsString);

  other.Assign(digit);
  Writeln(other.ToString);
  Assert(other.IsInt);

  other.InitCallback(@Callback);
  Writeln(other.ToString);
  other.Call;
end.

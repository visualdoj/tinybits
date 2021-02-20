{$MODE FPC}
{$MODESWITCH DEFAULTPARAMETERS}
{$MODESWITCH OUT}
{$MODESWITCH RESULT}

uses
  dtinywav in '../dtinywav';

const
  freq = 440;
  sRate = 44100;

procedure GenerateI(const FileName: AnsiString);
var
  A: array[0 .. 128000 - 1] of Int16;
  I: LongInt;
  F: File;
begin
  for I := 0 to High(A) do begin
    A[I] := Trunc(((2 shl 14) - 1) * Cos(I * 2 * pi * freq / sRate));
  end;
  Assign(F, FileName);
  ReWrite(F, 1);
  tinywav(F, 1, 16, sRate, @A[0], Length(A) * SizeOf(A[0]), False);
  Close(F);
  Writeln('generated ', FileName);
end;

procedure GenerateF(const FileName: AnsiString);
var
  A: array[0 .. 128000 - 1] of Single;
  I: LongInt;
  F: File;
begin
  for I := 0 to High(A) do begin
    A[I] := Cos(I * 2 * pi * freq / sRate);
  end;
  Assign(F, FileName);
  ReWrite(F, 1);
  tinywav(F, 1, 32, sRate, @A[0], Length(A) * SizeOf(A[0]), True);
  Close(F);
  Writeln('generated ', FileName);
end;

begin
  GenerateI('test_i16.wav');
  GenerateF('test_f32.wav');
end.

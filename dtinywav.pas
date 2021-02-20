unit dtinywav;

// Tiny WAV writer: original code by jon olick, public domain
// Floating point support + pure C version by rlyeh, public domain | wtrmrkrlyeh
// Ported to pascal by Doj

{$MODE FPC}
{$MODESWITCH DEFAULTPARAMETERS}
{$MODESWITCH OUT}
{$MODESWITCH RESULT}

interface

procedure tinywav(var F: File; numChannels, bitsPerSample: UInt16; sampleRateHz: UInt32; data: Pointer; size: UInt32; is_floating: Boolean);

implementation

procedure tinywav(var F: File; numChannels, bitsPerSample: UInt16; sampleRateHz: UInt32; data: Pointer; size: UInt32; is_floating: Boolean);
var
  bpsamp: UInt16;
  length, bpsec: UInt32;
begin
  BlockWrite(F, PAnsiChar('RIFF')^, 4);
  length := size + 44 - 8;
  BlockWrite(F, length, 4);
  if is_floating then begin
    BlockWrite(F, PAnsiChar('WAVEfmt '#$10#$00#$00#$00#$03#$00)^, 14);
  end else
    BlockWrite(F, PAnsiChar('WAVEfmt '#$10#$00#$00#$00#$01#$00)^, 14);
  BlockWrite(F, numChannels, 2);
  BlockWrite(F, sampleRateHz, 4);
  bpsec := numChannels * sampleRateHz * (bitsPerSample div 8);
  BlockWrite(F, bpsec, 4);
  bpsamp := numChannels * (bitsPerSample div 8);
  BlockWrite(F, bpsamp, 2);
  BlockWrite(F, bitsPerSample, 2);
  BlockWrite(F, PAnsiChar('data')^, 4);
  BlockWrite(F, size, 4);
  BlockWrite(F, data^, size);
end;

// var
//   A: array[0 .. 128000 - 1] of Int16;
//   I: LongInt;
//   F: File;
// begin
//   for I := 0 to High(A) do
//     A[I] := Trunc(((2 shl 15) - 1) * Cos(I * 2 * pi * 440 / 44100));
//   Assign(F, 'test.wav');
//   ReWrite(F, 1);
//   tinywav(F, 1, 16, 44100, @A[0], Length(A) * SizeOf(A[0]), False);
//   Close(F);
// end.

end.

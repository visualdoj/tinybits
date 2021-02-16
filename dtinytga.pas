unit dtinytga;

// Tiny TGA writer: original code by jon olick, public domain
// Elder C version by rlyeh, public domain | wtrmrkrlyeh
// Ported to pascal by Doj

{$MODE FPC}
{$MODESWITCH DEFAULTPARAMETERS}
{$MODESWITCH OUT}
{$MODESWITCH RESULT}

interface

procedure TinyTGA(var F: File; RGBA: Pointer; Width, Height, NumChannels: UInt16); overload;
procedure TinyTGA(const FileName: AnsiString; RGBA: Pointer; Width, Height, NumChannels: UInt16); overload;

implementation

procedure TinyTGA(var F: File; RGBA: Pointer; Width, Height, NumChannels: UInt16); overload;
const
  HEADER: array[0 .. 12 - 1] of Byte = (
    $00, $00, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00
  );
var
  X, I, Y, J: PtrInt;
  BPC: UInt16;
  ReMap: array[0 .. 4 - 1] of PtrInt;
  S: PByte;
begin
  // Swap RGBA to BGRA if using 3 or more channels
  BPC := NumChannels * 8; // 8 bits per channel
  if NumChannels >= 3 then begin
    ReMap[0] := 2;
    ReMap[1] := 1;
    ReMap[2] := 0;
    ReMap[3] := 3;
  end else begin
    ReMap[0] := 0;
    ReMap[1] := 1;
    ReMap[2] := 2;
    ReMap[3] := 3;
  end;
  // Header
  BlockWrite(F, HEADER[0], 12);
  BlockWrite(F, Width, 2);
  BlockWrite(F, Height, 2);
  BlockWrite(F, BPC, 2);
  for Y := Height - 1 downto 0 do begin
    I := (Y * Width) * NumChannels;
    X := I;
    while X < I + Width * NumChannels do begin
      for J := 0 to NumChannels - 1 do
        BlockWrite(F, PByte(RGBA)[X + ReMap[j]], 1);
      Inc(X, NumChannels);
    end;
  end;
end;

procedure TinyTGA(const FileName: AnsiString; RGBA: Pointer; Width, Height, NumChannels: UInt16); overload;
var
  F: File;
begin
  Assign(F, FileName);
  ReWrite(F, 1);
  TinyTGA(F, RGBA, Width, Height, NumChannels);
  Close(F);
end;

end.

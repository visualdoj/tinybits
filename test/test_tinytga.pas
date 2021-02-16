uses
  dtinytga in '../dtinytga.pas';

var
  Width, Height, NumChannels: UInt16;
  Buf: array of Byte;
  I, J: PtrInt;

begin
  Width := 256;
  Height := 256;
  NumChannels := 4;

  SetLength(Buf, 4 * Width * Height);
  for I := 0 to Width - 1 do begin
    for J := 0 to Height - 1 do begin
      Buf[4 * (I + J * Width) + 0] := Round(255 * I / Width);
      Buf[4 * (I + J * Width) + 1] := Round(255 * J / Height);
      Buf[4 * (I + J * Width) + 2] := Round(255 * (Width - I) / Width);
      Buf[4 * (I + J * Width) + 3] := 255;
    end;
  end;
  for I := 0 to Width div 16 do begin
    for J := 0 to Height - 1 do begin
      Buf[4 * (I*16+15 + J * Width) + 0] := 128;
      Buf[4 * (I*16+15 + J * Width) + 1] := 128;
      Buf[4 * (I*16+15 + J * Width) + 2] := 0;
      Buf[4 * (I*16+15 + J * Width) + 3] := 255;
    end;
  end;
  for J := 0 to Height div 16 do begin
    for I := 0 to Width - 1 do begin
      Buf[4 * (I + (J*16+15) * Width) + 0] := 128;
      Buf[4 * (I + (J*16+15) * Width) + 1] := 128;
      Buf[4 * (I + (J*16+15) * Width) + 2] := 0;
      Buf[4 * (I + (J*16+15) * Width) + 3] := 255;
    end;
  end;
  for I := 0 to Width - 1 do begin
      Buf[4 * (I + 0 * Width) + 0] := 255;
      Buf[4 * (I + 0 * Width) + 1] := 0;
      Buf[4 * (I + 0 * Width) + 2] := 0;
      Buf[4 * (I + 0 * Width) + 3] := 255;
  end;
  for J := 0 to Width - 1 do begin
      Buf[4 * (0 + J * Width) + 0] := 0;
      Buf[4 * (0 + J * Width) + 1] := 255;
      Buf[4 * (0 + J * Width) + 2] := 0;
      Buf[4 * (0 + J * Width) + 3] := 255;
  end;
  Buf[4 * (0 + 0 * Width) + 0] := 255;
  Buf[4 * (0 + 0 * Width) + 1] := 255;
  Buf[4 * (0 + 0 * Width) + 2] := 255;
  Buf[4 * (0 + 0 * Width) + 3] := 255;
  TinyTGA('test.tga', @Buf[0], Width, Height, NumChannels);
  Writeln('generated a texture and saved to test.tga');
end.

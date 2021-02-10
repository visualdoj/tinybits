unit dtinymime;

// tinymime. ported from https://github.com/sindresorhus/file-type (source is mit licensed)
// - rlyeh, public domain
// - ported to pascal by Doj

{$MODE FPC}
{$MODESWITCH DEFAULTPARAMETERS}
{$MODESWITCH OUT}
{$MODESWITCH RESULT}

interface

function tinymime(Buf: PByte; Len: SizeUInt): PAnsiChar;

implementation

function tinymime(Buf: PByte; Len: SizeUInt): PAnsiChar;
begin
  if (buf = nil) or (Len <= 60) then
      Exit(''); // invalid

  if (buf[0] = $FF) and (buf[1] = $D8) and (buf[2] = $FF) then
      Exit('jpg');

  if (buf[0] = $89) and (buf[1] = $50) and (buf[2] = $4E) and (buf[3] = $47) then
      Exit('png');

  if (buf[0] = $47) and (buf[1] = $49) and (buf[2] = $46) then
      Exit('gif');

  if (buf[8] = $57) and (buf[9] = $45) and (buf[10] = $42) and (buf[11] = $50) then
      Exit('webp');

  // needs to be before `tif` check
  if (((buf[0] = $49) and (buf[1] = $49) and
       (buf[2] = $2A) and (buf[3] = $00))
    or ((buf[0] = $4D) and (buf[1] = $4D) and
        (buf[2] = $00) and (buf[3] = $2A)))
  and (buf[8] = $43) and (buf[9] = $52)
  then
    Exit('cr2');

  if (buf[0] = $49) and (buf[1] = $49) and (buf[2] = $2A) and (buf[3] = $00)
  or (buf[0] = $4D) and (buf[1] = $4D) and (buf[2] = $00) and (buf[3] = $2A)
  then
    Exit('tif');

  if (buf[0] = $42) and (buf[1] = $4D) then
    Exit('bmp');

  if (buf[0] = $49) and (buf[1] = $49) and (buf[2] = $BC) then
    Exit('jxr');

  if (buf[0] = $38) and (buf[1] = $42) and (buf[2] = $50) and (buf[3] = $53)
  then
    Exit('psd');

  // needs to be before `zip` check
  if  (buf[0]  = $50) and (buf[1]  = $4B) and (buf[2]  = $03)
  and (buf[3]  = $04) and (buf[30] = $6D) and (buf[31] = $69)
  and (buf[32] = $6D) and (buf[33] = $65) and (buf[34] = $74)
  and (buf[35] = $79) and (buf[36] = $70) and (buf[37] = $65)
  and (buf[38] = $61) and (buf[39] = $70) and (buf[40] = $70)
  and (buf[41] = $6C) and (buf[42] = $69) and (buf[43] = $63)
  and (buf[44] = $61) and (buf[45] = $74) and (buf[46] = $69)
  and (buf[47] = $6F) and (buf[48] = $6E) and (buf[49] = $2F)
  and (buf[50] = $65) and (buf[51] = $70) and (buf[52] = $75)
  and (buf[53] = $62) and (buf[54] = $2B) and (buf[55] = $7A)
  and (buf[56] = $69) and (buf[57] = $70)
  then
    Exit('epub');

  // needs to be before `zip` check
  // assumes signed .xpi from addons.mozilla.org
  if  (buf[0]  = $50) and (buf[1]  = $4B) and (buf[2]  = $03)
  and (buf[3]  = $04) and (buf[30] = $4D) and (buf[31] = $45)
  and (buf[32] = $54) and (buf[33] = $41) and (buf[34] = $2D)
  and (buf[35] = $49) and (buf[36] = $4E) and (buf[37] = $46)
  and (buf[38] = $2F) and (buf[39] = $6D) and (buf[40] = $6F)
  and (buf[41] = $7A) and (buf[42] = $69) and (buf[43] = $6C)
  and (buf[44] = $6C) and (buf[45] = $61) and (buf[46] = $2E)
  and (buf[47] = $72) and (buf[48] = $73) and (buf[49] = $61) then
    Exit('xpi');

  if ((buf[0]  = $50) and (buf[1]  = $4B))
  and ((buf[2]  = $03) or (buf[2]  = $5) or (buf[2] = $7))
  and ((buf[3]  = $04) or (buf[3]  = $6) or (buf[3] = $8))
  then
      Exit('zip');

  if Len > 261 then begin
    if  (buf[257] = $75) and (buf[258] = $73) and (buf[259] = $74)
    and (buf[260] = $61) and (buf[261] = $72)
    then
        Exit('tar');
  end;

  if  (buf[0]  = $52) and (buf[1]  = $61) and (buf[2]  = $72)
  and (buf[3]  = $21) and (buf[4]  = $1A) and (buf[5]  = $07)
  and ((buf[6]  = $00) or (buf[6] = $1))
  then
    Exit('rar');

  if (buf[0]  = $1F) and (buf[1]  = $8B) and (buf[2]  = $8) then
    Exit('gz');

  if (buf[0] = $42) and (buf[1] = $5A) and (buf[2] = $68) then
    Exit('bz2');

  if  (buf[0] = $37) and (buf[1] = $7A) and (buf[2] = $BC)
  and (buf[3] = $AF) and (buf[4] = $27) and (buf[5] = $1C)
  then
    Exit('7z');

  if (buf[0] = $78) and (buf[1] = $01) then
    Exit('dmg');

  if ((buf[0] = $0) and (buf[1] = $0) and (buf[2] = $0) and
      ((buf[3] = $18) or (buf[3] = $20)) and (buf[4] = $66) and
      (buf[5] = $74) and (buf[6] = $79) and (buf[7] = $70))
  or ((buf[0] = $33) and (buf[1] = $67) and (buf[2] = $70) and (buf[3] = $35))
  or ((buf[0]  = $00) and (buf[1]  = $00) and (buf[2]  = $00) and
      (buf[3]  = $1C) and (buf[4]  = $66) and (buf[5]  = $74) and
      (buf[6]  = $79) and (buf[7]  = $70) and (buf[8]  = $6D) and
      (buf[9]  = $70) and (buf[10] = $34) and (buf[11] = $32) and
      (buf[16] = $6D) and (buf[17] = $70) and (buf[18] = $34) and
      (buf[19] = $31) and (buf[20] = $6D) and (buf[21] = $70) and
      (buf[22] = $34) and (buf[23] = $32) and (buf[24] = $69) and
      (buf[25] = $73) and (buf[26] = $6F) and (buf[27] = $6D))
  or ((buf[0]  = $00) and (buf[1]  = $00) and (buf[2]  = $00) and
      (buf[3]  = $1C) and (buf[4]  = $66) and (buf[5]  = $74) and
      (buf[6]  = $79) and (buf[7]  = $70) and (buf[8]  = $69) and
      (buf[9]  = $73) and (buf[10] = $6F) and (buf[11] = $6D))
  or ((buf[0]  = $00) and (buf[1]  = $00) and (buf[2]  = $00) and
      (buf[3]  = $1c) and (buf[4]  = $66) and (buf[5]  = $74) and
      (buf[6]  = $79) and (buf[7]  = $70) and (buf[8]  = $6D) and
      (buf[9]  = $70) and (buf[10] = $34) and (buf[11] = $32) and
      (buf[12] = $00) and (buf[13] = $00) and (buf[14] = $00) and
      (buf[15] = $0))
  then
    Exit('mp4');

  if  (buf[0]  = $00) and (buf[1]  = $00) and (buf[2] = $00)
  and (buf[3]  = $1C) and (buf[4]  = $66) and (buf[5] = $74)
  and (buf[6]  = $79) and (buf[7]  = $70) and (buf[8] = $4D)
  and (buf[9]  = $34) and (buf[10] = $56)
  then
    Exit('m4v');

  if (buf[0] = $4D) and (buf[1] = $54) and (buf[2] = $68) and (buf[3] = $64)
  then
    Exit('mid');

  // needs to be before the `webm` check
  if  (buf[31] = $6D) and (buf[32] = $61) and (buf[33] = $74)
  and (buf[34] = $72) and (buf[35] = $6f) and (buf[36] = $73)
  and (buf[37] = $6B) and (buf[38] = $61)
  then
      Exit('mkv');

  if (buf[0] = $1A) and (buf[1] = $45) and (buf[2] = $DF) and (buf[3] = $A3)
  then
    Exit('webm');

  if  (buf[0] = $00) and (buf[1] = $00) and (buf[2] = $00) and (buf[3] = $14)
  and (buf[4] = $66) and (buf[5] = $74) and (buf[6] = $79) and (buf[7] = $70)
  then
    Exit('mov');

  if  (buf[0] = $52) and (buf[1] = $49) and (buf[2]  = $46) and (buf[3] = $46)
  and (buf[8] = $41) and (buf[9] = $56) and (buf[10] = $49)
  then
    Exit('avi');

  if  (buf[0] = $30) and (buf[1] = $26) and (buf[2] = $B2) and (buf[3] = $75)
  and (buf[4] = $8E) and (buf[5] = $66) and (buf[6] = $CF) and (buf[7] = $11)
  and (buf[8] = $A6) and (buf[9] = $D9)
  then
    Exit('wmv');

  if (buf[0] = $0) and (buf[1] = $0) and (buf[2] = $1)
  and ((buf[3] shr 4) = $b) // buf[3].toString(16)[0] == 'b')
  then
    Exit('mpg');

  if (buf[0] = $49) and (buf[1] = $44) and (buf[2] = $33)
  or (buf[0] = $FF) and (buf[1] = $fb)
  then
    Exit('mp3');

  if (buf[4] = $66) and (buf[5] = $74) and (buf[6] = $79) and
     (buf[7] = $70) and (buf[8] = $4D) and (buf[9] = $34) and (buf[10] = $41)
  or (buf[0] = $4D) and (buf[1] = $34) and (buf[2] = $41) and (buf[3] = $20)
  then
    Exit('m4a');

  // needs to be before `ogg` check
  if  (buf[28] = $4F) and (buf[29] = $70) and (buf[30] = $75)
  and (buf[31] = $73) and (buf[32] = $48) and (buf[33] = $65)
  and (buf[34] = $61) and (buf[35] = $64)
  then
    Exit('opus');

  if (buf[0] = $4F) and (buf[1] = $67) and (buf[2] = $67) and (buf[3] = $53)
  then
    Exit('ogg');

  if (buf[0] = $66) and (buf[1] = $4C) and (buf[2] = $61) and (buf[3] = $43)
  then
    Exit('flac');

  if  (buf[0] = $52) and (buf[1] = $49) and (buf[2]  = $46)
  and (buf[3] = $46) and (buf[8] = $57) and (buf[9] = $41)
  and (buf[10] = $56) and (buf[11] = $45)
  then
    Exit('wav');

  if  (buf[0] = $23) and (buf[1] = $21) and (buf[2] = $41)
  and (buf[3] = $4D) and (buf[4] = $52) and (buf[5] = $0A) then
    Exit('amr');

  if (buf[0] = $25) and (buf[1] = $50) and (buf[2] = $44) and (buf[3] = $46)
  then
    Exit('pdf');

  if (buf[0] = $4D) and (buf[1] = $5A) then
    Exit('exe');

  if ((buf[0] = $43) or (buf[0] = $46)) and (buf[1] = $57) and (buf[2] = $53)
  then
    Exit('swf');

  if  (buf[0] = $7B) and (buf[1] = $5C) and (buf[2] = $72)
  and (buf[3] = $74) and (buf[4] = $66) then
    Exit('rtf');

  if  (buf[0] = $77) and (buf[1] = $4F) and (buf[2] = $46) and (buf[3] = $46)
  and (
    ((buf[4] = $00) and (buf[5] = $01) and (buf[6] = $00) and (buf[7] = $00))
    or
    ((buf[4] = $4F) and (buf[5] = $54) and (buf[6] = $54) and (buf[7] = $4F))
  ) then
    Exit('woff');

  if (buf[0] = $77) and (buf[1] = $4F) and (buf[2] = $46) and (buf[3] = $32)
  and (
    ((buf[4] = $00) and (buf[5] = $01) and (buf[6] = $00) and (buf[7] = $00))
    or
    ((buf[4] = $4F) and (buf[5] = $54) and (buf[6] = $54) and (buf[7] = $4F))
  ) then
    Exit('woff2');

  if  (buf[34] = $4C) and (buf[35] = $50)
  and (
    ((buf[8] = $00) and (buf[9] = $00) and (buf[10] = $01))
    or
    ((buf[8] = $01) and (buf[9] = $00) and (buf[10] = $02))
    or
    ((buf[8] = $02) and (buf[9] = $00) and (buf[10] = $02))
  ) then
    Exit('eot');

  if  (buf[0] = $00) and (buf[1] = $01) and (buf[2] = $00)
  and (buf[3] = $00) and (buf[4] = $00)
  then
    Exit('ttf');

  if  (buf[0] = $4F) and (buf[1] = $54) and (buf[2] = $54)
  and (buf[3] = $4F) and (buf[4] = $00)
  then
    Exit('otf');

  if  (buf[0] = $00) and (buf[1] = $00) and (buf[2] = $01)
  and (buf[3] = $00)
  then
    Exit('ico');

  if (buf[0] = $46) and (buf[1] = $4C) and (buf[2] = $56) and (buf[3] = $01)
  then
    Exit('flv');

  if (buf[0] = $25) and (buf[1] = $21)
  then
    Exit('ps');

  if  (buf[0] = $FD) and (buf[1] = $37) and (buf[2] = $7A) and (buf[3] = $58)
  and (buf[4] = $5A) and (buf[5] = $00)
  then
    Exit('xz');

  if (buf[0] = $53) and (buf[1] = $51) and (buf[2] = $4C) and (buf[3] = $69)
  then
    Exit('sqlite');

  if (buf[0] = $4E) and (buf[1] = $45) and (buf[2] = $53) and (buf[3] = $1A)
  then
    Exit('nes');

  if (buf[0] = $43) and (buf[1] = $72) and (buf[2] = $32) and (buf[3] = $34)
  then
    Exit('crx');

  if ((buf[0] = $4D) and (buf[1] = $53) and (buf[2] = $43) and (buf[3] = $46))
  or ((buf[0] = $49) and (buf[1] = $53) and (buf[2] = $63) and (buf[3] = $28))
  then
    Exit('cab');

  // needs to be before `ar` check
  if  (buf[0]  = $21) and (buf[1]  = $3C) and (buf[2]  = $61)
  and (buf[3]  = $72) and (buf[4]  = $63) and (buf[5]  = $68)
  and (buf[6]  = $3E) and (buf[7]  = $0A) and (buf[8]  = $64)
  and (buf[9]  = $65) and (buf[10] = $62) and (buf[11] = $69)
  and (buf[12] = $61) and (buf[13] = $6E) and (buf[14] = $2D)
  and (buf[15] = $62) and (buf[16] = $69) and (buf[17] = $6E)
  and (buf[18] = $61) and (buf[19] = $72) and (buf[20] = $79)
  then
    Exit('deb');

  if  (buf[0] = $21) and (buf[1] = $3C) and (buf[2] = $61) and (buf[3] = $72)
  and (buf[4] = $63) and (buf[5] = $68) and (buf[6] = $3E)
  then
    Exit('ar');

  if (buf[0] = $ED) and (buf[1] = $AB) and (buf[2] = $EE) and (buf[3] = $DB)
  then
    Exit('rpm');

  if ((buf[0] = $1F) and (buf[1] = $A0))
  or ((buf[0] = $1F) and (buf[1] = $9D))
  then
    Exit('z');

  if (buf[0] = $4C) and (buf[1] = $5A) and (buf[2] = $49) and (buf[3] = $50)
  then
    Exit('lz');

  if  (buf[0] = $D0) and (buf[1] = $CF) and (buf[2] = $11) and (buf[3] = $E0)
  and (buf[4] = $A1) and (buf[5] = $B1) and (buf[6] = $1A) and (buf[7] = $E1)
  then
    Exit('msi');

  Exit(''); // invalid
end;

{
var
  F: File;
  Buf: array[0 .. 512 - 1] of AnsiChar;
  Len: SizeUInt;
begin
  if ParamStr > 0 then begin
    Assign(F, ParamStr(1));
    Reset(F, 1);
    BlockRead(F, Buf[0], 512, Len);
    Writeln(tinymime(@Buf[0], Len));
    Close(F);
  end;
end.
}

end.

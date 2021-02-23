{$MODE OBJFPC}
{$MODESWITCH DEFAULTPARAMETERS}
{$MODESWITCH OUT}
{$MODESWITCH RESULT}

//
//  Generating example.tar:
//
//    mkdir example
//    echo qwerty >example/a.txt
//    echo 12345  >example/b.txt
//    mkdir example/sub
//    echo foo >example/sub/c.txt
//    echo bar >example/sub/d.txt
//    cd example &&
//    tar -cvf ../example.tar *
//

uses
  sysutils,
  classes,
  dtinyuntar in '../dtinyuntar.pas';

var
ExtractedFiles: array of record
  FileName: AnsiString;
  Size: UInt64;
  Data: Pointer;
end;

function yield(const FileName: AnsiString; size: UInt64): Pointer;
begin
  Writeln(FileName, ' (', size, ' bytes)');
  SetLength(ExtractedFiles, Length(ExtractedFiles) + 1);
  ExtractedFiles[High(ExtractedFiles)].FileName := FileName;
  ExtractedFiles[High(ExtractedFiles)].Size := Size;
  ExtractedFiles[High(ExtractedFiles)].Data := GetMem(size);
  Exit(ExtractedFiles[High(ExtractedFiles)].Data); // processed if valid ptr, skipped if null
end;

var
  Stream: TStream;
  success: Boolean;
  I: LongInt;
  S: AnsiString;
begin
  if ParamCount < 1 then begin
    Writeln(stderr, 'Usage: ', ParamStr(0), ' archive.tar [file]');
    Halt(1);
  end;
  try
    Stream := TFileStream.Create(ParamStr(1), fmOpenRead);
    success := tinyuntar(Stream, @yield);
  finally
    Stream.Free;
  end;
  for I := 0 to High(ExtractedFiles) do begin
    if success and (ExtractedFiles[I].FileName = ParamStr(2)) then begin
      SetString(S, ExtractedFiles[I].Data, ExtractedFiles[I].Size);
      Writeln(S);
    end;
    FreeMem(ExtractedFiles[I].Data);
  end;
  if not success then
    Halt(1);
end.

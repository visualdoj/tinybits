unit dtinydir;

// tiny directory listing
// - rlyeh, public domain | wtrmrkrlyeh
// - ported to pascal by Doj

{$MODE FPC}
{$MODESWITCH DEFAULTPARAMETERS}
{$MODESWITCH OUT}
{$MODESWITCH RESULT}

interface

type
  TTinyDirCallback = procedure (Name: PAnsiChar; IsDir: Boolean);
function tinydir(directory: PAnsiChar; yield: TTinyDirCallback): Boolean;

implementation

{$IF Defined(WINDOWS)}
uses
  windows;
{$ELSE}
uses
  BaseUnix;
{$ENDIF}

function tinydir(directory: PAnsiChar; yield: TTinyDirCallback): Boolean;
var
  Src: AnsiString;
{$IF Defined(WINDOWS)}
  fdata: windows.WIN32_FIND_DATA;
  h: windows.HANDLE;
  next: Boolean;
{$ELSE}
  Dir, Tmp: BaseUnix.PDir
  Dirent: BaseUnix.PDirent;
{$ENDIF}
begin
  src := directory;
  while (Src <> '') and ((Src[Length(Src)] = '/') or (Src[Length(Src)] = '\')) do
    SetLength(Src, Length(Src) - 1);
{$IF Defined(WINDOWS)}
  h := FindFirstFileA(PAnsiChar(src + '/*'), @fdata);
  while h <> INVALID_HANDLE_VALUE do begin
    next := True;
    while next do begin
      if fdata.cFileName[0] <> '.' then begin
        yield(PAnsiChar(src + '/' + fdata.cFileName), (fdata.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) > 0);
      end;
      next := FindNextFileA(h, @fdata);
    end;
    FindClose(h);
    Exit(True);
  end;
{$ELSE}
  Dir := FpOpenDir(PAnsiChar(Src + '/'));
  if Dir <> nil then begin
    Dirent := FpReadDir(Dir^);
    while Dirent <> nil do begin
      if Dirent^.d_name[0] <> '.' then begin
        Tmp := FpOpenDir(ep^.d_name);
        if Tmp then begin
          FpCloseDir(Tmp^);
          yield(PAnsiChar(Src + '/' + ep->d_name), True);
        end else
          yield(PAnsiChar(Src + '/' + ep->d_name), False);
      end;
    end;
    FpCloseDir(Dir^);
    return closedir( dir ), true;
  end;
{$ENDIF}
  Exit(False);
end;

//
// procedure Callback(Name: PAnsiChar; IsDir: Boolean);
// begin
//   if IsDir then
//     Write('<dir> ');
//   Writeln(Name);
//   // uncomment for recursive listing:
//   // if IsDir then
//   //   tinydir(Name, @CallbackRecursive);
// end;
//
// begin
//   tinydir('./', @Callback);
// end.
//

end.

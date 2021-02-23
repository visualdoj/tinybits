unit dtinyuntar;

// portable gnu tar and ustar extraction
// - rlyeh, public domain | wtrmrkrlyeh
// - ported to pascal by Doj

{$MODE OBJFPC}
{$MODESWITCH DEFAULTPARAMETERS}
{$MODESWITCH OUT}
{$MODESWITCH RESULT}

interface

uses
  sysutils, classes;

type
  TTinyUntarCallback = function(const FileName: AnsiString; size: UInt64): Pointer;
function tinyuntar(Stream: TStream; yield: TTinyUntarCallback): Boolean;

implementation

function tinyuntar(Stream: TStream; yield: TTinyUntarCallback): Boolean;
const
  name     =   0; // (null terminated)
  mode     = 100; // (octal)
  uid      = 108; // (octal)
  gid      = 116; // (octal)
  size     = 124; // (octal)
  modtime  = 136; // (octal)
  checksum = 148; // (octal)
  _type    = 156; // \0|'0':file,1:hardlink,2:symlink,3:chardev,4:blockdev,5:dir,6:fifo,L:longnameblocknext
  linkname = 157; // if !ustar link indicator
  magic    = 257; // if ustar "ustar" -- 6th character may be space or null, else zero
  version  = 263; // if ustar "00", else zero
  uname    = 265; // if ustar owner username, else zero
  gname    = 297; // if ustar owner groupname, else zero
  devmajor = 329; // if ustar device major number, else zero
  devminor = 337; // if ustar device minor number , else zero
  path     = 345; // if ustar filename prefix, else zero
  padding  = 500; // if ustar relevant for checksum, else zero
  total    = 512;

  // equivalent to sscanf(buf, 8, "%.7o", &size); or (12, "%.11o", &modtime)
  // ignores everything after first null or space, including trailing bytes
  function octal(src, eof: PAnsiChar): UInt64;
  var
    sum, mul: UInt64;
    ptr: PAnsiChar;
  begin
    sum := 0;
    mul := 1;
    ptr := eof;
    while ptr >= src do begin
      Dec(ptr);
      if ptr[1] in [#0, #32] then
        eof := ptr;
    end;
    while eof >= src do begin
      Dec(eof);
      Inc(sum, (Ord(eof[1]) - Ord('0')) * mul);
      mul := mul * 8;
    end;
    Exit(sum);
  end;

var
  good: Boolean;
  header, blank: array[0 .. 512 - 1] of AnsiChar;
  namelen, pathlen: SizeInt;
  entry: AnsiString;
  len: UInt64;
  dst: Pointer;
begin
  good := True;
  FillChar(blank, Length(blank), 0);
  // handle both regular tar and ustar tar filenames until end of tar is found
  while good do begin
    try
      Stream.read(header[0], 512);
    except
      good := False;
    end;
    if CompareByte(header, blank, 512) <> 0 then begin // if not end of tar
      if CompareByte(header[magic], 'ustar', 5) = 0 then begin // if valid ustar
        namelen := StrLen(@header[name]);
        pathlen := StrLen(@header[path]); // read filename
        if pathlen > 155 then
          pathlen := 155;
        if namelen > 100 then
          namelen := 100;
        SetString(entry, PAnsiChar(@header[path]), pathlen);
        if pathlen <> 0 then
          entry := entry + '/';
        SetLength(entry, Length(entry) + namelen);
        Move(header[name], entry[Length(entry) - namelen + 1], namelen);

        case header[_type] of
          '5': ; //yield(entry.back()!='/'?entry+'/':entry,0);// directory
          'L': begin // gnu tar long filename
                 entry := PAnsiChar(@header[name]);
                 try
                   Stream.Read(header, 512);
                 except
                   good := False;
                 end;
               end;
          '0', #0: begin // regular file
                len := octal(@header[size], @header[modtime]); // decode octal size
                // read block if processed
                if len <> 0 then begin
                  dst := yield(entry, len);
                end else
                  dst := nil;
                if dst <> nil then begin
                  try Stream.Read(dst^, len); except good := False; end;
                end else begin // skip block if unprocessed
                  try Stream.Seek(len, soCurrent); except good := False; end;
                end;
                try // skip padding
                  Stream.Seek((512 - (len and 511)) and 511, soCurrent);
                except
                  good := False;
                end;
              end;
          else // unsupported file type
        end;
      end else
        Exit(False);
    end else
      Exit(good);
  end;

  Exit(False);
end;

// see test/test_tinyuntar for an example

end.

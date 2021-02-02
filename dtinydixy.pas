unit dtinydixy;

// tinydixy, small hierarchical config file format (subset of YAML,
// spec in https://github.com/kuyawa/Dixy)
// - rlyeh, public domain
// - ported to pascal by Doj

{$MODE FPC}
{$MODESWITCH DEFAULTPARAMETERS}
{$MODESWITCH OUT}
{$MODESWITCH RESULT}

interface

// api, returns number of pairs found
type
  TTinyDixyYield = function (key: PAnsiChar; val: PAnsiChar): Boolean;
function tinydixy(s: PAnsiChar; yield: TTinyDixyYield): PtrInt;

implementation

function tinydixy(s: PAnsiChar; yield: TTinyDixyYield): PtrInt;
const
  SPEC_R = #13;
  SPEC_N = #10;
type
  TState = (_DEL, _REM, _KEY, _SUB, _VAL);
var
  map, it: PAnsiChar;
  mapcap, maplen, num_pairs_found: PtrInt;
  fsm: TState;
  cut, _end: array[TState] of PAnsiChar;
  buf: array[0 .. 256 - 1] of AnsiChar;
  key, val: PAnsiChar;
  reqlen: SizeInt;
begin
  map := nil;
  mapcap := 0;
  maplen := 0;
  num_pairs_found := 0;
  fsm := _DEL;
  FillChar(cut, Length(cut), #0);
  FillChar(_end, Length(_end), #0);
  while s^ <> #0 do begin
    while (s <> nil) and ((s^ = SPEC_R) or (s^ = SPEC_N)) do
      Inc(s);
    if s^ = '#' then begin
      fsm := _REM;
      Inc(s);
      cut[fsm] := s;
    end else if (s^ = ' ') or (s = #9) then begin
      fsm := _SUB;
      Inc(s);
      cut[fsm] := s;
    end else if (s^ = ':') then begin
      fsm := _VAL;
      Inc(s);
      cut[fsm] := s;
    end else if (s^ > ' ') and (s^ <= 'z') then begin
      fsm := _KEY;
      cut[fsm] := s;
      cut[_SUB] := s;
      _end[_SUB] := s;
      FreeMem(map);
      map := nil;
      mapcap := 0;
      maplen := 0;
    end else begin
      Inc(s);
      continue;
    end;
    case fsm of
    _REM: while (s^ <> #0) and (s^ <> SPEC_R) and (s^ <> SPEC_N) do
           Inc(s);
    _KEY, _SUB: begin
                 while (s^ <> #0) and (s^ > ' ') and (s^ <= 'z') and (s^ <> ':') do
                   Inc(s);
                 _end[fsm] := s;
               end;
    _VAL: begin
            while (s^ <> #0) and (s^ >= ' ') and (s^ <= 'z') and (s^ <> SPEC_R) and (s^ <> SPEC_N) do
              Inc(s);
            _end[fsm] := s;
            while _end[fsm][-1] = ' ' do
              Dec(_end[fsm]);
            FillChar(buf[0], 256, #0);
            key := buf;
            val := '';
            if _end[_KEY] - cut[_KEY] > 0 then begin
              Move(cut[_KEY]^, key^, _end[_KEY] - cut[_KEY]);
              Inc(key, _end[_KEY] - cut[_KEY]);
            end;
            if _end[_SUB] - cut[_SUB] > 0 then begin
              key^ := '.';
              Move(cut[_SUB]^, (key + 1)^, _end[_SUB] - cut[_SUB]);
              Inc(key, _end[_SUB] - cut[_SUB] + 1);
            end;
            reqlen := (key - buf) + 1 + (_end[_VAL] - cut[_VAL]) + 1 + 1;
            if (reqlen + maplen) >= mapcap then begin
              mapcap := reqlen + 512;
              map := ReAllocMem(map, mapcap);
            end;

            it := map + maplen;
            Move(buf[0], it^, key - buf);
            Inc(it, key - buf);
            it^ := #0;
            Inc(it);
            Move(cut[_VAL]^, it^, _end[_VAL] - cut[_VAL]);
            Inc(it, _end[_VAL] - cut[_VAL]);
            it^ := #0;
            Inc(it);
            it^ := #0;
            Inc(it);

            val := map + maplen + (key - buf) + 2;
            key := map + maplen;
            if val[0] <> #0 then begin
              yield(key, val);
              Inc(num_pairs_found);
            end;
            Inc(maplen, reqlen - 1);
          end;
    end;
  end;
  FreeMem(map);
  Exit(num_pairs_found);
end;

//
// Example
//
// function puts2(key: PAnsiChar; val: PAnsiChar): Boolean;
// begin
//   Writeln(key, ':''', val, '');
//   Exit(False);
// end;
//
// const
// Sample =
//   '# Dixy 1.0' + #13 +
//   '' + #13 +
//   'name: Taylor Swift' + #13 +
//   'age: 27' + #13 +
//   'phones:' + #13 +
//   '    0: 555-SWIFT' + #13 +
//   '    1: 900-SWIFT' + #13 +
//   '    2: 800-TAYLOR' + #13 +
//   'body:' + #13 +
//   '    height: 6 ft' + #13 +
//   '    weight: 120 lbs' + #13 +
//   'pets:' + #13 +
//   '    0:' + #13 +
//   '        name: Fido' + #13 +
//   '        breed: chihuahua' + #13 +
//   '    1:' + #13 +
//   '        name: Tinkerbell' + #13 +
//   '        breed: bulldog' + #13;
//
// begin
//   Writeln(tinydixy(Sample, @puts2), ' keys found');
// end.
//

end.

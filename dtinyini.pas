unit dtinyini;

// ini+, extended ini format
// - rlyeh, public domain
//
// # spec
//
//   ; line comment
//   [details]          ; map section name (optional)
//   user=john          ; key and value (mapped here as details.user=john)
//   +surname=doe jr.   ; sub-key and value (mapped here as details.user.surname=doe jr.)
//   color=240          ; key and value \
//   color=253          ; key and value |> array: color[0], color[1] and color[2]
//   color=255          ; key and value /
//   color=             ; remove key/value(s)
//   color=white        ; recreate key; color[1] and color[2] no longer exist
//   []                 ; unmap section
//   -note=keys may start with symbols (except plus and semicolon)
//   -note=linefeeds are either \r, \n or \r\n.
//   -note=utf8 everywhere.
//

{$MODE FPC}
{$MODESWITCH DEFAULTPARAMETERS}
{$MODESWITCH OUT}
{$MODESWITCH RESULT}

interface

// api

function ini(S: PAnsiChar): PAnsiChar;

// api, alternate callback version
type
  TIniCallback = procedure (Key, Value: PAnsiChar; UserData: Pointer);
procedure ini_cb(Text: PAnsiChar; Yield: TIniCallback; UserData: Pointer);

implementation

// impl

function ini(S: PAnsiChar): PAnsiChar;
type
  TState = (DEL, REM, TAG, IN_KEY, SUB, VAL);
var
  map: PAnsiChar;
  mapcap, maplen: PtrInt;
  fsm: TState;
  cut, _end: array[TState] of PAnsiChar;
  buf: array[0 .. 256 - 1] of AnsiChar;
  key: PAnsiChar;
  reqlen: PtrInt;
  cur: PAnsiChar;
  I: TState;
begin
  map := nil;
  mapcap := 0;
  maplen := 0;
  fsm := DEL;
  for I := Low(TState) to High(TState) do begin
    cut[I] := nil;
    _end[I] := nil;
  end;
  while S^ <> #0 do begin
    while (S^ <> #0) and (S^ in [' ', #9, #13, #10]) do
      Inc(S);
    if S^ = ';' then begin
      fsm := REM;
      Inc(S);
      cut[fsm] := S;
    end else if S^ = '[' then begin
      fsm := TAG;
      Inc(S);
      cut[fsm] := S;
    end else if S^ = '+' then begin
      fsm := SUB;
      Inc(S);
      cut[fsm] := S;
    end else if S^ = '=' then begin
      fsm := VAL;
      Inc(S);
      cut[fsm] := S;
    end else if (S^ > ' ') and (S^ <= 'z') and (S <> ']') then begin
      fsm := IN_KEY;
      cut[fsm]  := S;
      cut[SUB]  := S;
      _end[SUB] := S;
    end else begin
      Inc(S);
      continue;
    end;
    if fsm = REM then begin
      while (S^ <> #0) and (S^ <> #10) and (S^ <> #13) do
        Inc(S);
    end else if fsm = TAG then begin
      while (S^ <> #0) and (S^ <> #10) and (S^ <> #13) and (S^ <> ']') do
        Inc(S);
      _end[fsm] := S;
    end else if fsm = IN_KEY then begin
      while (S^ <> #0) and (S^ >  ' ') and (S^ <= 'z') and (S^ <> '=') do
        Inc(S);
      _end[fsm] := s;
    end else if fsm = SUB then begin
      while (S^ <> #0) and (S^ >  ' ') and (S^ <= 'z') and (S^ <> '=') do
        Inc(S);
      _end[fsm] := s;
    end else if fsm = VAL then begin
      while (S^ <> #0) and (S^ >= ' ') and (S^ <= 'z') and (S^ <> ';') do
        Inc(S);
      _end[fsm] := S;
      while _end[fsm][-1] = ' ' do
        Dec(_end[fsm]);
      FillChar(buf[0], Length(buf), 0);
      Key := @buf[0];
      if _end[TAG] - cut[TAG] > 0 then begin
        Move(cut[TAG]^, key^, _end[TAG] - cut[TAG]);
        Inc(key, _end[TAG] - cut[TAG]);
        key^ := '.';
        Inc(key);
      end;
      if _end[IN_KEY] - cut[IN_KEY] > 0 then begin
        Move(cut[IN_KEY]^, key^, _end[IN_KEY] - cut[IN_KEY]);
        Inc(key, _end[IN_KEY] - cut[IN_KEY]);
      end;
      if _end[SUB] - cut[SUB] > 0 then begin
        key^ := '.';
        Inc(key);
        Move(cut[SUB]^, key^, _end[SUB] - cut[SUB]);
        Inc(key, _end[SUB] - cut[SUB]);
      end;
      reqlen := (key - @buf[0]) + 1 + (_end[VAL] - cut[VAL]) + 1 + 1;
      if (reqlen + maplen) >= mapcap then begin
        Inc(mapcap, reqlen + 512);
        map := ReAllocMem(map, mapcap);
      end;
      cur := map + maplen;
      Move(buf[0], cur^, key - buf);
      Inc(cur, key - buf);
      cur^ := #0;
      Inc(cur);
      Move(cut[VAL]^, cur^, _end[VAL] - cut[VAL]);
      Inc(cur, key - buf);
      cur^ := #0;
      Inc(cur);
      cur^ := #0;
      Inc(cur);
      Inc(maplen, reqlen - 1);
    end;
  end;
  Exit(map);
end;

procedure ini_cb(Text: PAnsiChar; Yield: TIniCallback; UserData: Pointer);
var
  kv: PAnsiChar;
  iter: PAnsiChar;
  key, val: PAnsiChar;
begin
  kv := ini(Text);
  if kv <> nil then begin
    iter := kv;
    while iter[0] <> #0 do begin
      key := iter;
      while iter^ <> #0 do
        Inc(iter);
      Inc(iter);
      val := iter;
      while iter^ <> #0 do
        Inc(iter);
      Inc(iter);
      Yield(key, val, userdata);
    end;
    FreeMem(kv);
  end;
end;


{
var
  kv, iter: PAnsiChar;
begin
    kv := ini(
        '; line comment'#10 +
        '[details]          ; map section name (optional)'#10 +
        'user=john          ; key and value (mapped here as details.user=john)'#10 +
        '+surname=doe jr.   ; sub-key and value (mapped here as details.user.surname=doe jr.)'#10 +
        'color=240          ; key and value \'#10 +
        'color=253          ; key and value |> array: color[0], color[1] and color[2]'#10 +
        'color=255          ; key and value /'#10 +
        'color=             ; remove key/value(s)'#10 +
        'color=white        ; recreate key; color[1] and color[2] no longer exist'#10 +
        '[]                 ; unmap section'#10 +
        '-note=keys may start with symbols (except plus and semicolon)'#10 +
        '-note=linefeeds are either \r, \n or \r\n.'#10 +
        '-note=utf8 everywhere.'#10
    );

    if kv <> nil then begin
      iter := kv;
      while iter[0] <> #0 do begin
        printf("key: '%s', ", iter); while( *iter++ );
        Writeln('key: "', iter, '"');
        while iter[0] <> #0 do
          Inc(iter);
        Inc(iter);
        Writeln('val: "', iter, '"');
        while iter[0] <> #0 do
          Inc(iter);
        Inc(iter);
      end;
    end;
    FreeMem(kv);
  end;
end.
}

end.

uses
  dtinyini in '../dtinyini.pas';

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
end.

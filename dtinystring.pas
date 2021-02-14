unit dtinystring;

// tiny string utilities
// - rlyeh, public domain | wtrmrkrlyeh
// Ported to pascal by Doj

// @toadd: pad, left, right, center, triml, trimr, trim, [-1]

{$MODE FPC}
{$MODESWITCH DEFAULTPARAMETERS}
{$MODESWITCH OUT}
{$MODESWITCH RESULT}

interface

type
  TArrayOfStrings = array of AnsiString;

function Tokenize(S: AnsiString; Delimiters: PAnsiChar): TArrayOfStrings;
function Split(S: AnsiString; Delimiters: PAnsiChar): TArrayOfStrings;
function LeftOf(const SubString, S: AnsiString): AnsiString;
function RightOf(const SubString, S: AnsiString): AnsiString;
function ReplaceOne(const S, Target, Replacement: AnsiString): AnsiString;
function ReplaceAll(const S, Target, Replacement: AnsiString): AnsiString;

implementation

function Tokenize(S: AnsiString; Delimiters: PAnsiChar): TArrayOfStrings;
var
  map: array[AnsiChar] of AnsiChar;
  Ch: AnsiChar;
begin
  Result := nil; // make compiler happy
  for Ch := Low(AnsiChar) to High(AnsiChar) do
    map[Ch] := #0;
  while delimiters^ <> #0 do begin
    Inc(Delimiters);
    map[delimiters[-1]] := #1;
  end;
  SetLength(Result, 1);
  for Ch in S do begin
    if map[Ch] = #0 then begin
      Result[High(Result)] := Result[High(Result)] + Ch;
    end else if Length(Result[High(Result)]) > 0 then begin
      SetLength(Result, Length(Result) + 1);
    end;
  end;
  while (Length(Result) > 0) and (Length(Result[High(Result)]) <= 0) do
    SetLength(Result, Length(Result) - 1);
end;

function Split(S: AnsiString; Delimiters: PAnsiChar): TArrayOfStrings;
var
  Buf: AnsiString;
  Ch: AnsiChar;
begin
  Result := nil; // make compiler happy
  Buf := '';
  SetLength(Result, 0);
  for Ch in S do begin
    if Pos(Ch, Delimiters) > 0 then begin
      if Length(Buf) > 0 then begin
        SetLength(Result, Length(Result) + 1);
        Result[High(Result)] := Buf;
        Buf := ''
      end;
      SetLength(Result, Length(Result) + 1);
      Result[High(Result)] := Ch;
    end else
      Buf := Buf + Ch;
  end;
  if Length(Buf) > 0 then begin
    SetLength(Result, Length(Result) + 1);
    Result[High(Result)] := Buf;
  end;
end;

function LeftOf(const SubString, S: AnsiString): AnsiString;
var
  Index: SizeInt;
begin
  Index := Pos(SubString, S);
  if Index > 0 then begin
    Exit(Copy(S, 1, Index - 1));
  end else
    Exit(S);
end;

function RightOf(const SubString, S: AnsiString): AnsiString;
var
  Index: SizeInt;
begin
  Index := Pos(SubString, S);
  if Index > 0 then begin
    Exit(Copy(S, Index + Length(SubString), Length(S) - Index - Length(SubString) + 1));
  end else
    Exit(S);
end;

function ReplaceOne(const S, Target, Replacement: AnsiString): AnsiString;
var
  Found: SizeInt;
begin
  Found := Pos(Target, S);
  if Found > 0 then begin
    Exit(Copy(S, 1, Found - 1) +
         Replacement +
         Copy(S, Found + Length(Target), Length(S) - Found - Length(Target) + 1));
  end else
    Exit(S);
end;

function ReplaceAt(const S, Replacement: AnsiString; Index, TargetLength: SizeInt): AnsiString;
var
  Left, Right: AnsiString;
begin
  Left := Copy(S, 1, Index - 1);
  Right := Copy(S, Index + TargetLength, Length(S) - Index - TargetLength + 1);
  Exit(Left + Replacement + Right);
end;

function Find(const Target, S: AnsiString; Beginning: SizeInt): SizeInt;
var
  Cursor, CursorEnd: PAnsiChar;
begin
  Cursor := @S[Beginning];
  CursorEnd := @S[1] + Length(S);
  while Cursor + Length(Target) <= CursorEnd do begin
    if CompareByte(Cursor^, Target[1], Length(Target)) = 0 then
      Exit(Cursor - @S[1] + 1);
    Inc(Cursor);
  end;
  Exit(0);
end;

function ReplaceAll(const S, Target, Replacement: AnsiString): AnsiString;
var
  Found: SizeInt;
begin
  Result := S;
  Found := Pos(Target, S);
  while Found > 0 do begin
    Result := ReplaceAt(Result, Replacement, Found, Length(Target));
    Found := Find(Target, Result, Found + Length(Replacement) + 1);
  end;
end;

// var
//   Parts: TArrayOfStrings;
//   Part: AnsiString;
//
// begin
//   Parts := Tokenize('a/b/c/\d\e,f,g,', '/\,');
//   for Part in Parts do
//     Write('"', Part, '" ');
//   Writeln;
//   // "a" "b" "c" "d" "e" "f" "g"
//
//   Parts := Split('a/b/c/\d\e,f,g,', '/\,');
//   for Part in Parts do
//     Write('"', Part, '" ');
//   Writeln;
//   // "a" "/" "b" "/" "c" "/" "\" "d" "\" "e" "," "f" "," "g" ","
//
//   Writeln('"', LeftOf('beginning', 'in the beginning'), '"'); // "in the "
//   Writeln('"', RightOf('in the ', 'in the beginning'), '"'); // "beginning"
//   Writeln('"', ReplaceOne('0cad0', '0', 'abra'), '"'); // "abracad0"
//   Writeln('"', ReplaceAll('0cad0', '0', 'abra'), '"'); // "abracadabra"
// end.

end.

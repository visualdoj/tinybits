unit dtinybsearch;

// Tiny binary search (dichotomic): array must be sorted && supporting sequential access.
// - rlyeh, public domain | wtrmrkrlyeh
// - ported to pascal by Doj

{$MODE FPC}
{$MODESWITCH DEFAULTPARAMETERS}
{$MODESWITCH OUT}
{$MODESWITCH RESULT}

interface

function bsearchint(arr: PPtrInt; numelems: PtrInt; key: PtrInt): SizeUInt;
function bsearchsz(arr: PSizeInt; numelems: PtrInt; key: SizeInt): SizeUInt;
function bsearchstr(arr: PPAnsiChar; numelems: SizeUInt; key: PAnsiChar): SizeUInt;

implementation

uses
  strings;

function bsearchint(arr: PPtrInt; numelems: PtrInt; key: PtrInt): SizeUInt;
var
  min, max, mid: SizeInt;
begin
  min := 0;
  max := numelems;
  while min <= max do begin
    mid := min + (max - min) div 2;
    if key = arr[mid] then begin
      Exit(mid);
    end else if key < arr[mid] then begin
      max := mid - 1;
    end else
      min := mid + 1;
  end;
  Exit(High(SizeUInt));
end;

function bsearchsz(arr: PSizeInt; numelems: PtrInt; key: SizeInt): SizeUInt;
var
  min, max, mid: SizeInt;
begin
  min := 0;
  max := numelems;
  while min <= max do begin
    mid := min + (max - min) div 2;
    if key = arr[mid] then begin
      Exit(mid);
    end else if key < arr[mid] then begin
      max := mid - 1;
    end else
      min := mid + 1;
  end;
  Exit(High(SizeUInt));
end;

function bsearchstr(arr: PPAnsiChar; numelems: SizeUInt; key: PAnsiChar): SizeUInt;
var
  min, max, mid: SizeInt;
  search: PtrInt;
begin
  min := 0;
  max := numelems;
  while min <= max do begin
    mid := min + (max - min) div 2;
    search := StrComp(key, arr[mid]);
    if search = 0 then begin
      Exit(mid);
    end else if search < 0 then begin
      max := mid - 1;
    end else
      min := mid + 1;
  end;
  Exit(High(SizeUInt));
end;

// const
//   dict: array[0 .. 3] of PAnsiChar =
//         ('abc', 'abracadabra', 'ale hop', 'all your base');
//     // @ [0]    [1]            [2]        [3]
// var
//   i: LongInt;
// begin
//   Assert(bsearchstr(dict, Length(dict), 'abc') = 0);           // @ [0]
//   Assert(bsearchstr(dict, Length(dict), 'abracadabra') = 1);   // @ [1]
//   Assert(bsearchstr(dict, Length(dict), 'ale hop') =   2);     // @ [2]
//   Assert(bsearchstr(dict, Length(dict), 'all your base') = 3); // @ [3]
//
//   Assert(bsearchstr(dict, Length(dict), 'are belong to us') = High(SizeUInt)); // not found
//   Assert(bsearchstr(dict, Length(dict), 'move') = High(SizeUInt)); // not found
//   Assert(bsearchstr(dict, Length(dict), 'every') = High(SizeUInt)); // not found
//   Assert(bsearchstr(dict, Length(dict), 'zig') = High(SizeUInt)); // not found
//   Assert(bsearchstr(dict, Length(dict), '') = High(SizeUInt)); // not found
//
//   for i := 0 to High(dict) do
//     Assert(i = bsearchstr(dict, Length(dict), dict[i]));
// end.

end.

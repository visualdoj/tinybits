{$MODE FPC}
{$MODESWITCH DEFAULTPARAMETERS}
{$MODESWITCH OUT}
{$MODESWITCH RESULT}

{$ASSERTIONS ON}

uses
  dtinybsearch in '../dtinybsearch.pas';

const
  dict: array[0 .. 3] of PAnsiChar =
        ('abc', 'abracadabra', 'ale hop', 'all your base');
    // @ [0]    [1]            [2]        [3]
var
  i: LongInt;
begin
  Assert(bsearchstr(dict, Length(dict), 'abc') = 0);           // @ [0]
  Assert(bsearchstr(dict, Length(dict), 'abracadabra') = 1);   // @ [1]
  Assert(bsearchstr(dict, Length(dict), 'ale hop') =   2);     // @ [2]
  Assert(bsearchstr(dict, Length(dict), 'all your base') = 3); // @ [3]

  Assert(bsearchstr(dict, Length(dict), 'are belong to us') = High(SizeUInt)); // not found
  Assert(bsearchstr(dict, Length(dict), 'move') = High(SizeUInt)); // not found
  Assert(bsearchstr(dict, Length(dict), 'every') = High(SizeUInt)); // not found
  Assert(bsearchstr(dict, Length(dict), 'zig') = High(SizeUInt)); // not found
  Assert(bsearchstr(dict, Length(dict), '') = High(SizeUInt)); // not found

  for i := 0 to High(dict) do
    Assert(i = bsearchstr(dict, Length(dict), dict[i]));
end.

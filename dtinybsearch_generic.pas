unit dtinybsearch_generic;

{$MODE FPC}
{$MODESWITCH DEFAULTPARAMETERS}
{$MODESWITCH OUT}
{$MODESWITCH RESULT}
{$MODESWITCH TYPEHELPERS}
{$IF FPC_FULLVERSION < 30101} {$ERROR Needs fpc version at least 3.2.0} {$ENDIF}

interface

generic function bsearch<TContainter, T>(const x: T; const V: TContainter): PtrUInt; overload;
generic function bsearch<T>(const x: T; const V: array of T): PtrUInt; overload;

implementation

generic function bsearch<TContainter, T>(const x: T; const V: TContainter): PtrUInt;
var
  min, max, mid: PtrInt;
begin
  min := 0;
  max := V.Count;
  while min <= max do begin
    mid := min + (max - min) div 2;
    {**} if x = v[mid] then Exit(mid)
    else if x < v[mid] then max := mid - 1
    else min := mid + 1;
  end;
  Exit(High(PtrUInt));
end;

generic function bsearch<T>(const x: T; const V: array of T): PtrUInt;
var
  min, max, mid: PtrInt;
begin
  min := 0;
  max := Length(V);
  while min <= max do begin
    mid := min + (max - min) div 2;
    {**} if x = v[mid] then Exit(mid)
    else if x < v[mid] then max := mid - 1
    else min := mid + 1;
  end;
  Exit(High(PtrUInt));
end;

// var
//   v: array of PtrInt;
//   i: PtrInt;
// begin
//   // @ [0] [1] [2] [3] [4] [5] [6] [7] [8] [9] [10] [11] [12]
//   v := [0,  1,  2,  3,  5,  6,  7, 10, 11, 12,  13,  15,  16];
//
//   Assert(specialize bsearch<PtrInt>( 0, v) =   0);   // @ [ 0]
//   Assert(specialize bsearch<PtrInt>(10, v) =   7);   // @ [ 7]
//   Assert(specialize bsearch<PtrInt>(11, v) =   8);   // @ [ 8]
//   Assert(specialize bsearch<PtrInt>(15, v) =  11);   // @ [11]
//   Assert(specialize bsearch<PtrInt>(16, v) =  12);   // @ [12]
//   Assert(specialize bsearch<PtrInt>(-3, v) = High(PtrUInt)); // not found
//   Assert(specialize bsearch<PtrInt>(18, v) = High(PtrUInt)); // not found
//   Assert(specialize bsearch<PtrInt>( 8, v) = High(PtrUInt)); // not found
//   Assert(specialize bsearch<PtrInt>( 9, v) = High(PtrUInt)); // not found
//   for i in v do
//     Assert(v[specialize bsearch<PtrInt>(i, v)] = i);
// end.

end.

# tinybits
Pascal port of [tinybits](https://github.com/r-lyeh/tinybits).

- [x] Tiny bits and useful snippets.
- [x] Too simple to become libraries. Just cut & paste.
- [x] Cross-platform.
- [x] Public Domain.

## status

`✓` - done, `-` - not yet started, `x` - will not be ported, `=` - left unchanged

|Snippet|Status|Domain|Notes|
|:------|:-----|:-----|-------|
|[dtinyarc4.pas](dtinyarc4.pas)|✓|ARC4 stream cypher||
|[dtinyatoi.pas](dtinyatoi.pas)|✓|`atoi()` replacement||
|[dtinybsearch.pas](dtinybsearch.pas)|✓|Dichotomic binary search||
|[dtinybsearch_generic.pas](dtinybsearch_generic.pas)|✓|Dichotomic binary search||
|[dtinybuild.inc](dtinybuild.inc)|✓|Build macros||
|[dtinydebug.inc](dtinydebug.inc)|✓|Debug macros||
|[dtinydir.pas](dtinydir.pas)|✓|Recursive directory listing||
|[dtinydixy.pas](dtinydixy.pas)|✓|Small YAML-subset config file parser||
|[dtinyendian.pas](dtinyendian.pas)|✓|Endianness conversion|FPC already has [SwapEndian](https://www.freepascal.org/docs-html/rtl/system/swapendian.html), [NtoLE](https://www.freepascal.org/docs-html/rtl/system/ntole.html), [NtoBE](https://www.freepascal.org/docs-html/rtl/system/ntobe.html)|
|[dtinyerror.pas](dtinyerror.pas)|✓|Error handling||
|[dtinygc.pas](dtinygc.pas)|✓|Garbage collector|Needs faster `gc_inuse` implementation, now it is ~40x slower than `GetMem`/`FreeMem`|
|[dtinyhexbase.pas](dtinyhexbase.pas)|✓|Simple binary to ascii encoder||
|[dtinyhexdump.pas](dtinyhexdump.pas)|✓|Hexdump viewer||
|[dtinyhuman.pas](dtinyhuman.pas)|✓|De/humanized numbers||
|[dtinyini.pas](dtinyini.pas)|✓|Config parser (ini+)||
|[dtinylogger.pas](dtinylogger.pas)|✓|Session logger||
|[dtinymatch.pas](dtinymatch.pas)|✓|Wildcard/pattern matching||
|[dtinymime.pas](dtinymime.pas)|✓|MIME/file-type detection||
|[dtinypulse.pas](dtinypulse.pas)|✓|Digital pulses||
|[dtinyroman.pas](dtinyroman.pas)|✓|Integer to roman literals||
|[dtinystring.pas](dtinystring.pas)|✓|String utilities||
|[dtinytga.pas](dtinytga.pas)|✓|TGA writer||
|[dtinytime.pas](dtinytime.pas)|✓|Timing utilities||
|[dtinytty.pas](dtinytty.pas)|✓|Terminal utilities||
|[dtinyuntar.pas](dtinyuntar.pas)|✓|.tar unarchiver||
|[dtinyvariant.pas](dtinyvariant.pas)|✓|Variant class|See also [FPC's Variant](https://wiki.freepascal.org/Variant)|
|[dtinyvbyte.pas](dtinyvbyte.pas)|✓|VLE encoder/decoder (vbyte)||
|[dtinywav.pas](dtinywav.pas)|✓|Forked WAV writer||
|[tinydual.sh.bat](tinydual.sh.bat)|=|Dual bash/batch file||
|[tinyunit.m4](tinyunit.m4)|✓|Unit-testing|Need `m4` preprocessing, e.g. `m4 test_tinyunit.pas4 >t.pas && fpc t.pas`|
|_tinyjson5.c_|-|JSON5/SJSON/JSON parser/writer||
|_tinyuniso.cc_|-|.iso/9960 unarchiver||
|_tinyzlib.cpp_|-|zlib inflater||
|~~tinybenchmark.hpp~~|x|~~Benchmark code~~|Utilizes non-portable C/C++ syntax|
|~~tinydefer.cc~~|x|~~Defer macro, Go style~~|Utilizes non-portable C/C++ syntax|
|~~tinyfsm.c~~|x|~~Tight FSM~~|Utilizes non-portable C/C++ syntax|
|~~tinylog.h~~|x|~~Logging utilities~~|Utilizes non-portable C/C++ syntax|
|~~tinypipe.hpp~~|x|~~Chainable pipes~~|Heavy usage of STL and templates|
|~~tinyprint.cc~~|x|~~Comma-based printer~~|Utilizes non-portable C/C++ syntax|
|~~tinytodo.cc~~|x|~~TODO() macro~~|Both `{$I %DATA%}[1]` and string comparison in compile time are not supported in fpc|
|~~tinyunzip.cc~~|x|~~.zip unarchiver~~|Depends on `stb_image`|
|~~tinywtf.h~~|x|~~Portable host macros~~|Almost entirely consists of C++-related stuff|

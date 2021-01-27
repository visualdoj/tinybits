# tinybits
Pascal port of [tinybits](https://github.com/r-lyeh/tinybits).

- [x] Tiny bits and useful snippets.
- [x] Too simple to become libraries. Just cut & paste.
- [x] Cross-platform.
- [x] Public Domain.

## satus

`✓` - done, `-` - not yet started, `x` - will not be ported, `=` - left unchanged

|Snippet|Status|Domain|Comment|
|:------|:-----|:-----|-------|
|[dtinyarc4.pas](dtinyarc4.pas)|✓|ARC4 stream cypher||
|[dtinyatoi.pas](dtinyatoi.pas)|✓|`atoi()` replacement||
|[dtinyini.pas](dtinyini.pas)|✓|Config parser (ini+)||
|[tinydual.sh.bat](tinydual.sh.bat)|=|Dual bash/batch file||
|_tinybsearch.c_|-|Dichotomic binary search||
|_tinybuild.h_|-|Build macros||
|_tinydebug.h_|-|Debug macros||
|_tinydir.cc_|-|Recursive directory listing||
|_tinydixy.c_|-|Small YAML-subset config file parser||
|_tinyendian.c_|-|Endianness conversion|FPC already has [SwapEndian](https://www.freepascal.org/docs-html/rtl/system/swapendian.html), [NtoLE](https://www.freepascal.org/docs-html/rtl/system/ntole.html), [NtoBE](https://www.freepascal.org/docs-html/rtl/system/ntobe.html)|
|_tinyerror.c_|-|Error handling||
|_tinygc.cc_|-|Garbage collector (C++)||
|_tinyhexbase.c_|-|Simple binary to ascii encoder||
|_tinyhexdump.c_|-|Hexdump viewer||
|_tinyhuman.hpp_|-|De/humanized numbers||
|_tinyjson5.c_|-|JSON5/SJSON/JSON parser/writer||
|_tinylog.h_|-|Logging utilities||
|_tinylogger.hpp_|-|Session logger||
|_tinymatch.c_|-|Wildcard/pattern matching||
|_tinymime.c_|-|MIME/file-type detection||
|_tinypulse.c_|-|Digital pulses||
|_tinyroman.cc_|-|Integer to roman literals||
|_tinystring.cc_|-|String utilities||
|_tinytga.c_|-|Forked TGA writer||
|_tinytime.cc_|-|Timing utilities||
|_tinytodo.cc_|-|TODO() macro||
|_tinytty.c_|-|Terminal utilities||
|_tinyunit.c_|-|Unit-testing||
|_tinyuniso.cc_|-|.iso/9960 unarchiver||
|_tinyuntar.cc_|-|.tar unarchiver||
|_tinyvariant.cc_|-|Variant class||
|_tinyvbyte.h_|-|VLE encoder/decoder (vbyte)||
|_tinywav.c_|-|Forked WAV writer||
|_tinywtf.h_|-|Portable host macros||
|_tinyzlib.cpp_|-|zlib inflater||
|_tinybsearch.cc_|?|Dichotomic binary search|Needs generic routines from fpc 3.2.0?|
|~~tinybenchmark.hpp~~|x|~~Benchmark code~~|Utilizes non-portable C/C++ syntax|
|~~tinydefer.cc~~|x|~~Defer macro, Go style~~|Utilizes non-portable C/C++ syntax|
|~~tinyfsm.c~~|x|~~Tight FSM~~|Utilizes non-portable C/C++ syntax|
|~~tinypipe.hpp~~|x|~~Chainable pipes~~|Utilizes non-portable C/C++ syntax|
|~~tinyprint.cc~~|x|~~Comma-based printer~~|Utilizes non-portable C/C++ syntax|
|~~tinyunzip.cc~~|x|~~.zip unarchiver~~|Depends on `stb_image`|

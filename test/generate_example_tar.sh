#!/usr/bin/env bash

mkdir example
cd example
echo qwerty >a.txt
echo 12345  >b.txt
mkdir sub
echo foo >sub/c.txt
echo bar >sub/d.txt
tar -cvf ../example.tar *
cd ..

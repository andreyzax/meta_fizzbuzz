#!/usr/bin/env bash

test_md5hash="d0e6e868d231a6e1fbd87cc2c092676b"

for exe in fizzbuzz* ; do
  if test "$test_md5hash" = $(timeout 50s "./$exe" | md5sum | awk '{print $1}'); then
    echo $exe OK
  else
    echo $exe NOT OK
  fi
done

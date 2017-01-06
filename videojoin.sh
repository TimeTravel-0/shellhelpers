#!/usr/bin/env bash

INFILE1="$1";
INFILE2="$2";
OUTFILE="$3";



echo "joining $INFILE1 and $INFILE2 to $OUTFILE"

ffmpeg -i $INFILE1 -i $INFILE2 \
  -filter_complex '[0:0] [0:1] [1:0] [1:1] concat=n=2:v=1:a=1 [v] [a]' \
  -map '[v]' -map '[a]' $OUTFILE


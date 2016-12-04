#!/usr/bin/env bash

INFILE="$1";
OUTFILE="$2";
SPEED_VIDEO="$3";
SPEED_AUDIO=$(echo "scale=5;1.0/$SPEED_VIDEO" | bc);

echo "converting $INFILE to $OUTFILE with speed $SPEED_VIDEO ($SPEED_AUDIO)"

ffmpeg -i $INFILE -filter_complex "[0:v]setpts=$SPEED_VIDEO*PTS[v];[0:a]atempo=$SPEED_AUDIO[a]" -map "[v]" -map "[a]" -c:v libx264 -c:a libfaac $OUTFILE

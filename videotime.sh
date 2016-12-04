#!/usr/bin/env bash

INFILE="$1";
OUTFILE="$2";
SPEED_VIDEO="$3";
SPEED_AUDIO=$(echo "scale=5;1.0/$SPEED_VIDEO" | bc);

echo "converting $INFILE to $OUTFILE with speed $SPEED_VIDEO ($SPEED_AUDIO)"



ffmpeg -i $INFILE  \
-vf "drawtext=fontfile=/usr/share/fonts/truetype/own/simabc_rc1.ttf:\
text='%{pts\:hms} ':  fontcolor=white@0.8: box=1: boxcolor=blue@0.4:  x=8: y=32: fontsize=64"\
 -vcodec libx264 \
-vcodec libx264 -preset veryfast -f mp4 -pix_fmt yuv420p -y $OUTFILE

#-map "[v]" -map "[a]" -c:v libx264 -c:a libfaac $OUTFILE

# -y output.mp4


#ffmpeg -i $INFILE -filter_complex "[0:v]setpts=$SPEED_VIDEO*PTS[v];[0:a]atempo=$SPEED_AUDIO[a]"\
# -map "[v]" -map "[a]" -c:v libx264 -c:a libfaac $OUTFILE

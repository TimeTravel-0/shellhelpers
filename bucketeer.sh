#!/bin/bash
#crawls an amazon bucket. requires xmlstarlet.
#experimental/pre-alpha!

s3url=http://static.projects.hackaday.com
 
for i in {0..9}
do
    query_url="$s3url/?prefix=images/$i&max-keys=2147483647"
    #echo $query_url
    curl -s $query_url > $i.xml
    #curl -s $query_url | xmlstarlet sel -N w="http://s3.amazonaws.com/doc/2006-03-01/" -T -t -m "//w:Key" -v . -n |
    #while read filename
    #do
    #    dl_url=$s3url/$filename
    #    echo "$dl_url"
    #    #wget -cN $dl_url
    #    #sleep 1
    #done
done

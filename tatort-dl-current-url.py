#!/usr/bin/env python
import urllib2
url="http://www.ardmediathek.de/ard/servlet/ajax-cache/3516962/view=list/documentId=602916/goto=1"

response = urllib2.urlopen(url)
html_string = response.read()

href_split=html_string.split("href=\"")

for item in href_split:
    if "tatort" in item:
        if "20-uhr" in item:
            if not "hoerfassung" in item:
                print "http://www.ardmediathek.de"+item.split("\"")[0]



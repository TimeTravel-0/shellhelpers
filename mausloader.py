#! /usr/bin/env python
import urllib2
from xml.dom import minidom
import os
import sys

def dlurl(url,filen):
    file = urllib2.urlopen(url)
    output = open(filen,'wb')
    output.write(file.read())

print "mausloader"
# get xml
xml = urllib2.urlopen("http://podcast.wdr.de/maus.xml").read()
xmldoc = minidom.parseString(xml)
itemlist = xmldoc.getElementsByTagName('item')

dldir = "./maus"

if len(sys.argv)>1:
    dldir = sys.argv[1]

for item in itemlist:
    title = item.getElementsByTagName('title')[0].firstChild.nodeValue
    desc = item.getElementsByTagName('description')[0].firstChild.nodeValue
    url = item.getElementsByTagName('enclosure')[0].attributes['url'].value

    realtitle = title[title.find(', ')+2:]
    print realtitle
    dlurl(url,os.path.join(dldir,realtitle.replace('/','')+'.mp4'))

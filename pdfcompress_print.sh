#!/usr/bin/env bash
#source: https://askubuntu.com/a/243753

pdf2ps $1 /tmp/pdfcompress.ps
ps2pdf /tmp/pdfcompress.ps $2
rm /tmp/pdfresize.ps

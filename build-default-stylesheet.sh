#!/bin/sh

compass compile -s compact
LINES=`wc -l stylesheets/asciidoctor.css | cut -d" " -f1`
let LINES=$LINES-1
echo '/* Asciidoctor default stylesheet | MIT License | http://asciidoctor.org */' > asciidoctor.css
cat stylesheets/asciidoctor.css | tail --lines=$LINES | sed 's/ *\/\*\+ [^*]\+\($\| \*\/\)//g' | sed 's/^\/\*\* .* \*\/$//' | sed '/^\(*\/\|\) *$/d' >> asciidoctor.css

#!/bin/bash

compass compile -s compact
LINES=`wc -l stylesheets/asciidoctor.css | cut -d" " -f1`
echo '/* Asciidoctor default stylesheet | MIT License | http://asciidoctor.org */' > asciidoctor.css
cat stylesheets/asciidoctor.css | \
  sed 's/ *\/\*\+!\? [^*]\+\($\| \*\/\)//g' | \
  sed 's/^\/\*\* .* \*\/$//' | \
  sed '/^\(*\/\|\) *$/d' | \
  sed '/\(meta\.\|\.vcard\|\.vevent\)/d' | \
  grep -v 'font-awesome' >> asciidoctor.css

#!/bin/sh

compass compile -s compact
echo '/* Asciidoctor default stylesheet | MIT License | http://asciidoctor.org */' > asciidoctor.css && \
  cat stylesheets/asciidoctor.css | sed 's/ *\/\*\+ [^*]\+\($\| \*\/\)//g' | sed 's/^\/\*\* .* \*\/$//' | sed '/^\(*\/\|\) *$/d' >> asciidoctor.css

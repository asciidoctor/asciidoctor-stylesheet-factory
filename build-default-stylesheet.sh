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

# see https://www.npmjs.org/package/cssshrink
cssshrink asciidoctor.css | \
  sed '1i\
/* Remove the comments around the @import statement below when using this as a custom stylesheet */\
/*@import "https://fonts.googleapis.com/css?family=Open+Sans:300,300italic,400,400italic,600,600italic|Noto+Serif:400,400italic,700,700italic|Droid+Sans+Mono:400";*/' | \
  sed '1i\
/* Asciidoctor default stylesheet | MIT License | http://asciidoctor.org */' | \
  sed 's/\(Open Sans\|DejaVu Sans\|Noto Serif\|DejaVu Serif\|Droid Sans Mono\|DejaVu Sans Mono\)/"\1"/g' | \
  sed 's/font-weight:700/font-weight:bold/g' | \
  sed 's/\([^}]\)}\([^}]\)/\1}\n\2/g' > asciidoctor.min.css
#  sed 's/!important/ &/g' | \

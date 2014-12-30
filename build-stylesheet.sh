#!/bin/bash

STYLESHEET_NAME=asciidoctor

if [ ! -z $1 ]; then
  STYLESHEET_NAME=$1
fi

compass compile -s compact
LINES=`wc -l stylesheets/$STYLESHEET_NAME.css | cut -d" " -f1`
echo '/* Asciidoctor default stylesheet | MIT License | http://asciidoctor.org */' > $STYLESHEET_NAME.css
cat stylesheets/$STYLESHEET_NAME.css | \
  sed 's/ *\/\*\+!\? [^*]\+\($\| \*\/\)//g' | \
  sed 's/^\/\*\* .* \*\/$//' | \
  sed '/^\(*\/\|\) *$/d' | \
  sed '/\(meta\.\|\.vcard\|\.vevent\)/d' | \
  grep -v 'font-awesome' >> $STYLESHEET_NAME.css

# see https://www.npmjs.org/package/cssshrink
cssshrink $STYLESHEET_NAME.css | \
  sed '1i\
/* Remove the comments around the @import statement below when using this as a custom stylesheet */\
/*@import "https://fonts.googleapis.com/css?family=Open+Sans:300,300italic,400,400italic,600,600italic%7CNoto+Serif:400,400italic,700,700italic%7CDroid+Sans+Mono:400";*/' | \
  sed '1i\
/* Asciidoctor default stylesheet | MIT License | http://asciidoctor.org */' | \
  sed 's/\(Open Sans\|DejaVu Sans\|Noto Serif\|DejaVu Serif\|Droid Sans Mono\|DejaVu Sans Mono\|Ubuntu Mono\|Liberation Mono\|Varela Round\)/"\1"/g' | \
  sed 's/font-weight:700/font-weight:bold/g' | \
  sed 's/\([^}]\)}\([^}]\)/\1}\n\2/g' > $STYLESHEET_NAME.min.css

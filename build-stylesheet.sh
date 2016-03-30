#!/bin/bash

STYLESHEET_NAME=asciidoctor

if [ ! -z $1 ]; then
  STYLESHEET_NAME=$1
fi

compass compile -s compact
LINES=`wc -l stylesheets/$STYLESHEET_NAME.css | cut -d" " -f1`
echo '/* Asciidoctor default stylesheet | MIT License | http://asciidoctor.org */' > $STYLESHEET_NAME.css
cat stylesheets/$STYLESHEET_NAME.css | \
  # strip comments (cssshrink now handles this operation)
  sed 's/ *\/\*\+!\? [^*]\+\($\| \*\/\)//g' | \
  sed 's/^\/\*\* .* \*\/$//' | \
  sed '/^\(*\/\|\) *$/d' | \
  # remove some unused class names and styles
  sed 's/\.antialiased, body/body/' | \
  sed '/object, svg { display: inline-block;/d' | \
  sed 's/img { display: inline-block;/img, object, svg { display: inline-block;/' | \
  sed '/\(meta\.\|\.vcard\|\.vevent\|#map_canvas\)/d' | \
  # remove font-awesome @import if present
  grep -v 'font-awesome' >> $STYLESHEET_NAME.css

# see https://www.npmjs.org/package/cssshrink
cssshrink $STYLESHEET_NAME.css | \
  sed '1i\
/* Uncomment the @import statement below when using as a custom stylesheet */\
/*@import "https://fonts.googleapis.com/css?family=Open+Sans:300,300italic,400,400italic,600,600italic%7CNoto+Serif:400,400italic,700,700italic%7CDroid+Sans+Mono:400,700";*/' | \
  # add license header
  sed '1i\
/* Asciidoctor default stylesheet | MIT License | http://asciidoctor.org */' | \
  # quote font names
  sed 's/\(Open Sans\|DejaVu Sans\|Noto Serif\|DejaVu Serif\|Droid Sans Mono\|DejaVu Sans Mono\|Ubuntu Mono\|Liberation Mono\|Varela Round\)/"\1"/g' | \
  # allow browser to map bold to font-weight 600 from Open Sans (maybe not the best solution)
  sed 's/font-weight:700/font-weight:bold/g' | \
  # put endlines after every } that precedes a non-} character
  sed 's/}\([^}]\)/}\n\1/g' | \
  # remove the responsive alignment classes
  sed '/-text-\(left\|right\|center\|justify\)/d' > $STYLESHEET_NAME.min.css

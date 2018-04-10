#!/bin/bash

STYLESHEET_NAME=asciidoctor

if [ ! -z $1 ]; then
  STYLESHEET_NAME=$1
fi

bundle exec compass compile -s compact
LINES=`wc -l stylesheets/$STYLESHEET_NAME.css | cut -d" " -f1`
echo '/* Asciidoctor default stylesheet | MIT License | https://asciidoctor.org */' > $STYLESHEET_NAME.css
cat stylesheets/$STYLESHEET_NAME.css | \
  sed 's/ *\/\*\+!\? [^*]\+\($\| \*\/\)//g' | \
  sed 's/^\/\*\* .* \*\/$//' | \
  sed '/^\(*\/\|\) *$/d' | \
  sed 's/^@media only/@media/' | \
  sed '/\.antialiased {/d' | \
  sed '/^body { margin: 0;/d' | \
  sed 's/^body { background:[^}]*/&tab-size: 4; -moz-osx-font-smoothing: grayscale; -webkit-font-smoothing: antialiased;/' | \
  sed '/^body { -moz-osx-font-smoothing:/d' | \
  sed '/object, svg { display: inline-block;/d' | \
  sed 's/img { display: inline-block;/img, object, svg { display: inline-block;/' | \
  sed 's/table thead, table tfoot {\(.*\) font-weight: bold;\(.*\)}/table thead, table tfoot {\1\2}/' | \
  sed '/^p\.lead {/d' | \
  sed '/^ul\.no-bullet, ol\.no-bullet { margin-left: 1.5em; }$/d' | \
  sed '/^ul\.no-bullet { list-style: none; }$/d' | \
  sed '/\(meta\.\|\.vcard\|\.vevent\|#map_canvas\|"search"\|\[hidden\]\)/d' | \
  grep -v 'font-awesome' >> $STYLESHEET_NAME.css

# see https://www.npmjs.org/package/cssshrink (using 0.0.5)
# must run first: npm install cssshrink
./node_modules/.bin/cssshrink $STYLESHEET_NAME.css | \
  sed '1i\
/* Uncomment @import statement below to use as custom stylesheet */\
/*@import "https://fonts.googleapis.com/css?family=Open+Sans:300,300italic,400,400italic,600,600italic%7CNoto+Serif:400,400italic,700,700italic%7CDroid+Sans+Mono:400,700";*/' | \
  sed '1i\
/* Asciidoctor default stylesheet | MIT License | http://asciidoctor.org */' | \
  sed 's/\(Open Sans\|DejaVu Sans\|Noto Serif\|DejaVu Serif\|Droid Sans Mono\|DejaVu Sans Mono\|Ubuntu Mono\|Liberation Mono\|Varela Round\)/"\1"/g' | \
  sed 's/font-weight:700/font-weight:bold/g' | \
  sed 's/\([^:]\):\(before\|after\)/\1::\2/g' | \
  ruby -e 'puts STDIN.read.gsub(/}(?!})/, %(}\n)).chomp' - > $STYLESHEET_NAME.min.css

#!/bin/sh

function help() {
    echo "Compiles theme stylesheets wrapped into classes of theme name"
    echo
    echo "Usage: compass-wrapped [options]"
    echo
    echo "See 'compass' for options"
    echo
}

case "$1" in
    --help|-h|help)
        help
        exit
        ;;
esac

BASE_DIR=$(dirname "$0")
for fn in $BASE_DIR/sass/*.scss
do
    fn="${fn%.*}"
    bn=$(basename "$fn")
    cat << EOF > "$fn-wrapped.scss"
.$bn {
    @import "$bn";
}
EOF
    compass compile "sass/$bn-wrapped.scss"
    rm "$fn-wrapped.scss"
done



#!/bin/sh
#
# Use this file to configure what version of FontAwesome you want to use.
#
version="$1"

function help() {
    echo "Usage: set-awesome.sh [version]"
    echo
    echo "Available version values:"
    echo "  3 - FontAwesome 3"
    echo "  4 - FontAwesome 4"
    echo "  none - don't include FontAwesome"
}

if [ -z "$version" ]; then
    help
    echo
    echo "Error: you haven't provided FontAwesome version to set"
    exit 1
fi;

### what to turn on
ENABLE=""
case "$version" in
    3)
        ENABLE="_awesome-icons.scss"
        ;;
    4)
        ENABLE="_awesome-icons-4.scss"
        ;;
    none)
        ;;
    *)
        help
        echo
        echo "Error: unknown version '$version'"
        exit 2
        ;;
esac


### turn off all
SASS_DIR=$(dirname "$0")/sass/components/awesome
FILES=$SASS_DIR/*
for fn in $FILES
do
    newFn=${fn%-off}
    if [ "$fn" != "${newFn}-off" ]; then
        mv "$fn" "${newFn}-off";
    fi
done

### enable selected version
if [ ! -z "$ENABLE" ]; then
    echo "enable $SASS_DIR/$ENABLE"
    mv "$SASS_DIR/$ENABLE-off" $SASS_DIR/$ENABLE
fi
#!/bin/sh

for stylesheet in sass/*.scss; do
  name=$(basename "${stylesheet}" .scss)
  echo "Compiling ${name}"
  ./build-stylesheet.sh "${name}"
done

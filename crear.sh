#!/bin/sh
tree -H '' -d -o index.html # Solo carpetas
for dir in */; do
  (cd "$dir" && tree -H '' -o index.html)
done


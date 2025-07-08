#!/bin/sh
if [[ -z "$1" ]]; then
  echo "Uso: $0 commit_msg"
  exit;
fi
tree -H '' -d -o index.html # Solo carpetas

for dir in */; do
  (cd "$dir" && tree -H '' -o index.html && sed -i '1i <a href="../index.html">⬆️ Inicio</a><br>' index.html)
done


git add . && git commit -m $1 && git push

#!/bin/sh
if [[ -z "$1" ]]; then
  echo "Uso: $0 commit_msg"
  exit;
fi
tree -H '' -d -o index.html # Solo carpetas

# Busca carpetas, ignora la carpeta actual, las carpetas ocultas 
find . -type d ! -path '*/.*' ! -path '.' | while read dir; do 
  (cd "$dir" && tree -H '' -o index.html && sed -i '1i <a href="../index.html">⬆️ Subir</a><br>' index.html)
done


git add . && git commit -m $1 && git push

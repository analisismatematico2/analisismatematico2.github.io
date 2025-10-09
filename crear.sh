#!/bin/sh
if [[ -z "$1" ]]; then
  echo "Uso: $0 commit_msg"
  exit;
fi

# Solo carpetas
tree -H '' -d -o index.html 

# Busca carpetas, ignora la carpeta actual, las carpetas ocultas 
find . -type d ! -path '*/.*' ! -path '.' | while read dir; do 
  (cd "$dir" && tree -H '' -o index.html && sed -i '1i <a href="../index.html">⬆️ Subir</a><br>' index.html)
done

# Generar sitemap.xml simple
{
  echo '<?xml version="1.0" encoding="UTF-8"?>'
  echo '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'
  find . -name "*.html" ! -path "./.*" | sort | while read -r f; do
    url="https://cursoelectricidad.github.io/${f#./}"
    echo "  <url><loc>${url}</loc></url>"
  done
  echo '</urlset>'
} > sitemap.xml


git add . && git commit -m $1 && git push

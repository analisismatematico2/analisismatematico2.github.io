#!/bin/sh
if [[ -z "$1" ]]; then
  echo "Uso: $0 commit_msg"
  exit;
fi

# Solo carpetas
tree -H '' -d -o index.html 

# Busca carpetas, ignora la carpeta actual, las carpetas ocultas 
find . -type d ! -path '*/.*' ! -path '.' | while read dir; do 
  (cd "$dir" && tree  -I '*.md' -H '' -o index.html && sed -i '1i <a href="../index.html">⬆️ Subir</a><br><link rel="stylesheet" href="/xterm.css">' index.html)
done

BASE_URL="https://analisismatematico2.github.io"
RSS_FILE="rss.xml"
SITEMAP_FILE="sitemap.txt"
TMP_RSS="/tmp/rss.$$"
TMP_SITEMAP="/tmp/sitemap.$$"

# Generar sitemap.xml simple
{
  echo '<?xml version="1.0" encoding="UTF-8"?>'
  echo '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'
  find . -name "*.txt" ! -path "./.*" | sort | while read -r f; do
    url="${BASE_URL}/${f#./}"
    echo "  <url><loc>${url}</loc></url>"
  done
  echo '</urlset>'
} > sitemap.xml


# === RSS ===
echo "Generando RSS desde archivos .txt..."
{
  echo '<?xml version="1.0" encoding="UTF-8"?>'
  echo '<rss version="2.0"><channel>'
  echo "  <title>Noticias del sitio</title>"
  echo "  <link>$BASE_URL/</link>"
  echo "  <description>Actualizaciones del sitio en texto plano</description>"
  date -u '+  <lastBuildDate>%a, %d %b %Y %H:%M:%S +0000'
  echo ""

  # Busca los últimos 10 archivos .txt (ordenados por fecha)
  find . -type f -name '*.txt' ! -path './.*' \
    | sort -r | head -n 10 | while read -r f; do
      TITLE=$(head -n1 "$f" | sed 's/&/\&amp;/g')
      DATE=$(echo "$f" | grep -Eo '[0-9]{4}-[0-9]{2}-[0-9]{2}' | head -n1)
      if [ -n "$DATE" ]; then
        PUBDATE=$(date -u -d "$DATE" '+%a, %d %b %Y 00:00:00 +0000' 2>/dev/null)
      else
        PUBDATE=$(date -u '+%a, %d %b %Y 00:00:00 +0000')
      fi
      DESC=$(tail -n +2 "$f" | head -n5 | tr '\n' ' ' | sed 's/&/\&amp;/g')
      URL="$BASE_URL/${f#./}"

      echo "  <item>"
      echo "    <title>${TITLE}</title>"
      echo "    <link>${URL}</link>"
      echo "    <pubDate>${PUBDATE}</pubDate>"
      echo "    <description>${DESC}</description>"
      echo "  </item>"
    done

  echo '</channel></rss>'
} > "$TMP_RSS"
mv "$TMP_RSS" "$RSS_FILE"
echo "RSS generado: $RSS_FILE"

git add . && git commit -m $1 && git push

#!/usr/bin/env bash
# genera docs/assets/prevista-<revision>.jpg, la imagen que se muestra al
# compartir un enlace a la pagina (og:image). es un render de la ultima
# revision en 1200 x 630, bajo 300 KB para que whatsapp la muestre.
#
# el nombre lleva la revision porque whatsapp y otras apps guardan la imagen
# en cache por url: con un nombre nuevo en cada revision, la prevista se
# actualiza sola. el script borra las previstas anteriores y actualiza la
# ruta de la imagen en docs/_config.yml.
#
# se corre a mano en local, no en el workflow, porque necesita openscad y
# ffmpeg. despues hay que hacer commit de docs/assets/ y docs/_config.yml:
#   ./scripts/generar-prevista.sh
# o con una revision en particular:
#   ./scripts/generar-prevista.sh bote-v-0-rev-d

set -euo pipefail

raiz_repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

openscad="${OPENSCAD:-}"
if [ -z "$openscad" ]; then
  if command -v openscad >/dev/null 2>&1; then
    openscad="openscad"
  elif [ -x "/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD" ]; then
    openscad="/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD"
  else
    echo "openscad no encontrado (definir OPENSCAD con la ruta al binario)" >&2
    exit 1
  fi
fi

if ! command -v ffmpeg >/dev/null 2>&1; then
  echo "ffmpeg no encontrado" >&2
  exit 1
fi

if [ "$#" -gt 0 ]; then
  revision="$1"
else
  # la ultima revision, ordenando por version
  revision="$(cd "$raiz_repo/hardware" && ls -d bote-v-*-rev-* | grep -v -- '-fab$' | sort -V | tail -n 1)"
fi

fuente="$raiz_repo/hardware/$revision/bote.scad"
if [ ! -f "$fuente" ]; then
  echo "no existe $fuente" >&2
  exit 1
fi

nombre="prevista-$revision.jpg"
salida="$raiz_repo/docs/assets/$nombre"
config="$raiz_repo/docs/_config.yml"
mkdir -p "$(dirname "$salida")"

if ! grep -q '^ *path: /assets/prevista.*\.jpg$' "$config"; then
  echo "no se encontro la linea 'path: /assets/prevista...jpg' en $config" >&2
  exit 1
fi

temporal="$(mktemp -d)"
trap 'rm -rf "$temporal"' EXIT

echo "Renderizando $revision..."
# se renderiza al doble de tamano y se reduce, para que los bordes salgan suaves
"$openscad" -o "$temporal/render.png" --quiet \
  --render \
  --imgsize=2400,1260 \
  --camera=0,0,0,58,0,28,0 \
  --viewall --autocenter \
  --colorscheme=Tomorrow \
  "$fuente"

peso_maximo=$((300 * 1024))
for calidad in 2 3 5 7 10; do
  ffmpeg -v error -y -i "$temporal/render.png" \
    -vf "scale=1200:630:flags=lanczos" -q:v "$calidad" "$salida"
  peso=$(wc -c < "$salida" | tr -d ' ')
  [ "$peso" -le "$peso_maximo" ] && break
done

# borrar las previstas anteriores y apuntar _config.yml a la nueva
for anterior in "$raiz_repo"/docs/assets/prevista*.jpg; do
  [ "$anterior" = "$salida" ] || rm -f "$anterior"
done
sed -i.bak "s|^\( *path: \)/assets/prevista.*\.jpg$|\1/assets/$nombre|" "$config"
rm -f "$config.bak"

echo "Listo: docs/assets/$nombre ($((peso / 1024)) KB), _config.yml actualizado"

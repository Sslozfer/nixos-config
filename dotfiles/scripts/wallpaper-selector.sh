# wallpaper-selector: elegís un wallpaper, se copia al repo como actual.jpg
# y se reconstruye el sistema para que Stylix regenere la paleta de colores.
#
# Se empaqueta desde home.nix con writeShellApplication, que agrega el
# shebang y `set -euo pipefail`. Por eso este archivo no los lleva.

# Carpeta donde guardás tus wallpapers (cambiala si es otra)
SRC_DIR="${WALLPAPER_SRC:-$HOME/Pictures/wallpapers}"
REPO="$HOME/nixos-config"
DEST="$REPO/wallpapers/actual.jpg"
HOST="nixos"

# --- Modo 2: lo invoca el propio script dentro de una ventana de kitty ---
# Se hace en una terminal para poder escribir la contraseña de sudo y ver el progreso.
if [[ "${1:-}" == "--rebuild" ]]; then
  if sudo nixos-rebuild switch --flake "$REPO#$HOST"; then
    # Recarga la config de las ventanas de kitty abiertas (colores nuevos)
    pkill -USR1 -x kitty || true
  else
    echo
    read -r -p "El rebuild falló. Enter para cerrar... " _
  fi
  exit 0
fi

# --- Modo 1: selector ---
if [[ ! -d "$SRC_DIR" ]]; then
  rofi -e "No existe la carpeta de wallpapers: $SRC_DIR"
  exit 1
fi

# Lista las imágenes con miniatura y deja elegir con rofi.
# Busca en la carpeta y en un nivel de subcarpetas, y muestra la ruta relativa
# (por ejemplo: Oscuros/negro_con_chispas.jpg). Solo se excluye el actual.jpg
# de la carpeta raíz.
choice=$(
  find "$SRC_DIR" -maxdepth 2 -type f \
    \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) \
    ! -path "$SRC_DIR/actual.jpg" -printf '%P\n' | sort |
  while IFS= read -r name; do
    printf '%s\0icon\x1f%s\n' "$name" "$SRC_DIR/$name"
  done |
  rofi -dmenu -i -show-icons -p "Wallpaper"
) || exit 0

[[ -n "$choice" ]] || exit 0
src="$SRC_DIR/$choice"

# Copia como actual.jpg (convierte si no es JPG, para conservar el nombre)
mkdir -p "$(dirname "$DEST")"
case "${choice,,}" in
  *.jpg|*.jpeg) cp -f -- "$src" "$DEST" ;;
  *) magick "$src" -quality 95 "jpg:$DEST" ;;
esac

# El flake solo ve archivos que git conoce
git -C "$REPO" add -- wallpapers/actual.jpg

# Se ve el cambio al instante, mientras el rebuild regenera los colores
awww img "$DEST" || true

exec kitty --title "Aplicando wallpaper" "$0" --rebuild

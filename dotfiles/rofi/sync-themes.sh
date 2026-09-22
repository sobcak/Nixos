#!/usr/bin/env bash
# Regenerate rofi palettes from the kitty themes in this flake.
# Writes themes/colors/<name>.rasi and themes/<name>.rasi for every kitty theme.
# The monochrome themes/void.rasi is hand-written and never touched here.
# Run this after adding a kitty theme, then rebuild to apply.
set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
kitty_dir="${repo}/dotfiles/kitty/themes"
rofi_dir="${repo}/dotfiles/rofi/themes"

mkdir -p "${rofi_dir}/colors"

# Selection fill per theme: the strongest hue in the flag/palette, plus a
# readable text colour on top of it.
selection() {
    case "$1" in
        ace)          echo "#800080 #ffffff" ;;
        amber)        echo "#ffb000 #000000" ;;
        aro)          echo "#3DA542 #000000" ;;
        ash)          echo "#c5c8c6 #000000" ;;
        bi)           echo "#9B4F96 #ffffff" ;;
        ember)        echo "#ff4500 #000000" ;;
        enby)         echo "#9C59D1 #ffffff" ;;
        freeze)       echo "#29b6f6 #000000" ;;
        gay)          echo "#732982 #ffffff" ;;
        genderfluid)  echo "#C011D7 #ffffff" ;;
        lesbian)      echo "#A30262 #ffffff" ;;
        matrix)       echo "#00ff41 #000000" ;;
        mlm)          echo "#078D70 #ffffff" ;;
        pan)          echo "#FF218C #ffffff" ;;
        trans)        echo "#5BCEFA #000000" ;;
        void-spectrum) echo "#c5c8c6 #000000" ;;
        *)            echo "" ;;
    esac
}

value() { awk -v k="$2" '$1 == k { print $2; exit }' "$1"; }

emit() {
    local name="$1" src="$2"
    local sel sel_fg
    read -r sel sel_fg <<<"$(selection "$name")"
    if [[ -z "${sel}" ]]; then
        echo "skip ${name}: no selection colour defined" >&2
        return
    fi

    local bg fg
    bg="$(value "$src" background)"
    fg="$(value "$src" foreground)"

    {
        printf '/* %s — generated from kitty/themes/%s by sync-themes.sh */\n\n' \
            "$name" "$(basename "$src")"
        printf '* {\n'
        printf '    bg:         %sf2;\n' "$bg"
        printf '    fg:         %s;\n' "$fg"
        printf '\n'
        for i in $(seq 0 15); do
            printf '    c%-9s %s;\n' "${i}:" "$(value "$src" "color${i}")"
        done
        printf '\n'
        printf '    sel:        %s;\n' "$sel"
        printf '    sel-fg:     %s;\n' "$sel_fg"
        printf '    sel-border: %s;\n' "$sel"
        printf '}\n'
    } > "${rofi_dir}/colors/${name}.rasi"

    {
        printf '/* %s — brutalist rofi theme, kitty %s palette */\n' "$name" "$name"
        printf '@import "colors/%s"\n' "$name"
        printf '@import "shared/layout"\n'
    } > "${rofi_dir}/${name}.rasi"

    echo "${name}"
}

for conf in "${kitty_dir}"/*.conf; do
    name="$(basename "${conf}" .conf)"
    # void's rofi theme is the hand-written monochrome one
    [[ "${name}" == "void" ]] && continue
    emit "${name}" "${conf}"
done

#!/usr/bin/env bash
# Convert a kitty palette .conf for alacritty.
# Usage:
#   kitty-theme-to-toml.sh <kitty-theme.conf> <out.toml>
#   kitty-theme-to-toml.sh --msg-args <kitty-theme.conf>  # alacritty msg config args (stdout)
set -euo pipefail

mode=toml
if [[ "${1:-}" == "--msg-args" ]]; then
  mode=msg
  shift
fi

src=${1:?kitty theme conf}
out=/dev/stdout
if [[ "$mode" == "toml" ]]; then
  out=${2:?output toml}
fi

tmp=$(mktemp)
awk -v mode="$mode" '
  BEGIN {
    bg="#000000"; fg="#c5c8c6"
    for (i = 0; i < 16; i++) c[i] = "#c5c8c6"
    c[0] = "#000000"; c[8] = "#444444"
    c[1] = "#ff0000"; c[9] = "#ff0000"
  }
  /^[[:space:]]*#/ { next }
  /^[[:space:]]*$/ { next }
  $1 == "background" { bg = $2; next }
  $1 == "foreground" { fg = $2; next }
  $1 ~ /^color[0-9]+$/ { c[substr($1, 6) + 0] = $2; next }
  END {
    split("black red green yellow blue magenta cyan white", names, " ")
    if (mode == "msg") {
      print "colors.primary.background=\"" bg "\""
      print "colors.primary.foreground=\"" fg "\""
      for (i = 0; i < 8; i++)
        print "colors.normal." names[i+1] "=\"" c[i] "\""
      for (i = 0; i < 8; i++)
        print "colors.bright." names[i+1] "=\"" c[i+8] "\""
    } else {
      print "# Generated from kitty theme — do not edit; use `theme`"
      print ""
      print "[colors.primary]"
      print "background = \"" bg "\""
      print "foreground = \"" fg "\""
      print ""
      print "[colors.normal]"
      print "black   = \"" c[0] "\""
      print "red     = \"" c[1] "\""
      print "green   = \"" c[2] "\""
      print "yellow  = \"" c[3] "\""
      print "blue    = \"" c[4] "\""
      print "magenta = \"" c[5] "\""
      print "cyan    = \"" c[6] "\""
      print "white   = \"" c[7] "\""
      print ""
      print "[colors.bright]"
      print "black   = \"" c[8] "\""
      print "red     = \"" c[9] "\""
      print "green   = \"" c[10] "\""
      print "yellow  = \"" c[11] "\""
      print "blue    = \"" c[12] "\""
      print "magenta = \"" c[13] "\""
      print "cyan    = \"" c[14] "\""
      print "white   = \"" c[15] "\""
    }
  }
' "$src" > "$tmp"

if [[ "$mode" == "msg" ]]; then
  cat "$tmp"
  rm -f "$tmp"
else
  mv -f "$tmp" "$out"
fi

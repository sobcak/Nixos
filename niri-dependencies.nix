# Packages referenced by niri / waybar session tooling.
# Imported into home.packages from home.nix.
#
# Also enable (in configuration.nix):
#   programs.niri.enable = true;
#   services.flatpak.enable = true;
#   services.pipewire (wpctl via wireplumber)

{ pkgs }:
with pkgs; [
  # Compositor session helpers
  waybar
  xwayland-satellite
  sunsetr
  hyprsunset

  # Notifications / clipboard
  swaynotificationcenter
  cliphist
  wl-clipboard

  # Launcher / terminal / lock / screenshots
  rofi
  kitty
  hyprlock
  hypridle
  hyprshot
  grim
  slurp

  # Media / brightness / mirroring
  playerctl
  brightnessctl
  wl-mirror
  jq

  # Startup shell bits
  fastfetch

  # Waybar / Qt theming
  pavucontrol
  libsForQt5.qt5ct
  kdePackages.qt6ct
]

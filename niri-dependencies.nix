# Packages referenced by ~/.config/niri/config.kdl
# Merge into environment.systemPackages in /etc/nixos/configuration.nix, e.g.:
#   environment.systemPackages = with pkgs; [ /* existing */ ] ++ (import /home/oliver/.config/niri/dependencies.nix { inherit pkgs; });
#
# Also enable:
#   programs.niri.enable = true;
#   services.flatpak.enable = true;          # Mod+B zen browser
#   services.pipewire.wireplumber.enable = true;  # wpctl (usually default with pipewire)

{ pkgs }:
with pkgs; [
  # Compositor session (programs.niri.enable also pulls niri)
  waybar
  xwayland-satellite
  sunsetr
  hyprsunset # optional; config no longer autostarts it

  # Notifications / clipboard
  swaynotificationcenter # swaync, swaync-client
  cliphist
  wl-clipboard # wl-paste, wl-copy

  # Launcher / terminal / lock / screenshots
  rofi
  kitty
  hyprlock
  hyprshot
  grim # hyprshot backend
  slurp # hyprshot backend

  # Media / brightness / mirroring
  playerctl
  brightnessctl
  wl-mirror
  jq # Mod+Shift+M focused-output parse
  # wpctl comes from wireplumber (pipewire)

  # Startup shell bits
  fish
  fastfetch

  # Waybar icons / calendar tooltip
  nerd-fonts.iosevka
  lexend
  pavucontrol

  # Qt theming (QT_QPA_PLATFORMTHEME)
  libsForQt5.qt5ct
  kdePackages.qt6ct

  # Flatpak host + Zen (flatpak run app.zen_browser.zen)
  flatpak

  # Polkit — config spawns polkit-gnome-authentication-agent-1
  polkit_gnome
  (writeShellScriptBin "polkit-gnome-authentication-agent-1" ''
    exec ${polkit_gnome}/libexec/polkit-gnome-authentication-agent-1 "$@"
  '')
]

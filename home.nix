{ config, lib, pkgs, inputs, osConfig, ... }:

let
  # Shared niri/gtk configs; cursor size differs by host DPI/viewing distance.
  # ThinkPad (eDP @ 1.25) keeps 24; desktop ~93 DPI monitors need smaller.
  cursorSize =
    if osConfig.networking.hostName == "olinux-desktop" then 16 else 24;
  withCursorSize = file:
    builtins.replaceStrings [ "__CURSOR_SIZE__" ] [ (toString cursorSize) ]
      (builtins.readFile file);
in
{
  home.username = "oliver";
  home.homeDirectory = "/home/oliver";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    neovim
    btop
    cmatrix
    cava

    wineWow64Packages.wayland
    winetricks
    logisim-evolution
    prismlauncher

    burpsuite
    caido-desktop

    brave
    nautilus
    iloader
    libimobiledevice
    usbmuxd
    ideviceinstaller
<<<<<<< Updated upstream
=======
    ventoy

    # Dev Věci pro mami web
    rclone



>>>>>>> Stashed changes
    audacity
    legcord
    mapscii
    unzip
    ripgrep
    alacritty
    asciiquarium
    ranger
    feh
    termshark
    hashcat
    john
    nmap
    metasploit
    wifite2
    tcpdump
    aircrack-ng
    ghidra
    theharvester
    protontricks
    # Both ship bin/ld.gold; gcc-wrapper is already priority 10, so hiPrio gcc wins
    clang
    (lib.hiPrio gcc)
    tree-sitter
    pyright
    nodejs
    dotnet-sdk_10

    vscodium
    code-cursor
    inputs.claude-desktop.packages.${pkgs.system}.claude-desktop

    killall
    signal-desktop
    inputs.zen-browser.packages.${pkgs.system}.default
  ] ++ (import ./niri-dependencies.nix { inherit pkgs; });

  home.sessionVariables = {
    DOTNET_ROOT = "${pkgs.dotnet-sdk_10}/share/dotnet";
    PNPM_HOME = "${config.home.homeDirectory}/.local/share/pnpm";
    LIBVIRT_DEFAULT_URI = "qemu:///system";
    OLLAMA_MODELS = "${config.home.homeDirectory}/.ollama_models";
    PYTHON_KEYRING_BACKEND = "keyring.backends.null.Keyring";
  };

  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin"
    "${config.home.homeDirectory}/.omp/bin"
    "${config.home.homeDirectory}/.local/share/pnpm"
  ];

  programs.home-manager.enable = true;

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      function fish_greeting
          # Wait dynamically for Niri's Wayland configure event to update PTY dimensions
          set -l timer 0
          while test $COLUMNS -le 80; and test $timer -lt 20
              sleep 0.01
              set timer (math $timer + 1)
          end
      end

      # XDG Session ID Fallback
      if not set -q XDG_SESSION_ID
          set -l sid (cat /proc/self/sessionid 2>/dev/null)
          if test -n "$sid"; and test "$sid" != 4294967295
              set -gx XDG_SESSION_ID "$sid"
          end
      end
    '';
    functions.theme = {
      description = "Switch kitty palette; fastfetch follows terminal colors";
      body = ''
        set -l dir $HOME/.config/kitty/themes
        set -l rofi_dir $HOME/.config/rofi/themes
        if test (count $argv) -eq 0; or contains -- $argv[1] list ls -l --list
          echo "themes:"
          for f in $dir/*.conf
            basename $f .conf
          end | sort
          return 0
        end
        set -l name $argv[1]
        set -l src $dir/$name.conf
        if not test -f $src
          echo "unknown theme: $name (try: theme list)"
          return 1
        end
        cp $src $HOME/.config/kitty/current-theme.conf
        if set -q KITTY_WINDOW_ID
          kitten @ set-colors --all --configured $src
        end
        if test -f $rofi_dir/$name.rasi
          printf '@import "themes/%s"\n' $name > $HOME/.config/rofi/current-theme.rasi
        end
        echo $name
      '';
    };
    shellAliases = {
      t = "clear; and printf '\\e[3J'; and fastfetch";
      f = "clear; and printf '\\e[3J'";
      clear = "command clear; and printf '\\e[3J'";
      nord = "nordvpn";
      nords = "nordvpn status";
      fast = "fastfetch";
      rwaybar = "killall waybar; and waybar &; disown";
      ipa = "ip address";
      pdf = "zathura";
      refresh = "/home/os/.bin/refresh.sh";
      lsa = "ls -a";
      gitPrace = "git add . && git commit -m \"idfk\" && git pull && git push";
      packettracer = "env LIBGL_ALWAYS_SOFTWARE=1 QT_QPA_PLATFORM=xcb /usr/lib/packettracer/packettracer.AppImage --no-sandbox";
      logisim-evolution = "env GDK_BACKEND=x11 _JAVA_AWT_WM_NONREPARENTING=1 command logisim-evolution";
      davinci = "env QT_QPA_PLATFORM=xcb /opt/resolve/bin/resolve";
    };
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.git = {
    enable = true;
    settings = {
      user.name = "sobcak";
      user.email = "oliver.sobcak@proton.me";
      safe.directory = "/etc/nixos";
    };
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };

  # Managed configs (edit under ./dotfiles/)
  xdg.configFile = {
    "niri/config.kdl".text = withCursorSize ./dotfiles/niri/config.kdl;
    "waybar/config.jsonc".source = ./dotfiles/waybar/config.jsonc;
    "waybar/style.css".source = ./dotfiles/waybar/style.css;

    "kitty/kitty.conf".source = ./dotfiles/kitty/kitty.conf;
    "kitty/themes" = {
      source = ./dotfiles/kitty/themes;
      recursive = true;
    };
    "hypr/hyprlock.conf".source = ./dotfiles/hypr/hyprlock.conf;
    "sunsetr/sunsetr.toml".source = ./dotfiles/sunsetr/sunsetr.toml;
    "fastfetch/config.jsonc".source = ./dotfiles/fastfetch/config.jsonc;
    "swaync/style.css".source = ./dotfiles/swaync/style.css;
    "gtk-3.0/settings.ini".text = withCursorSize ./dotfiles/gtk-3.0/settings.ini;
    "gtk-4.0/settings.ini".text = withCursorSize ./dotfiles/gtk-4.0/settings.ini;
    "btop/btop.conf".source = ./dotfiles/btop/btop.conf;
    "btop/themes/void.theme".source = ./dotfiles/btop/themes/void.theme;
    "cava/config".source = ./dotfiles/cava/config;
    "rofi/config.rasi".source = ./dotfiles/rofi/config.rasi;
    "rofi/themes" = {
      source = ./dotfiles/rofi/themes;
      recursive = true;
    };
    "nvim".source = ./dotfiles/nvim;
    "VSCodium/User/settings.json".source = ./dotfiles/vscodium/settings.json;

    # NixOS has no /usr/share; point at the qt6ct package color scheme
    "qt6ct/qt6ct.conf".text = ''
      [Appearance]
      color_scheme_path=${pkgs.qt6Packages.qt6ct}/share/qt6ct/colors/darker.conf
      custom_palette=true
      standard_dialogs=default
      style=Fusion

      [Fonts]
      fixed="Noto Sans,12,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
      general="Noto Sans,12,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"

      [Interface]
      activate_item_on_single_click=1
      buttonbox_layout=0
      cursor_flash_time=1000
      dialog_buttons_have_icons=1
      double_click_interval=400
      gui_effects=@Invalid()
      keyboard_scheme=2
      menus_have_icons=true
      show_shortcuts_in_context_menus=true
      stylesheets=@Invalid()
      toolbutton_style=4
      underline_shortcut=1
      wheel_scroll_lines=3

      [Troubleshooting]
      force_raster_widgets=1
      ignored_applications=@Invalid()
    '';
  };

  # Writable palette file (not HM-managed) so `theme` can switch without rebuild
  home.activation.kittyCurrentTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "${config.home.homeDirectory}/.config/kitty"
    if [ ! -e "${config.home.homeDirectory}/.config/kitty/current-theme.conf" ]; then
      cp ${./dotfiles/kitty/themes/void.conf} "${config.home.homeDirectory}/.config/kitty/current-theme.conf"
      chmod u+w "${config.home.homeDirectory}/.config/kitty/current-theme.conf"
    fi
  '';

  # Same trick for rofi: one writable line selecting the active theme
  home.activation.rofiCurrentTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "${config.home.homeDirectory}/.config/rofi"
    if [ ! -e "${config.home.homeDirectory}/.config/rofi/current-theme.rasi" ]; then
      echo '@import "themes/void"' > "${config.home.homeDirectory}/.config/rofi/current-theme.rasi"
    fi
  '';
}

{ config, lib, pkgs, inputs, ... }:

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

    firefox
    audacity
    legcord
    mapscii
    unzip

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

  # Managed copies of compositor / bar configs (edit under ./dotfiles/)
  xdg.configFile."niri/config.kdl".source = ./dotfiles/niri/config.kdl;
  xdg.configFile."waybar/config.jsonc".source = ./dotfiles/waybar/config.jsonc;
  xdg.configFile."waybar/style.css".source = ./dotfiles/waybar/style.css;
}

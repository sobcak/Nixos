# Shared configuration for every host. Host-specific quirks (hardware,
# kernel choice, per-machine services) live in ../hosts/<name>/default.nix.
{ config, pkgs, inputs, ... }:

{
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Prague";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "cs_CZ.UTF-8";
    LC_IDENTIFICATION = "cs_CZ.UTF-8";
    LC_MEASUREMENT = "cs_CZ.UTF-8";
    LC_MONETARY = "cs_CZ.UTF-8";
    LC_NAME = "cs_CZ.UTF-8";
    LC_NUMERIC = "cs_CZ.UTF-8";
    LC_PAPER = "cs_CZ.UTF-8";
    LC_TELEPHONE = "cs_CZ.UTF-8";
    LC_TIME = "cs_CZ.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "cz";
    variant = "";
  };

  console.useXkbConfig = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."oliver" = {
    isNormalUser = true;
    description = "oliver";
    extraGroups = [ "networkmanager" "wheel" "input" "nordvpn" "docker" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List services that you want to enable:
  programs.niri.enable = true;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri-session";
        user = "greeter";
      };
    };
  };

  services.flatpak.enable = true;

  virtualisation.docker.enable = true;

  # System / session packages only — user apps live in home.nix
  environment.systemPackages = with pkgs; [
    tuigreet
    util-linux
    flatpak
    fuse2 # for AppImages
    appimage-run
    bluez
    # Polkit agent for niri session (spawned from niri config)
    polkit_gnome
    (writeShellScriptBin "polkit-gnome-authentication-agent-1" ''
      exec ${polkit_gnome}/libexec/polkit-gnome-authentication-agent-1 "$@"
    '')
  ];

  programs.fish.enable = true;
  users.users.oliver.shell = pkgs.fish;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  security.rtkit.enable = true;
  services.pulseaudio.enable = false;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    # Certain features, including CLI integration and system authentication support,
    # require enabling PolKit integration on some desktop environments (e.g. Plasma).
    polkitPolicyOwners = [ "oliver" ];
  };

  fonts.packages = with pkgs; [
    iosevka
    nerd-fonts.symbols-only
    nerd-fonts.iosevka
    lexend
  ];

  # Load the uinput kernel module
  boot.kernelModules = [ "uinput" ];

  # Grant access to /dev/uinput for the input group
  services.udev.extraRules = ''
    KERNEL=="uinput", SUBSYSTEM=="misc", OPTIONS+="static_node=uinput", TAG+="uaccess", GROUP="input", MODE="0660"
  '';

  programs.localsend = {
    enable = true;
    openFirewall = true; # opens the ports LocalSend needs
  };

  programs.steam.enable = true;
  hardware.graphics.enable32Bit = true;

  services.nordvpn.enable = true;
  services.usbmuxd.enable = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  zramSwap.enable = true;

  services.blueman.enable = true;
}

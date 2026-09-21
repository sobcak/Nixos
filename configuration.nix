# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.luks.devices."luks-5221701f-290b-4896-ab15-14264b1e5b5d".device = "/dev/disk/by-uuid/5221701f-290b-4896-ab15-14264b1e5b5d";
  networking.hostName = "olinux"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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

  # Configure console keymap
 # console.keyMap = "cz-lat2";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."oliver" = {
    isNormalUser = true;
    description = "oliver";
    extraGroups = [ "networkmanager" "wheel" "input" "nordvpn" "docker" ];
    packages = with pkgs; [];
  };



  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  # environment.systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  # ];


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

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

environment.systemPackages = with pkgs; [
	kitty
	tuigreet
	neovim
	util-linux
	waybar
	git
	sunsetr
	rofi
	
	fish
	fastfetch
	starship
	btop
	cmatrix
	cava

	polkit_gnome
	wl-clipboard
	xwayland-satellite


  burpsuite
  caido-desktop

	firefox
	audacity
	pkgs.legcord
  tlp 
 mapscii
  pavucontrol

  unzip

  clang
  gcc
  tree-sitter # Nix-built CLI; Mason's generic linux binary cannot run on NixOS
  pyright # Mason installs this via npm, which is not on PATH
  nodejs # so remaining Mason npm packages (docker LS, markdownlint) can install
  dotnet-sdk_10

  pkgs.gh
	vscodium
	code-cursor
	inputs.claude-desktop.packages.${pkgs.system}.claude-desktop

  killall
	swaynotificationcenter
	cliphist
	hyprlock
	hyprshot
	grim
	slurp
	playerctl
	brightnessctl
	wl-mirror
	jq
	pkgs.signal-desktop
	pkgs.flatpak
	pkgs.libsForQt5.qt5ct
	pkgs.qt6Packages.qt6ct
	inputs.zen-browser.packages.${pkgs.system}.default
	
	#libraries
	fuse2 #na appimages ig
	
	#nix věc
	appimage-run

	
] ++ (import ./niri-dependencies.nix { inherit pkgs; });

environment.sessionVariables = {
  DOTNET_ROOT = "${pkgs.dotnet-sdk_10}/share/dotnet";
};



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




services.fprintd.enable = true;
security.pam.services.greetd.fprintAuth = true;

services.keyd = {
  enable = true;
  keyboards.default = {
    ids = [ "*" ];
    settings.main = {
      f23 = "leftmeta";
    };
  };
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
];




# Load the uinput kernel module
  boot.kernelModules = [ "uinput" ];

  # Grant access to /dev/uinput for the input group
  services.udev.extraRules = ''
    KERNEL=="uinput", SUBSYSTEM=="misc", OPTIONS+="static_node=uinput", TAG+="uaccess", GROUP="input", MODE="0660"
  '';

  # Add your user to the input group (replace "oliver" with your actual username if different)






  programs.localsend = {
    enable = true;
    openFirewall = true;   # opens the ports LocalSend needs
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












# Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

}

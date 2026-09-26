# Host-specific quirks for "olinux-desktop" (NVIDIA desktop, LTS kernel).
# Shared config lives in ../../modules/common.nix.
{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "olinux-desktop";

  # LTS kernel (required for this NVIDIA setup), still sourced from the
  # same nixos-unstable nixpkgs input as the rest of the flake.
  boot.kernelPackages = pkgs.linuxPackages;

  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false; # desktop; no suspend/resume to worry about
    open = true; # Turing or newer
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. Do NOT change this value after the initial
  # install, for any reason, even if you've upgraded your system to a new
  # NixOS release. See `man configuration.nix` or
  # https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion.
  system.stateVersion = "26.05";
}

# Host-specific quirks for "olinux" (ThinkPad). Shared config lives in
# ../../modules/common.nix.
{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "olinux";

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  environment.systemPackages = with pkgs; [
    tlp
  ];

  services.tlp.enable = true;

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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. Do NOT change this value after the initial
  # install, for any reason, even if you've upgraded your system to a new
  # NixOS release. See `man configuration.nix` or
  # https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion.
  system.stateVersion = "26.05";
}

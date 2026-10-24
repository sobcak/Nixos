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

  services.tlp = {
    enable = true;
    settings = {
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 90;
    };
  };

  services.fprintd.enable = true;
  security.pam.services.greetd.fprintAuth = true;

  # Copilot key is firmware Meta+Shift+F23 — not a single scancode, so
  # udev/hwdb can't remap it. keyd intercepts at evdev (lowest practical layer).
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings.main = {
        "leftmeta+leftshift+f23" = "leftmeta";
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

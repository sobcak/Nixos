# PLACEHOLDER — replace this entire file with the output of
# `nixos-generate-config` run on the desktop itself, then commit it.
# Do not attempt to switch to the olinux-desktop configuration until
# this file has been replaced with real hardware values (filesystems,
# LUKS UUIDs if used, CPU microcode, initrd modules, etc.).
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ]; # TODO: "kvm-amd" if the desktop CPU is AMD
  boot.extraModulePackages = [ ];

  # TODO: replace with the real root filesystem from the installer.
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/00000000-0000-0000-0000-000000000000";
      fsType = "ext4";
    };

  # TODO: replace with the real /boot filesystem from the installer.
  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/0000-0000";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware; # TODO: swap to hardware.cpu.amd.updateMicrocode if AMD
}

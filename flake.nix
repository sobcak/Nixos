{
  description = "System config for olinux";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser.url = "github:youwen5/zen-browser-flake";
    grok-bot = {
      url = "github:jordangarrison/grok-bot-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Upstream PR #80 flake; github: URL drops nested submodules — use git+submodules=1.
    xrlinuxdriver.url = "git+https://github.com/shymega/XRLinuxDriver?ref=shymega/nix-flake-support&submodules=1";
    # Native Wallpaper Engine runtime for Wayland (layer-shell / niri).
    we-layerd.url = "github:Aromatic05/we-layerd";
  };

  outputs = { self, nixpkgs, home-manager, xrlinuxdriver, we-layerd, ... }@inputs:
    let
      mkHost = host: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; }; # Passes inputs into your modules
        modules = [
          ./modules/common.nix
          ./hosts/${host}
          xrlinuxdriver.nixosModules.default
          we-layerd.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.backupFileExtension = "hm-backup";
            home-manager.users.oliver = import ./home.nix;
          }
        ];
      };
    in {
      nixosConfigurations = {
        olinux = mkHost "olinux";
        olinux-desktop = mkHost "olinux-desktop";
      };
    };
}

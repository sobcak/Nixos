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
    # Renderer override: MDLV0023 + LightingV1 + getManualScale fixes
    # (fork sobcak/wallpaper-engine-renderer @ fix/mdl-v23-static-model-objects).
    we-layerd = {
      url = "github:Aromatic05/we-layerd";
      # Must follow system nixpkgs: otherwise vulkan-loader links old glibc and
      # cannot dlopen /run/opengl-driver Mesa (GLIBC_2.44 / VK_ERROR_INCOMPATIBLE_DRIVER).
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.renderer = {
        url = "github:sobcak/wallpaper-engine-renderer/504de989f90ae6f630e82a1f4b233db67b0c05a4";
        flake = false;
      };
    };
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

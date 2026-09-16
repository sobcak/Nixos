{
  description = "System config for olinux";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    zen-browser.url = "github:youwen5/zen-browser-flake";
    claude-desktop.url = "github:briossant/claude-desktop-nix";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.olinux = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; }; # Passes inputs into your modules
      modules = [
        ./configuration.nix
      ];
    };
  };
}

{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, nixpkgs-master, ... }:
    let
      system = "x86_64-linux";
    in {
    nixosConfigurations = {
      "roz-pc" = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = inputs;
        modules = [ 
          (import ./overlay.nix { inherit inputs system; })
          ./configuration.nix
        ];
      };
    };
  };
}

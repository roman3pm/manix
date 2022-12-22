{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = attrs@{ nixpkgs, nixpkgs-master, ... }:
    let
      system = "x86_64-linux";
      overlay-master = final: prev: {
        master = import nixpkgs-master {
          inherit system;
          config.allowUnfree = true;
        };
      };
    in {
    nixosConfigurations = {
      "roz-pc" = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = attrs;
        modules = [ 
          ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-master ]; })
          ./configuration.nix
        ];
      };
    };
  };
}

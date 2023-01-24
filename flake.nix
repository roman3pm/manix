{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-master, home-manager, nix-index-database, ... }:
    let
      system = "x86_64-linux";
      overlays = import ./overlays.nix inputs system;
    in {
      nixosModules = {
        devices = import ./modules/devices.nix;
      };
      nixosProfiles = {
        sway = import ./profiles/sway.nix;
        waybar = import ./profiles/waybar.nix;
        terminal = import ./profiles/terminal.nix;
        neovim = import ./profiles/neovim.nix;
        git = import ./profiles/git.nix;
        mako = import ./profiles/mako.nix;
        mangohud = import ./profiles/mangohud.nix;
      };
      nixosConfigurations = with nixpkgs.lib;
        let
          hosts = builtins.attrNames (builtins.readDir ./machines);
          mkHost = name:
            nixosSystem {
              inherit system;
              specialArgs = { inherit inputs; };
              modules = [
                (import (./machines + "/${name}"))
                ./configuration.nix
                { device = name; }
                {
                  nixpkgs = {
                    overlays = [ overlays ];
                    config.allowUnfree = true;
                  };
                }
                home-manager.nixosModules.home-manager
                {
                  home-manager = {
                    useGlobalPkgs = true;
                    useUserPackages = true;
                    users.roz = import ./home.nix;
                    sharedModules = [
                      nix-index-database.hmModules.nix-index
                    ];
                  };
                }
              ];
            };
        in genAttrs hosts mkHost;
    };
}

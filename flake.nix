{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-22.11";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/NUR";
    agenix.url = "github:ryantm/agenix";
  };

  outputs = inputs@{ nixpkgs, ... }:
    let
      system = "x86_64-linux";
      overlays = [
        (import ./overlays.nix inputs system)
        inputs.nur.overlay
      ];
    in
    {
      nixosModules = {
        devices = import ./modules/devices.nix;
      };
      nixosProfiles = {
        sway = import ./profiles/sway.nix;
        waybar = import ./profiles/waybar.nix;
        terminal = import ./profiles/terminal.nix;
        neovim = import ./profiles/neovim.nix;
        git = import ./profiles/git.nix;
        firefox = import ./profiles/firefox.nix;
        utils = import ./profiles/utils.nix;
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
                    overlays = overlays;
                    config.allowUnfree = true;
                  };
                }
                inputs.home-manager.nixosModules.home-manager
                {
                  home-manager = {
                    useGlobalPkgs = true;
                    useUserPackages = true;
                    users.roz = import ./home.nix;
                    sharedModules = [
                      inputs.nix-index-database.hmModules.nix-index
                    ];
                  };
                }
                inputs.agenix.nixosModules.default
              ];
            };
        in
        genAttrs hosts mkHost;
    };
}

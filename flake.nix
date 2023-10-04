{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";
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
            nixosSystem rec {
              inherit system;
              specialArgs = { inherit inputs; };
              modules = [
                inputs.agenix.nixosModules.default
                {
                  nixpkgs = {
                    overlays = overlays;
                    config.allowUnfree = true;
                  };
                }
                ./configuration.nix
                { device = name; }
                (import (./machines + "/${name}"))
                inputs.home-manager.nixosModules.home-manager
                {
                  home-manager = {
                    useGlobalPkgs = true;
                    useUserPackages = true;
                    users.roz = import ./home.nix;
                    extraSpecialArgs = specialArgs;
                  };
                }
              ];
            };
        in
        genAttrs hosts mkHost;
    };
}

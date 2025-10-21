{ inputs, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    inputs.self.nixosRoles.laptop
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-6th-gen
  ];

  devices = {
    interface = "wlp2s0";
    monitor1 = "eDP-1";
    monitor2 = "HDMI-A-1";
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;
}

{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    inputs.self.nixosRoles.desktop
  ];

  devices = {
    interface = "wlp2s0";
    monitor1 = "eDP-1";
    monitor2 = "HDMI-A-1";
  };

  hardware = {
    graphics.extraPackages = with pkgs; [ intel-media-driver ];
  };

  services.throttled.enable = true;

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}

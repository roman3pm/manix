{ inputs, pkgs, lib, ... }: {
  imports = [
    ./hardware-configuration.nix
    inputs.self.nixosRoles.desktop
  ];

  hardware = {
    graphics.extraPackages = with pkgs; [ intel-media-driver ];
  };

  services.throttled.enable = true;

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}

{ inputs, pkgs, lib, ... }: {
  imports = with inputs.self.nixosModules; with inputs.self.nixosProfiles; [
    ./hardware-configuration.nix

    devices

    sway
    waybar
    terminal
    neovim
    git
    firefox
    utils
  ];

  hardware = {
    opengl.extraPackages = with pkgs; [
      intel-media-driver
    ];
  };

  services.throttled.enable = true;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}

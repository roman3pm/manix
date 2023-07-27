{ inputs, pkgs, ... }: {
  imports = with inputs.self.nixosModules; with inputs.self.nixosProfiles; [
    ./hardware-configuration.nix

    devices

    sway
    waybar
    terminal
    neovim
    git
    mako
    firefox
    mangohud
  ];

  services.throttled.enable = true;

  hardware = {
    opengl.extraPackages = with pkgs; [
      intel-media-driver
    ];
  };

  deviceSpecific = {
    audio = {
      sink = "alsa_output.pci-0000_00_1f.3.analog-stereo";
      source = "alsa_input.pci-0000_00_1f.3.analog-stereo";
    };
  };
}

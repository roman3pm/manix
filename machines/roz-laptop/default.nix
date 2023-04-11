{ inputs, pkgs, config, ... }:
let
  crypt = import ../../secrets/crypt.nix;
in {
  imports = with inputs.self.nixosModules; with inputs.self.nixosProfiles; [
    ./hardware-configuration.nix

    devices

    sway
    waybar
    terminal
    neovim
    git
    mako
    mangohud
  ];

  age.secrets = {
    "secrets/wg0-privateKey".file = ../../secrets/wg0-privateKey.age;
    "secrets/wg1-privateKey".file = ../../secrets/wg1-privateKey.age;
  };

  networking.wg-quick.interfaces = {
    wg0 = {
      autostart = false;
      address = [ "10.0.0.6/24" "fdc9:281f:04d7:9ee9::6/64" ];
      dns = [ "10.0.0.1" "fdc9:281f:04d7:9ee9::1" ];
      privateKeyFile = config.age.secrets."secrets/wg0-privateKey".path;
      peers = [
        {
          publicKey = crypt.wg0-publicKey;
          allowedIPs = [ "0.0.0.0/0" "::/0" ];
          endpoint = crypt.wg0-endpoint;
          persistentKeepalive = 25;
        }
      ];
    };
    wg1 = {
      autostart = false;
      address = [ "10.129.0.26/32" ];
      dns = [ "8.8.8.8" ];
      privateKeyFile = config.age.secrets."secrets/wg1-privateKey".path;
      peers = [
        {
          publicKey = crypt.wg1-publicKey;
          allowedIPs = [ "10.129.0.1/32" "0.0.0.0/0" ];
          endpoint = crypt.wg1-endpoint;
          persistentKeepalive = 25;
        }
      ];
    };
  };

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

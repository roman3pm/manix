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

  boot.initrd.kernelModules = [ "amdgpu" ];

  networking.wg-quick.interfaces = {
    wg0 = {
      autostart = false;
      address = [ "10.0.0.2/24" "fdc9:281f:04d7:9ee9::2/64" ];
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

  services.udev.packages = [
    (pkgs.writeTextFile {
      name = "via_udev";
      text = ''
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0666", TAG+="uaccess", TAG+="udev-acl"
      '';
      destination = "/etc/udev/rules.d/92-viia.rules";
    })
  ];

  deviceSpecific = {
    audio = {
      sink = "alsa_output.usb-Burr-Brown_from_TI_USB_Audio_CODEC-00.analog-stereo-output";
      source = "alsa_input.usb-Burr-Brown_from_TI_USB_Audio_CODEC-00.analog-stereo-input";
    };
  };
}

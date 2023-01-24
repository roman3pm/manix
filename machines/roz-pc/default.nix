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
    mangohud
  ];

  boot.initrd.kernelModules = [ "amdgpu" ];

  networking.wg-quick.interfaces = {
    wg0 = {
      autostart = false;
      address = [ "10.0.0.2/24" "fdc9:281f:04d7:9ee9::2/64" ];
      dns = [ "10.0.0.1" "fdc9:281f:04d7:9ee9::1" ];
      privateKeyFile = "/home/roz/.secret/wireguard-keys/private";
      peers = [
        {
          publicKey = "Z53ZnS7k8/k2hFIe6FWfaWrX6d/og1VdAvTIIpcvsyY=";
          allowedIPs = [ "0.0.0.0/0" "::/0" ];
          endpoint = "172.104.156.229:51820";
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

  environment.sessionVariables = rec {
    AMD_VULKAN_ICD = "RADV";
  };

  deviceSpecific = {
    audio = {
      sink = "alsa_output.usb-Burr-Brown_from_TI_USB_Audio_CODEC-00.analog-stereo-output";
      source = "alsa_input.usb-Burr-Brown_from_TI_USB_Audio_CODEC-00.analog-stereo-input";
    };
  };
}

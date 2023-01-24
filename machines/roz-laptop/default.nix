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

  networking.wg-quick.interfaces = {
    wg0 = {
      autostart = false;
      address = [ "10.0.0.6/24" "fdc9:281f:04d7:9ee9::6/64" ];
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

  services.throttled.enable = true;

  deviceSpecific = {
    audio = {
      sink = "alsa_output.pci-0000_00_1f.3.analog-stereo";
      source = "alsa_input.pci-0000_00_1f.3.analog-stereo";
    };
  };
}

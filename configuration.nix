{ config, pkgs, ... }:
let
  crypt = import ./secrets/crypt.nix;
in
{
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_zen;
    kernelModules = [
      "v4l2loopback"
      "hid-apple"
    ];
    extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback.out ];
    extraModprobeConfig = ''
      options v4l2loopback exclusive_caps=1 card_label="Virtual Camera"
      options hid_apple fnmode=2
    '';
  };

  virtualisation.docker.enable = true;

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  age.secrets = {
    "secrets/wg0-privateKey".file = ./secrets/wg0-privateKey.age;
  };

  networking = {
    hostName = config.device;
    networkmanager.enable = true;
    wg-quick.interfaces = {
      wg0 = {
        autostart = false;
        address = [
          "10.9.8.91/16"
          "fd42:42:42:42::85b/104"
        ];
        dns = [ "10.9.0.1" ];
        privateKeyFile = config.age.secrets."secrets/wg0-privateKey".path;
        peers = [
          {
            publicKey = crypt.wg0-publicKey;
            allowedIPs = crypt.wg0-allowedIPs;
            endpoint = crypt.wg0-endpoint;
            persistentKeepalive = 25;
          }
        ];
      };
    };
  };

  users = {
    groups.plugdev = { };
    users.roz = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "storage"
        "networkmanager"
        "input"
        "video"
        "audio"
        "docker"
        "plugdev"
      ];
      shell = pkgs.fish;
    };
  };

  hardware = {
    graphics.enable = true;
    bluetooth.enable = true;
    steam-hardware.enable = true;
    xpadneo.enable = true;
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
    ];
  };

  time.timeZone = "Europe/Moscow";

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  programs = {
    fish.enable = true;
    dconf.enable = true;
    ssh.startAgent = true;
    gnupg.agent.enable = true;
    steam.enable = true;
  };

  services = {
    openssh = {
      enable = true;
      settings.PermitRootLogin = "no";
    };
    dbus.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
    };
    mpd.enable = true;
    printing.enable = true;
  };

  system.stateVersion = "24.05";
}

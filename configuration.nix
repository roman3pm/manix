{ config, pkgs, ... }:
let
  crypt = import ./secrets/crypt.nix;
in
{
  boot = {
    loader = {
      timeout = 0;
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_zen;
    kernelModules = [ "v4l2loopback" ];
    extraModulePackages = with config.boot.kernelPackages; [
      v4l2loopback.out
    ];
    extraModprobeConfig = ''
      options v4l2loopback exclusive_caps=1 card_label="Virtual Camera"
    '';
  };

  virtualisation.docker.enable = true;

  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  age.secrets = {
    "secrets/wg0-privateKey".file = ./secrets/wg0-privateKey.age;
    "secrets/wg1-privateKey".file = ./secrets/wg1-privateKey.age;
  };

  networking = {
    hostName = config.device;
    networkmanager.enable = true;
    wg-quick.interfaces = {
      wg0 = {
        autostart = false;
        address = [ "10.9.52.7/16" "fd42:42:42:42::3407/104" ];
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
      wg1 = {
        autostart = true;
        address = [ "10.129.0.26/32" ];
        dns = [ "8.8.8.8" ];
        privateKeyFile = config.age.secrets."secrets/wg1-privateKey".path;
        peers = [
          {
            publicKey = crypt.wg1-publicKey;
            allowedIPs = crypt.wg1-allowedIPs;
            endpoint = crypt.wg1-endpoint;
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
      extraGroups = [ "wheel" "docker" "networkmanager" "input" "video" "audio" "plugdev" "corectrl" ];
      shell = pkgs.fish;
    };
  };

  hardware = {
    bluetooth = {
      enable = true;
      disabledPlugins = [ "sap" ];
    };
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
    steam-hardware.enable = true;
    xpadneo.enable = true;
  };

  xdg = {
    portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
    };
  };

  fonts.enableDefaultFonts = true;

  time.timeZone = "Europe/Moscow";

  security = {
    pam.services = {
      swaylock.text = "auth include login";
    };
    polkit.enable = true;
    rtkit.enable = true;
  };

  programs = {
    fish.enable = true;
    corectrl.enable = true;
    dconf.enable = true;
    ssh.startAgent = true;
    gnupg.agent.enable = true;
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

  system.stateVersion = "23.05";
}


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
    kernelPackages = pkgs.linuxPackages_latest;
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
    hostName = config.hostName;
    networkmanager.enable = true;
    wg-quick.interfaces = {
      wg0 =
        let
          listenPort = 51820;
        in
        {
          inherit listenPort;
          autostart = false;
          preUp = "${pkgs.nmap}/bin/nping --udp --count 1 --data-length 16 --source-port ${builtins.toString listenPort} --dest-port ${builtins.toString crypt.wg0.port} ${crypt.wg0.host}";
          address = [
            "10.9.8.91/16"
            "fd42:42:42:42::85b/104"
          ];
          dns = [ "10.9.0.1" ];
          privateKeyFile = config.age.secrets."secrets/wg0-privateKey".path;
          peers = [ crypt.wg0.peer ];
        };
    };
  };

  services.openvpn.servers = {
    ds = {
      autoStart = false;
      config = ''config /home/roz/.secret/DS.ovpn'';
      updateResolvConf = true;
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
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    bluetooth.enable = true;
    xpadneo.enable = true;
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerd-fonts.dejavu-sans-mono
      wqy_zenhei
    ];
    fontconfig.defaultFonts.monospace = [ "DejaVuSansM Nerd Font Mono" ];
  };

  time.timeZone = "Europe/Moscow";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
  };

  services = {
    openssh = {
      enable = true;
      settings.PermitRootLogin = "no";
    };
    dbus.enable = true;
    v2raya.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
    };
    mpd.enable = true;
    udisks2.enable = true;
    printing.enable = true;
  };

  programs = {
    fish.enable = true;
    dconf.enable = true;
    ssh.startAgent = true;
    gnupg.agent.enable = true;
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  system.stateVersion = "24.05";
}

{ config, lib, pkgs, ... }: {

  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      grub = {
        device = "/dev/nvme0n1";
        useOSProber = true;
      };
    };
    initrd.kernelModules = [ "amdgpu" "wl" ];
    kernelPackages = pkgs.linuxPackages_latest;
  };
  
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "steam"
      "steam-original"
      "steam-runtime"
    ];
  };

  networking = {
    hostName = "roz-pc";
    wireless = {
      enable = true;
      networks = {
        MGTS-GPON5-366B = { psk = ""; };
      };
    };
  };

  networking.wg-quick.interfaces = {
    wg0 = {
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

  users = {
    groups.plugdev = {};
    users.roz = {
      isNormalUser = true;
      extraGroups = [ "wheel" "plugdev" "audio" ];
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
      extraPackages = with pkgs; [
        rocm-opencl-icd
        rocm-opencl-runtime
      ];
    };
    openrazer = { 
      enable = true;
      users = [ "roz" ];
    };
    xpadneo.enable = true;
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
      gtkUsePortal = true;
    };
  };

  time.timeZone = "Europe/Moscow";
  fonts.enableDefaultFonts = true;

  security.pam.services.swaylock = {
    text = ''
        auth include login
    '';
  };

  programs = {
    dconf.enable = true;
    ssh.startAgent = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
  };

  services = {
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
    };
    mpd.enable = true;
    printing.enable = true;
    udev.packages = [
      (pkgs.writeTextFile {
        name = "via_udev";
        text = ''
          KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0666", TAG+="uaccess", TAG+="udev-acl"
        '';
        destination = "/etc/udev/rules.d/92-viia.rules";
      })
    ];
  };

  systemd.services = let
    inherit (lib.attrsets) nameValuePair;
    inherit (builtins) listToAttrs;

    openvpnDir = "/home/roz/.secret/openvpn";
    username = "roz@exante.eu";
    hosts = [ "mickey" "gensec" ];

    getVpnService = with pkgs; (host: nameValuePair "openvpn-${host}" {
      description = "OpenVPN instance ‘${host}’";
      after = [ "network.target" ];
      wantedBy = [ "network-online.target" ];
      path = [ bash openvpn oathToolkit ];
      serviceConfig = {
        Type = "notify";
        Restart = "always";
        ExecStartPre = ''
          ${bash}/bin/bash -c 'password="''$(${oathToolkit}/bin/oathtool -b --totp @${openvpnDir}/${host}_totp)"; echo "${username}" > ${openvpnDir}/${host}_oath; echo ''$password >> ${openvpnDir}/${host}_oath'
        '';
        ExecStart = ''
          @${openvpn}/sbin/openvpn openvpn --suppress-timestamps --config ${openvpnDir}/${host}.ovpn --auth-user-pass ${openvpnDir}/${host}_oath
        '';
      };
    });
  in listToAttrs (map getVpnService hosts);

  system.stateVersion = "22.05";

}


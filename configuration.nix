{ config, lib, pkgs, home-manager, ... }: {
  imports = [
    ./hardware-configuration.nix
    home-manager.nixosModule
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd.kernelModules = [ "amdgpu" ];
    kernelPackages = pkgs.linuxPackages_zen;
  };
  
  nix = {
    package = pkgs.nixVersions.stable;
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
    settings.auto-optimise-store = true;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.roz = import ./home.nix;
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  networking = {
    hostName = "roz-pc";
    wireless = {
      enable = true;
      networks = {
        MGTS-GPON5-366B = { psk = "DPRT4669"; };
      };
    };
  };

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

  users = {
    groups.plugdev = {};
    users.roz = {
      isNormalUser = true;
      extraGroups = [ "corectrl" "wheel" "plugdev" "video" "audio" ];
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
        amdvlk
        rocm-opencl-icd
        rocm-opencl-runtime
      ];
    };
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

  time.timeZone = "Europe/Moscow";
  fonts.enableDefaultFonts = true;

  security = {
    pam.services = {
      swaylock.text = "auth include login";
    };
    polkit.enable = true;
    rtkit.enable = true;
  };

  programs = {
    corectrl.enable = true;
    dconf.enable = true;
    ssh.startAgent = true;
  };

  services = {
    dbus.enable = true;
    pipewire = {
      enable = true;
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
      wantedBy = [ "multi-user.target" ];
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

  environment.sessionVariables = rec {
    AMD_VULKAN_ICD = "RADV";
  };

  system.stateVersion = "23.05";
}


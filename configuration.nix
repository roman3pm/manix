{ config, lib, pkgs, ... }: {
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_zen;
    extraModulePackages = with config.boot.kernelPackages; [
      v4l2loopback
    ];
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

  networking = {
    hostName = config.device;
    networkmanager.enable = true;
  };

  users = {
    groups.plugdev = {};
    users.roz = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "video" "audio" "plugdev" "corectrl" ];
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
      extraPackages = with pkgs; [
        amdvlk
        intel-media-driver
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
    fish.enable = true;
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

  system.stateVersion = "23.05";
}


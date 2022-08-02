{ config, pkgs, lib, ... }:
let
  colors = import ./colors.nix;
in {
  imports = [
    ./sway.nix
    ./terminal.nix
    ./git.nix
    ./mako.nix
    ./neovim.nix
    ./waybar.nix
    ./mangohud.nix
  ];

  programs.home-manager.enable = true;

  home.username = "roz";
  home.homeDirectory = "/home/roz";

  home.packages = with pkgs; [
    slurp
    grim
    imv
    mpv
    htop
    neofetch
    thefuck
    ripgrep
    fd
    fzf
    jq
    wireguard-tools
    wget
    steam-run

    jre8
    jdk8
    gcc 
    yarn
    nodejs-14_x
    rust-analyzer
    sumneko-lua-language-server
    (sbt.override { jre = jre8; })
    (maven.override { jdk = jdk8; })
    (bloop.override { jre = jre8; })
    (metals.override { jre = jre8; })
    (coursier.override { jre = jre8; })

    via
    razergenie
    firefox-wayland
    thunderbird-wayland
    tdesktop
    slack
    discord
#    (discord.overrideAttrs (old: rec {
#      version = "0.0.18";
#      src = fetchurl {
#        url = "https://dl.discordapp.net/apps/linux/${version}/discord-${version}.tar.gz";
#        sha256 = "BBc4n6Q3xuBE13JS3gz/6EcwdOWW57NLp2saOlwOgMI=";
#      };
#    }))
    bitwarden
    lutris
    gamemode
    libreoffice-fresh

    swaylock
    swayidle
    libnotify
    wl-clipboard
    brightnessctl
    gammastep
    pavucontrol
    bemenu
    nerdfonts
    glib
    quintom-cursor-theme
    xdg_utils
    qt5.qtwayland
    libsForQt5.qtstyleplugins
    gruvbox-dark-gtk
    gruvbox-dark-icons-gtk
  ];

  fonts.fontconfig.enable = true;

  home.file.".icons/default".source = "${pkgs.quintom-cursor-theme}/share/icons/Quintom_Snow";

  gtk = {
    enable = true;
    iconTheme.name = "oomox-gruvbox-dark";
    theme.name = "gruvbox-dark";
  };

  xdg = {
    dataFile."applications/mimeapps.list".force = true;
    configFile."mimeapps.list".force = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "application/xhtml+xml" = "firefox.desktop";
        "application/vnd.mozilla.xul+xml" = "firefox.desktop";
        "text/html" = "firefox.desktop";
      };
    };
  };

  home.stateVersion = "22.05";
}

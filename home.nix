{ config, pkgs, lib, ... }:
let
  colors = import ./colors.nix;

  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;

    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };

  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text = let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsettings-schemas/${schema.name}";
    in ''
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
      gnome_schema=org.gnome.desktop.interface
      gsettings set $gnome_schema gtk-theme 'gruvbox-dark'
    '';
  };

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
    unzip
    p7zip
    steam-run

    jre8
    jdk8
    gcc 
    (yarn.override { nodejs = nodejs-14_x; })
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
    bitwarden
    lutris
    gamemode
    libreoffice-fresh

    dbus-sway-environment
    swaylock
    swayidle
    libnotify
    wl-clipboard
    brightnessctl
    gammastep
    pavucontrol
    bemenu
    nerdfonts

    configure-gtk
    glib
    xdg-utils
    qt5.qtwayland
    libsForQt5.qtstyleplugins
    quintom-cursor-theme
    gruvbox-dark-gtk
    gruvbox-dark-icons-gtk
    gtk-engine-murrine
    gtk_engines
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
        "application/pdf" = "firefox.desktop";
      };
    };
  };

  home.stateVersion = "22.05";
}

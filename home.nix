{ config, pkgs, lib, ... }:
let
  colors = import ./colors.nix;
  gruvbox-material-gtk = pkgs.callPackage ./packages/gruvbox-material-gtk.nix {};
  gruvbox-material-gtk-icons = pkgs.callPackage ./packages/gruvbox-material-gtk-icons.nix {};
in {
  imports = [
    ./sway.nix
    ./terminal.nix
    ./mako.nix
    ./neovim.nix
    ./waybar.nix
  ];

  programs.home-manager.enable = true;

  home.username = "roz";
  home.homeDirectory = "/home/roz";

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "steam"
      "steam-original"
      "steam-runtime"
    ];
  };

  home.packages = with pkgs; [
    slurp
    grim
    imv
    mpv
    htop
    neofetch
    git
    ripgrep
    fd
    fzf
    jq

    jdk8
    (sbt.override { jre = jdk8; })
    coursier
    bloop
    metals
    nodejs-12_x
    yarn

    via
    razergenie
    firefox
    tdesktop
    slack
    discord
    thunderbird-wayland
    bitwarden
    steam
    libreoffice-fresh

    swaylock
    swayidle
    wl-clipboard
    brightnessctl
    pavucontrol
    bemenu
    nerdfonts
    xdg_utils
    gruvbox-material-gtk
    gruvbox-material-gtk-icons
  ];

  gtk = {
    enable = true;
    iconTheme.name = "Gruvbox-Material-Dark";
    theme.name = "Gruvbox-Material-Dark";
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "application/xhtml+xml" = "firefox.desktop";
      "text/html" = "firefox.desktop";
    };
  };
  xdg.dataFile."applications/mimeapps.list".force = true;
  xdg.configFile."mimeapps.list".force = true;

  home.sessionVariables = {
    BROWSER = "${pkgs.firefox}/bin/firefox";
    EDITOR  = "${pkgs.neovim}/bin/nvim";
  };

  fonts.fontconfig.enable = true;
  services.mpd.enable = true;

  home.stateVersion = "21.05";
}

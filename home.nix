{ config, pkgs, lib, ... }:
let
  colors = import ./colors.nix;
  oomox-theme = pkgs.callPackage ./packages/theme.nix {};
in {
  imports = [
    ./sway.nix
    ./terminal.nix
    ./mako.nix
    ./neovim.nix
    ./waybar.nix
    ./mangohud.nix
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
    thefuck
    ripgrep
    fd
    fzf
    jq
    wget
    steam-run

    jdk8
    (sbt.override { jre = jdk8; })
    coursier
    bloop
    metals
    nodejs-12_x
    yarn

    via
    razergenie
    firefox-wayland
    thunderbird-wayland
    tdesktop
    slack
    discord
    bitwarden
    steam
    lutris
    libreoffice-fresh

    swaylock
    swayidle
    wl-clipboard
    brightnessctl
    pavucontrol
    bemenu
    nerdfonts
    glib
    quintom-cursor-theme
    xdg_utils
    qt5.qtwayland
    libsForQt5.qtstyleplugins
    oomox-theme
  ];

  fonts.fontconfig.enable = true;

  gtk = {
    enable = true;
    iconTheme.name = "suruplus_aspromauros";
    theme.name = "oomox";
  };
  
  home.file.".icons/default".source = "${pkgs.quintom-cursor-theme}/share/icons/Quintom_Snow";

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

  services.mpd.enable = true;

  home.stateVersion = "21.05";
}

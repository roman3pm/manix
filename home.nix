{ config, pkgs, lib, ... }:
let
  colors = import ./colors.nix;
in {
  imports = [
    ./sway.nix
    ./terminal.nix
    ./mako.nix
    ./neovim.nix
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
    git
    ripgrep
    fd
    fzf
    jq
    nix-prefetch-github

    jdk8
    (sbt.override { jre = jdk8; })
    coursier
    bloop
    metals
    nodejs
    yarn

    google-chrome
    firefox
    tdesktop
    slack
    thunderbird-wayland
    keepassxc
    libreoffice

    swaylock
    swayidle
    wl-clipboard
    brightnessctl
    pavucontrol
    bemenu
    nerdfonts
  ];

  fonts.fontconfig.enable = true;
  services.mpd.enable = true;

  home.stateVersion = "21.05";
}

{ pkgs, inputs, ... }: {

  imports = [
    inputs.nix-index-database.hmModules.nix-index
  ];

  programs.home-manager.enable = true;

  home.username = "roz";

  home.packages = with pkgs; [
    gnumake
    git-crypt
    ripgrep
    fzf
    fd
    jq
    imv
    mpv
    htop-vim
    killall
    neofetch
    hurl
    wget
    unar
    unzip
    p7zip
    zathura
    transmission_4

    gcc
    go
    gopls
    golangci-lint
    richgo
    nil
    nixpkgs-fmt
    lua-language-server
    nodejs-slim

    via
    swappy
    chromium
    thunderbird
    telegram-desktop
    (discord.override { withOpenASAR = true; })
    slack
    bitwarden
    _1password-gui
    libreoffice-fresh

    steam
    steam-run
    lutris
    wineWowPackages.stagingFull
    gamescope

    pavucontrol
    libnotify
    (nerdfonts.override { fonts = [ "Hack" ]; })
  ];

  home.sessionVariables = {
    EDITOR = "vim";
    VISUAL = "vim";
    BROWSER = "firefox";
    TERMINAL = "alacritty";
  };

  home.stateVersion = "23.11";
}

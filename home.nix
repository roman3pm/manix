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

    slurp
    grim
    wf-recorder
    wl-clipboard
    swaylock
    swayidle
    libnotify
    brightnessctl
    playerctl
    pavucontrol
    pamixer
    bemenu
    xdg-utils
    polkit_gnome

    (nerdfonts.override { fonts = [ "Hack" ]; })
    yaru-theme
  ];

  home.sessionVariables = {
    EDITOR = "vim";
    VISUAL = "vim";
    BROWSER = "firefox";
    TERMINAL = "alacritty";
  };

  home.file.".icons/default".source = "${pkgs.yaru-theme}/share/icons/Yaru-blue-dark";

  gtk = {
    enable = true;
    cursorTheme.name = "Yaru-blue-dark";
    iconTheme.name = "Yaru-blue-dark";
    theme.name = "Yaru-blue-dark";
  };

  qt = {
    enable = true;
    platformTheme = "gnome";
    style.name = "adwaita-dark";
  };

  xdg = {
    enable = true;
    userDirs.enable = true;
    mime.enable = true;
    dataFile."applications/mimeapps.list".force = true;
    configFile."mimeapps.list".force = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = "org.pwmt.zathura.desktop";
      };
    };
  };

  services.mako = {
    enable = true;
    anchor = "top-right";
    font = "DejaVu Sans 9";
    maxIconSize = 48;
  };

  services.easyeffects.enable = true;

  home.stateVersion = "23.11";
}

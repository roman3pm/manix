{ pkgs, ... }: {
  programs.home-manager.enable = true;

  home.username = "roz";

  home.packages = with pkgs; [
    gnumake
    git-crypt
    fd
    fzf
    jq
    imv
    mpv
    htop-vim
    neofetch
    ripgrep
    hurl
    wget
    unar
    unzip
    p7zip
    zathura
    steam-run
    gamemode
    vkbasalt
    transmission

    gcc
    go
    golangci-lint
    rustup
    nodePackages.pyright
    (sbt.override { jre = jdk17; })
    (metals.override { jre = jdk17; })
    gopls
    rust-analyzer
    lua-language-server
    nil
    nixpkgs-fmt

    via
    firefox
    thunderbird
    telegram-desktop
    slack
    libreoffice-fresh
    (discord.override { withOpenASAR = true; })
    bitwarden
    steam
    lutris
    wineWowPackages.staging

    slurp
    grim
    wf-recorder
    wl-clipboard
    swaylock
    swayidle
    libnotify
    brightnessctl
    playerctl
    gammastep
    pavucontrol
    pamixer
    bemenu
    xdg-utils
    polkit_gnome

    (nerdfonts.override { fonts = [ "DejaVuSansMono" ]; })
    yaru-theme
  ];

  programs.java = {
    enable = true;
    package = pkgs.jdk17;
  };

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
    ];
  };

  home.sessionVariables = {
    EDITOR = "vim";
    VISUAL = "vim";
    BROWSER = "firefox";
    TERMINAL = "alacritty";
  };

  fonts.fontconfig.enable = true;

  home.file.".icons/default".source = "${pkgs.yaru-theme}/share/icons/Yaru";

  gtk = {
    enable = true;
    cursorTheme.name = "Yaru";
    iconTheme.name = "Yaru-blue-dark";
    theme.name = "Yaru-blue-dark";
  };

  qt = {
    enable = true;
    platformTheme = "gtk";
  };

  xdg = {
    enable = true;
    userDirs.enable = true;
    mime.enable = true;
    dataFile."applications/mimeapps.list".force = true;
    configFile."mimeapps.list".force = true;
    desktopEntries = {
      nvim-alacritty = {
        name = "Neovim";
        genericName = "Text Editor";
        exec = "alacritty --title Neovim --class nvim -e nvim %F";
        icon = "nvim";
        terminal = false;
        mimeType = [ "text/plain" ];
      };
    };
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/plain" = "nvim-alacritty.desktop";
        "application/pdf" = "org.pwmt.zathura.desktop";
      };
    };
  };

  services.easyeffects.enable = true;

  home.stateVersion = "23.05";
}

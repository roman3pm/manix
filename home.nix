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
    transmission
    gamemode
    vkbasalt

    gcc
    go
    impl
    richgo
    gomodifytags
    golangci-lint
    nodePackages.pyright
    (sbt.override { jre = jdk17; })
    (metals.override { jre = jdk17; })
    gopls
    rustc
    rust-analyzer
    nil
    nixpkgs-fmt
    lua-language-server

    via
    firefox
    thunderbird
    telegram-desktop
    slack
    libreoffice-fresh
    (discord.override { withOpenASAR = true; })
    bitwarden
    _1password-gui
    steam
    lutris

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

  home.file.".icons/default".source = "${pkgs.yaru-theme}/share/icons/Yaru";

  gtk = {
    enable = true;
    cursorTheme.name = "Yaru";
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
    configFile."vkBasalt/vkBasalt.conf".text = ''
      effects = cas
      toggleKey = Home
      enableOnLaunch = True
      casSharpness = 0.4
    '';
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

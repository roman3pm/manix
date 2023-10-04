{ pkgs, inputs, ... }: {

  imports = [
    inputs.nix-index-database.hmModules.nix-index
  ];

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
    unrar
    unzip
    p7zip
    zathura
    transmission

    gcc
    go_1_21
    gopls
    impl
    richgo
    gomodifytags
    golangci-lint
    nodejs-slim
    nodePackages.pyright
    rustc
    rust-analyzer
    nil
    nixpkgs-fmt
    lua-language-server

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
    vkbasalt
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
    configFile."vkBasalt/vkBasalt.conf".text = ''
      effects = cas
      toggleKey = Home
      enableOnLaunch = True
      casSharpness = 0.2
    '';
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

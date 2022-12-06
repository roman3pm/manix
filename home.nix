{ config, pkgs, lib, ... }: {
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

  home.packages = with pkgs; [
    fd
    fzf
    jq
    imv
    mpv
    htop-vim
    neofetch
    thefuck
    ripgrep
    wireguard-tools
    wget
    unar
    unzip
    p7zip
    ranger
    zathura
    steam-run
    gamemode

    jre8
    jdk8
    gcc 
    nodejs-14_x
    (yarn.override { nodejs = nodejs-14_x; })
    rust-analyzer
    sumneko-lua-language-server
    (sbt.override { jre = jre8; })
    (maven.override { jdk = jdk8; })
    (bloop.override { jre = jre8; })
    (metals.override { jre = jre8; })
    (coursier.override { jre = jre8; })

    via
    polychromatic
    firefox
    thunderbird
    tdesktop
    slack
    (discord.override { withOpenASAR = true; })
    bitwarden
    lutris
    libreoffice-fresh

    slurp
    grim
    wf-recorder
    wl-clipboard
    swaylock
    swayidle
    libnotify
    brightnessctl
    gammastep
    pavucontrol
    bemenu

    nerdfonts
    quintom-cursor-theme
    materia-theme
    vimix-icon-theme
  ];
  
  home.sessionVariables = {
    EDITOR = "vim";
    SSH_ASKPASS = pkgs.writeShellScript "ssh_askpass" "cat $HOME/.secret/sshpass/ssh_pass";
  };

  fonts.fontconfig.enable = true;

  home.file.".icons/default".source = "${pkgs.quintom-cursor-theme}/share/icons/Quintom_Snow";

  gtk = {
    enable = true;
    cursorTheme.name = "Quintom_Snow";
    iconTheme.name = "Vimix-Doder-dark";
    theme.name = "Materia-dark-compact";
  };

  qt = {
    enable = true;
    platformTheme = "gtk";
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

  home.stateVersion = "22.11";
}

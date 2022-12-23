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
    hurl
    wget
    unar
    unzip
    p7zip
    lf
    zathura
    steam-run
    gamemode
    vkbasalt

    jre8
    jdk8
    gcc 
    go
    nodejs-14_x
    (yarn.override { nodejs = nodejs-14_x; })
    gopls
    rust-analyzer
    sumneko-lua-language-server
    (sbt.override { jre = jre8; })
    (maven.override { jdk = jdk8; })
    (bloop.override { jre = jre8; })
    (metals.override { jre = jre8; })
    (coursier.override { jre = jre8; })

    via
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
    swaylock-effects
    swayidle
    libnotify
    brightnessctl
    playerctl
    gammastep
    pavucontrol
    pamixer
    bemenu
    xdg-utils

    nerdfonts
    quintom-cursor-theme
    materia-theme
    vimix-icon-theme
  ];
  
  home.sessionVariables = rec {
    EDITOR = "vim";
    VISUAL = "vim";
    BROWSER = "firefox";
    TERMINAL = "alacritty";
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
    enable = true;
    userDirs.enable = true;
  };

  services.easyeffects.enable = true;

  home.stateVersion = "23.05";
}

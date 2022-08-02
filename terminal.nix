{ config, pkgs, ... }:
let
  colors = import ./colors.nix;
  fonts = import ./fonts.nix;
in {

  programs.bash = {
    enable = true;
    profileExtra = ''
      if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
        exec sway
      fi
    '';
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "gruvbox-dark";
    };
  };

  programs.zsh = {
    enable = true;
    initExtraBeforeCompInit = "fpath+=(${pkgs.bloop}/share/zsh/site-functions)";
    shellAliases = {
      nh  = "cd ~/.config/nixpkgs";
      nfu = "nix flake update";
      nrs = "nixos-rebuild switch --use-remote-sudo --flake '.#'";
      ngc = "sudo nix-collect-garbage -d";
    };
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
    oh-my-zsh = {
      enable  = true;
      plugins = [ "git" "thefuck" ];
      theme   = "bira";
    };
    initExtra = ''
      source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
    '';
  };

  programs.alacritty = let
    fontName = builtins.head fonts.fontConfig.names;
  in {
    enable = true;
    settings = {
      window.opacity = 0.80;
      cursor = {
        style = {
          blinking = "Always";
          blink_interval = 500;
        };
      };
      colors = {
        primary = {
          background = "0x${colors.bg}";
          foreground = "0x${colors.fg}";
        };
        normal = {
          black   = "0x${colors.bg1}";
          red     = "0x${colors.red}";
          green   = "0x${colors.green}";
          yellow  = "0x${colors.yellow}";
          blue    = "0x${colors.blue}";
          magneta = "0x${colors.purple}";
          cyan    = "0x${colors.aqua}";
          white   = "0x${colors.fg}";
        };
        bright = {
          black   = "0x${colors.bg2}";
          red     = "0x${colors.br_red}";
          green   = "0x${colors.br_green}";
          yellow  = "0x${colors.br_yellow}";
          blue    = "0x${colors.br_blue}";
          magenta = "0x${colors.br_purple}";
          cyan    = "0x${colors.br_aqua}";
          white   = "0x${colors.fg0}";
        };
      };
      font = {
        normal      = { family = fontName; };
#        bold        = { family = fontName; };
#        italic      = { family = fontName; };
#        bold_italic = { family = fontName; };
      };
      shell.program = "${pkgs.zsh}/bin/zsh";
    };
  };

}

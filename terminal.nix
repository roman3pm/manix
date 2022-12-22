{ config, pkgs, ... }:
let
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
      theme = "DarkNeon";
    };
  };

  programs.zsh = {
    enable = true;
    initExtraBeforeCompInit = "fpath+=(${pkgs.bloop}/share/zsh/site-functions)";
    shellAliases = {
      ll  = "LC_COLLATE=C ls -la --group-directories-first";
      nh  = "cd $HOME/Projects/manix";
      nfu = "nix flake update";
      nrs = "nixos-rebuild switch --use-remote-sudo --flake '.#'";
      ngc = "sudo nix-collect-garbage -d";
      ns  = "nix search nixpkgs";
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
      window = {
        opacity = 0.90;
        dimensions = {
          columns = 106;
          lines = 33;
        };
      };
      cursor = {
        style = {
          blinking = "Always";
          blink_interval = 500;
        };
      };
      colors = {
        primary = {
          background = "0x1a1b26";
          foreground = "0xa9b1d6";
        };
        normal = {
          black   = "0x32344a";
          red     = "0xf7768e";
          green   = "0x9ece6a";
          yellow  = "0xe0af68";
          blue    = "0x7aa2f7";
          magneta = "0xad8ee6";
          cyan    = "0x449dab";
          white   = "0x787c99";
        };
        bright = {
          black   = "0x444b6a";
          red     = "0xff7a93";
          green   = "0xb9f27c";
          yellow  = "0xff9e64";
          blue    = "0x7da6ff";
          magenta = "0xbb9af7";
          cyan    = "0x0db9d7";
          white   = "0xacb0d0";
        };
      };
      font = {
        normal = { family = fontName; };
        size = 12;
      };
      shell.program = "${pkgs.zsh}/bin/zsh";
    };
  };

}

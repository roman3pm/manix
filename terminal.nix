{ config, pkgs, ... }:
let
  colors = import ./colors.nix;
  fonts = import ./fonts.nix;
in {
  programs.zsh = {
    enable = true;
    shellAliases = {
      update  = "home-manager switch";
      upgrade = "sudo nixos-rebuild switch";
    };
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
    oh-my-zsh = {
      enable  = true;
      theme   = "agnoster";
    };
  };
  programs.tmux = {
    enable  = true;
    shell   = "${pkgs.zsh}/bin/zsh";
    keyMode = "vi";
  };
  programs.alacritty = let
    fontName = builtins.head fonts.fontConfig.names;
  in {
    enable = true;
    settings = {
      background_opacity = 0.97;
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
        normal = { family = fontName; };
        bold   = { family = fontName; style = "Bold"; };
        italic = { family = fontName; stype = "Italic"; };
      };
      shell.program = "${pkgs.zsh}/bin/zsh";
    };
  };
}

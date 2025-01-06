{ pkgs, ... }:
let
  lfSrc = pkgs.fetchFromGitHub {
    owner = "gokcehan";
    repo = "lf";
    rev = "r33";
    sparseCheckout = [ "etc" ];
    hash = "sha256-aKvTf2tqAUbB3plOemvgJJ7qYdGfQoXhsGVE7Y9wuMo=";
  };
  k9sSrc = pkgs.fetchFromGitHub {
    owner = "derailed";
    repo = "k9s";
    rev = "v0.32.7";
    sparseCheckout = [ "skins" ];
    hash = "sha256-0S6FomP1WVqYl5nP0FcaElgghMcZmE0V8iLhghERF6A=";
  };
in
{
  home-manager.users.roz = {
    programs.ghostty = {
      enable = true;
      settings = {
        font-family = "DejaVuSansM Nerd Font Mono";
        font-size = 12;
        theme = "Adwaita Dark";
      };
    };

    programs.nix-index.enable = true;

    programs.fish = {
      enable = true;
      shellInit = ''
        set fish_greeting
        fish_vi_key_bindings
      '';
      shellAbbrs = {
        lg = "lazygit";
        ll = "ls -la --group-directories-first";
        nh = "cd $HOME/projects/manix";
        nfu = "nix flake update";
        nrs = "nixos-rebuild switch --use-remote-sudo --flake '.#'";
        ngc = "sudo nix-collect-garbage -d; nix-collect-garbage -d";
        ssc = "sudo systemctl";
        scu = "systemctl --user";
      };
      functions = {
        fish_user_key_bindings = {
          body = ''
            bind -M insert \el forward-word
            bind -M insert \ej forward-char
          '';
        };
        prompt_hostname = {
          body = ''
            set -l my_hostname $hostname
            if test (math $SHLVL) -gt 1
              set my_hostname "nix-shell"
            end

            string replace -r "\..*" "" $my_hostname
          '';
        };
      };
    };

    programs.tmux = {
      enable = true;
      keyMode = "vi";
      mouse = true;
    };

    programs.lf = {
      enable = true;
      settings = {
        hidden = true;
        icons = true;
        preview = true;
      };
    };
    xdg.configFile."lf/icons".source = "${lfSrc}/etc/icons_colored.example";

    programs.k9s = {
      enable = true;
      settings = {
        k9s.ui.skin = "transparent";
      };
      skins = {
        transparent = "${k9sSrc}/skins/transparent.yaml";
      };
    };

    home.sessionVariables.TERMINAL = "ghostty";
  };

  xdg = {
    terminal-exec = {
      enable = true;
      settings = {
        GNOME = [ "com.mitchellh.ghostty.desktop" ];
        default = [ "com.mitchellh.ghostty.desktop" ];
      };
    };
  };
}

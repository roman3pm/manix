{ pkgs, ... }: {
  home-manager.users.roz = {
    programs.nix-index.enable = true;

    programs.fish = {
      enable = true;
      loginShellInit = ''
        if test -z "$DISPLAY"
          and test "$XDG_VTNR" -eq 1
          exec sway
        end
      '';
      shellInit = ''
        set fish_greeting
        fish_vi_key_bindings
      '';
      shellAbbrs = {
        lg = "lazygit";
        ll = "LC_COLLATE=C ls -la --group-directories-first";
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
            if string match -rq '/nix/store' "$PATH"
              set my_hostname "nix-shell"
            end

            string replace -r "\..*" "" $my_hostname
          '';
        };
      };
    };

    programs.bat = {
      enable = true;
      themes = {
        tokyonight = {
          src = pkgs.fetchFromGitHub {
            owner = "folke";
            repo = "tokyonight.nvim";
            rev = "v4.6.0";
            sha256 = "evKMF/sCEIoE/OiIBiP7jW+f9Ee3IUTbWSufHOZDNTY=";
          };
          file = "/extras/sublime/tokyonight_night.tmTheme";
        };
      };
      config = {
        theme = "tokyonight";
      };
    };

    programs.lf = {
      enable = true;
      settings = {
        hidden = true;
        icons = true;
        preview = true;
      };
      previewer.source = pkgs.writeShellScript "pv.sh" ''
        #!/bin/sh
        case "$1" in
            *) bat --color always "$1";;
        esac
      '';
    };
    xdg.configFile."lf/icons".source = "${pkgs.lf}/etc/icons.example";

    programs.alacritty = {
      enable = true;
      settings = {
        env = {
          TERM = "xterm-256color";
        };
        window = {
          dimensions = {
            columns = 100;
            lines = 30;
          };
          padding = {
            x = 8;
            y = 8;
          };
        };
        cursor = {
          style = {
            blinking = "Always";
          };
          blink_timeout = 0;
        };
        colors = {
          primary = {
            background = "#1a1b26";
            foreground = "#c0caf5";
          };
          normal = {
            black = "#15161e";
            red = "#f7768e";
            green = "#9ece6a";
            yellow = "#e0af68";
            blue = "#7aa2f7";
            magenta = "#bb9af7";
            cyan = "#7dcfff";
            white = "#a9b1d6";
          };
          bright = {
            black = "#414868";
            red = "#f7768e";
            green = "#9ece6a";
            yellow = "#e0af68";
            blue = "#7aa2f7";
            magenta = "#bb9af7";
            cyan = "#7dcfff";
            white = "#c0caf5";
          };
          indexed_colors = [
            {
              index = 16;
              color = "#ff9e64";
            }
            {
              index = 17;
              color = "#db4b4b";
            }
          ];
        };
        font = {
          normal = { family = "Hack Nerd Font"; };
          size = 12;
        };
        shell.program = "${pkgs.fish}/bin/fish";
      };
    };

    home.sessionVariables.TERMINAL = "alacritty";
  };
}

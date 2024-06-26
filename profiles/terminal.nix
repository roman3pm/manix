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
            owner = "enkia";
            repo = "enki-theme";
            rev = "0b629142733a27ba3a6a7d4eac04f81744bc714f";
            sha256 = "Q+sac7xBdLhjfCjmlvfQwGS6KUzt+2fu+crG4NdNr4w=";
          };
          file = "/scheme/Enki-Tokyo-Night.tmTheme";
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
            background = "0x1a1b26";
            foreground = "0xa9b1d6";
          };
          normal = {
            black = "0x32344a";
            red = "0xf7768e";
            green = "0x9ece6a";
            yellow = "0xe0af68";
            blue = "0x7aa2f7";
            magenta = "0xad8ee6";
            cyan = "0x449dab";
            white = "0x787c99";
          };
          bright = {
            black = "0x444b6a";
            red = "0xff7a93";
            green = "0xb9f27c";
            yellow = "0xff9e64";
            blue = "0x7da6ff";
            magenta = "0xbb9af7";
            cyan = "0x0db9d7";
            white = "0xacb0d0";
          };
        };
        font = {
          normal = { family = "Hack Nerd Font"; };
          size = 12;
        };
        shell.program = "${pkgs.fish}/bin/fish";
      };
    };
  };
}

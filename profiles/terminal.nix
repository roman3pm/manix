{ pkgs, ... }:
let
  tokyonightTheme = pkgs.fetchFromGitHub {
    owner = "folke";
    repo = "tokyonight.nvim";
    rev = "v4.6.0";
    sha256 = "evKMF/sCEIoE/OiIBiP7jW+f9Ee3IUTbWSufHOZDNTY=";
  };
in
{
  home-manager.users.roz = {
    programs.nix-index.enable = true;

    programs.fish = {
      enable = true;
      loginShellInit = ''
        if test -z "$DISPLAY"
          and test "$XDG_VTNR" -eq 1
          exec Hyprland
        end
      '';
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

    programs.bat = {
      enable = true;
      themes = {
        tokyonight = {
          src = tokyonightTheme;
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
        font = {
          normal = {
            family = "DejaVuSansM Nerd Font";
          };
          size = 12;
        };
        shell.program = "${pkgs.fish}/bin/fish";
        import = [ "${tokyonightTheme}/extras/alacritty/tokyonight_night.toml" ];
      };
    };

    home.sessionVariables.TERMINAL = "alacritty";
  };
}

{ pkgs, ... }:
{
  home-manager.users.roz = {
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

    programs.lf = {
      enable = true;
      settings = {
        hidden = true;
        icons = true;
        preview = true;
      };
    };
    xdg.configFile."lf/icons".source = "${pkgs.lf}/etc/icons.example";

    home.sessionVariables.TERMINAL = "kgx";
  };
}

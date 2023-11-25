{ pkgs, ... }: {
  home-manager.users.roz = {
    home.packages = with pkgs; [ swaynotificationcenter ];

    xdg = {
      configFile."swaync/style.css".text = ''
        @define-color background rgba(0, 0, 0, 0.6);
        .control-center {
          background: @background;
        }
        .blank-window {
          background: transparent;
        }
      '';
    };
  };
}

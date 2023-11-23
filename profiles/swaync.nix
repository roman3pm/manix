{ pkgs, ... }: {
  home-manager.users.roz = {
    home.packages = with pkgs; [ swaynotificationcenter ];

    xdg = {
      configFile."swaync/config.json".text = ''
        {
          "notification-window-width": 400,
          "control-center-width": 400
        }
      '';
      configFile."swaync/style.css".text = ''
        @define-color background rgba(0, 0, 0, 0.5);
        .control-center {
          background: @background;
        }
      '';
    };
  };
}

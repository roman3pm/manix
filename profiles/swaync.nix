{ pkgs, ... }: {
  home-manager.users.roz = {
    home.packages = with pkgs; [ swaynotificationcenter ];

    xdg = {
      configFile."swaync/style.css".text = ''
        .control-center {
          border-radius: 0;
        }
      '';
      configFile."swaync/config.json".text = ''
        {
          "widgets": [
            "inhibitors",
            "title",
            "dnd",
            "mpris",
            "notifications"
          ]
        }
      '';
    };
  };
}

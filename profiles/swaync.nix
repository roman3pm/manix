{ pkgs, ... }: {
  home-manager.users.roz = {
    home.packages = with pkgs; [ swaynotificationcenter ];

    xdg = {
      configFile."swaync/style.css".text = ''
        .blank-window {
          background: transparent;
        }
      '';
    };
  };
}

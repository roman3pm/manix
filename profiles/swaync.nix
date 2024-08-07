{ pkgs, ... }:
let
  package = pkgs.swaynotificationcenter;
in
{
  home-manager.users.roz = {
    home.packages = [ package ];

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

    systemd.user.services.swaync = {
      Unit = {
        Description = "A simple notification daemon with a GTK gui for notifications and the control center";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session-pre.target" ];
      };

      Service = {
        ExecStart = "${package}/bin/swaync";
        ExecReload = "${pkgs.coreutils}/bin/kill -SIGUSR2 $MAINPID";
        Restart = "on-failure";
        KillMode = "mixed";
      };

      Install = { WantedBy = [ "graphical-session.target" ]; };
    };
  };
}

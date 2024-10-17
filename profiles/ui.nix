{ pkgs, ... }:
{
  home-manager.users.roz = {
    home.packages = with pkgs; [ gnome-themes-extra ];

    gtk = {
      enable = true;
      theme.name = "Adwaita-dark";
      iconTheme.name = "Adwaita";
    };

    dconf = {
      enable = true;
      settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
        };
      };
    };

    home.pointerCursor = {
      package = pkgs.gnome-themes-extra;
      name = "Adwaita";
      size = 32;
      gtk.enable = true;
    };

    qt = {
      enable = true;
      platformTheme.name = "gtk3";
    };

    xdg = {
      enable = true;
      portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-hyprland
        ];
        config.common.default = "*";
      };
      dataFile."applications/mimeapps.list".force = true;
      configFile."mimeapps.list".force = true;
      mimeApps = {
        enable = true;
        defaultApplications = {
          "application/pdf" = "org.pwmt.zathura.desktop";
        };
      };
    };
  };

  environment.pathsToLink = [
    "/share/xdg-desktop-portal"
    "/share/applications"
  ];
}

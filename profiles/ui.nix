{ pkgs, ... }:
let
  themePackage = pkgs.yaru-theme;
  themeName = "Yaru-blue-dark";
in
{
  home-manager.users.roz = {
    home.packages = [ themePackage ];

    gtk = {
      enable = true;
      theme.name = themeName;
      iconTheme.name = themeName;
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
      package = themePackage;
      name = themeName;
      size = 24;
      gtk.enable = true;
    };

    qt = {
      enable = true;
      platformTheme.name = "gtk3";
    };

    xdg = {
      enable = true;
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
}

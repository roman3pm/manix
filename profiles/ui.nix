{ pkgs, ... }: {
  home-manager.users.roz = {
    home.packages = with pkgs; [ yaru-theme ];

    gtk = {
      enable = true;
      cursorTheme.name = "Yaru-blue-dark";
      iconTheme.name = "Yaru-blue-dark";
      theme.name = "Yaru-blue-dark";
    };


    qt = {
      enable = true;
      platformTheme = "gnome";
      style.name = "adwaita-dark";
    };

    home.file.".icons/default".source = "${pkgs.yaru-theme}/share/icons/Yaru-blue-dark";

    xdg = {
      enable = true;
      userDirs.enable = true;
      mime.enable = true;
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

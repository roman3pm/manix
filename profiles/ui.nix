{ pkgs, ... }:
{
  home-manager.users.roz = {
    home.packages = with pkgs.gnomeExtensions; [ blur-my-shell ];

    gtk = {
      enable = true;
      theme = {
        package = pkgs.gnome-themes-extra;
        name = "Adwaita-dark";
      };
      iconTheme = {
        package = pkgs.adwaita-icon-theme;
        name = "Adwaita";
      };
    };

    qt = {
      enable = true;
      platformTheme.name = "adwaita";
      style.name = "adwaita-dark";
    };

    dconf = {
      enable = true;
      settings = {
        "org/gnome/shell" = {
          disable-user-extensions = false;
          enabled-extensions = with pkgs.gnomeExtensions; [ blur-my-shell.extensionUuid ];
        };
        "org/gnome/desktop/wm/preferences" = {
          resize-with-right-button = true;
        };
      };
    };

    home.pointerCursor = {
      package = pkgs.gnome-themes-extra;
      name = "Adwaita";
      size = 32;
      gtk.enable = true;
    };

    home.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}

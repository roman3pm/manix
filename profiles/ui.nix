{ pkgs, ... }:
{
  home-manager.users.roz = {
    home.packages = with pkgs.gnomeExtensions; [
      blur-my-shell
      appindicator
    ];

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
          enabled-extensions = with pkgs.gnomeExtensions; [
            blur-my-shell.extensionUuid
            appindicator.extensionUuid
          ];
        };
        "org/gnome/desktop/interface".color-scheme = "prefer-dark";
        "org/gnome/desktop/interface".monospace-font-name = "DejaVuSansM Nerd Font Mono 12";
        "org/gnome/desktop/wm/preferences".resize-with-right-button = true;
        "org/gnome/mutter".experimental-features = [ "variable-refresh-rate" ];
      };
    };

    home.pointerCursor = {
      package = pkgs.gnome-themes-extra;
      name = "Adwaita";
      size = 32;
      gtk.enable = true;
    };
  };
}

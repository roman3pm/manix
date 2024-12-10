{ lib, pkgs, ... }:
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
    };

    qt = {
      enable = true;
      platformTheme.name = "adwaita";
      style.name = "adwaita";
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
        "org/gnome/desktop/interface".cursor-size = 32;
        "org/gnome/desktop/interface".monospace-font-name = "DejaVuSansM Nerd Font Mono 12";
        "org/gnome/desktop/wm/preferences".resize-with-right-button = true;
        "org/gnome/mutter".experimental-features = [ "variable-refresh-rate" ];
        "org/gnome/desktop/peripherals/keyboard" = {
          repeat-interval = lib.gvariant.mkUint32 15;
          delay = lib.gvariant.mkUint32 250;
        };
      };
    };
  };
}

{ lib, pkgs, ... }:
{
  services = {
    displayManager = {
      gdm.enable = true;
      defaultSession = "gnome";
    };
    desktopManager = {
      gnome = {
        enable = true;
        extraGSettingsOverridePackages = [ pkgs.mutter ];
      };
    };
    xserver = {
      xkb = {
        layout = "us,ru";
        options = "grp:lctrl_toggle,ctrl:nocaps";
      };
    };
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerd-fonts.adwaita-mono
      wqy_zenhei
    ];
    fontconfig.defaultFonts.monospace = [ "AdwaitaMono Nerd Font Mono" ];
  };

  home-manager.users.roz = {
    home.packages = with pkgs.gnomeExtensions; [ dash-to-dock ];
    dconf = {
      enable = true;
      settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          cursor-size = 32;
          monospace-font-name = "AdwaitaMono Nerd Font Mono 12";
          locate-pointer = false;
        };
        "org/gnome/desktop/wm/preferences".resize-with-right-button = true;
        "org/gnome/mutter" = {
          experimental-features = [ "variable-refresh-rate" ];
          locate-pointer-key = "";
        };
        "org/gnome/desktop/peripherals/keyboard" = {
          repeat-interval = lib.gvariant.mkUint32 15;
          delay = lib.gvariant.mkUint32 250;
        };
        "org/gnome/shell" = {
          disable-user-extensions = false;
          enabled-extensions = with pkgs.gnomeExtensions; [ dash-to-dock.extensionUuid ];
        };
        "org/gnome/shell/extensions/dash-to-dock" = {
          running-indicator-style = "DOTS";
        };
      };
    };

    qt = {
      enable = true;
      platformTheme.name = "adwaita";
      style.name = "adwaita";
    };
  };
}

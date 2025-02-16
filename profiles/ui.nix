{ lib, pkgs, ... }:
{
  services = {
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager = {
        gnome.enable = true;
        gnome.extraGSettingsOverridePackages = [ pkgs.mutter ];
      };
      xkb = {
        layout = "us,ru";
        variant = "";
        options = "grp:lctrl_toggle,ctrl:nocaps";
      };
    };
    displayManager.defaultSession = "gnome";
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerd-fonts.dejavu-sans-mono
      wqy_zenhei
    ];
    fontconfig.defaultFonts.monospace = [ "DejaVuSansM Nerd Font Mono" ];
  };

  home-manager.users.roz = {
    dconf = {
      enable = true;
      settings = {
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

    qt = {
      enable = true;
      platformTheme.name = "adwaita";
      style.name = "adwaita";
    };
  };
}

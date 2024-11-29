{ pkgs, ... }:
{
  home-manager.users.roz = {
    home.packages = with pkgs.gnomeExtensions; [ blur-my-shell ];
    dconf = {
      enable = true;
      settings = {
        "org/gnome/shell" = {
          disable-user-extensions = false;
          enabled-extensions = with pkgs.gnomeExtensions; [ blur-my-shell.extensionUuid ];
        };
      };
    };

    qt = {
      enable = true;
      platformTheme.name = "adwaita";
    };

    home.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}

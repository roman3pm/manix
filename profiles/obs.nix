{ pkgs, ... }:
{
  home-manager.users.roz = {
    programs.obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [ wlrobs ];
    };
  };
}

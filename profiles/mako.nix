{ pkgs, ... }: {
  home-manager.users.roz.services.mako = {
    enable = true;
    anchor = "bottom-right";
    font = "DejaVu Sans 9";
    margin = "8,0,0";
    maxIconSize = 48;
  };
}

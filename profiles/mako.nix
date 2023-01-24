{ pkgs, ... }: {
  home-manager.users.roz.programs.mako = {
    enable = true;
    anchor = "bottom-right";
    font = "DejaVu Sans 9";
    output = "HDMI-A-1";
    margin = "8,0,0";
    maxIconSize = 48;
  };
}

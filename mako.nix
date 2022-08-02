{ pkgs, ... }:
let
  colors = import ./colors.nix;
in {
  programs.mako = {
    enable = true;
    anchor = "bottom-right";
    font = "DejaVu Sans 9";
    output = "HDMI-A-1";
    backgroundColor = "#${colors.bg}";
    borderColor = "#${colors.bg1}";
    textColor = "#${colors.fg}";
    borderRadius = 5;
    maxIconSize = 48;
  };
}

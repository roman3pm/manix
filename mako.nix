{ pkgs, ... }: {
  programs.mako = {
    enable = true;
    anchor = "bottom-right";
    font = "DejaVu Sans 9";
    output = "HDMI-A-1";
    backgroundColor = "#285577E6";
    maxIconSize = 48;
  };
}

let
  colors = import ./colors.nix;
  fonts = import ./fonts.nix;
  fontName = builtins.head fonts.fontConfig.names;
#  fontSize = builtins.toString(builtins.floor fonts.fontConfig.size);
in {
  programs.mako = {
    enable = true;
    anchor = "bottom-right";
    font = "${fontName} 9";
    backgroundColor = "#${colors.bg1}";
    borderColor = "#${colors.bg2}";
    textColor = "#${colors.fg}";
    borderRadius = 5;
  };
}

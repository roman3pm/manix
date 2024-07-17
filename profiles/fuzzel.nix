{
  home-manager.users.roz.programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "Hack Nerd Font:size=12";
        dpi-aware = "no";
        width = 40;
        lines = 8;
        line-height = "35px";
      };
      border = {
        width = 0;
        radius = 0;
      };
      colors = {
        background = "2e2e2eb3";
        text = "ffffffff";
        match = "ffffffff";
        selection = "0080ffff";
        selection-text = "ffffffff";
        selection-match = "ffffffff";
        border = "ffffff26";
      };
    };
  };
}

{
  home-manager.users.roz.programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "DejaVu Sans Mono:size=12";
        icon-theme = "Papirus-Dark";
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
        prompt = "ffffffff";
        input = "ffffffff";
        match = "ffffffff";
        selection = "1a5fb4ff";
        selection-text = "ffffffff";
        selection-match = "ffffffff";
      };
    };
  };
}

{ pkgs, ... }: {
  programs.git = {
    enable = true;
    userName = "Roman Zakirzyanov";
    userEmail = "roman3pm@yandex.ru";
    extraConfig = {
      push.default = "current";
      pull.ff = "only";
      core = {
        qoutePath = false;
        editor = "vim";
      };
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
    };
    delta = {
      enable = true;
      options = {
        side-by-side = true;
        syntax-theme = "tokyonight";
        dark = true;
        paging = "never";
        features = "decorations";
        decorations = {
          file-style = "omit";
          hunk-header-decoration-style = "blue box";
          hunk-header-file-style = "red";
          hunk-header-style = "file line-number syntax";
        };
      };
    };
  };

  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        scrollHeight = 10;
        scrollPastBottom = false;
        sidePanelWidth = 0.2;
        theme = {
          selectedLineBgColor = [ "black" ];
          selectedRangeBgColor = [ "black" ];
        };
        showIcons = true;
      };
      git.paging = {
        colorArg = "always";
        pager = "delta";
      };
    };
  };
}

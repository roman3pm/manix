{
  home-manager.users.roz = {
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
    };

    programs.lazygit = {
      enable = true;
      settings = {
        gui = {
          scrollHeight = 10;
          scrollPastBottom = false;
          theme = {
            selectedLineBgColor = [ "black" ];
            selectedRangeBgColor = [ "black" ];
          };
        };
      };
    };
  };
}

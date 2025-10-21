{
  home-manager.users.roz = {
    programs.git = {
      enable = true;
      settings = {
        user = {
          name = "Roman Zakirzyanov";
          email = "roman3pm@yandex.ru";
        };
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
        };
      };
    };
  };
}

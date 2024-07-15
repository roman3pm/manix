{
  home-manager.users.roz.programs.wofi = {
    enable = true;
    settings = {
      mode = "run";
      width = 500;
      lines = 12;
      filter_rate = 20;
    };
    style = ''
      * {
        border-radius: 0;
        font-family: "Hack Nerd Font";
        font-size: 16px;
      }

      #window {
        background-color: rgba(46, 46, 46, 0.7);
      }

      #input {
        background-color: rgba(46, 46, 46, 0.8);
      }
    '';
  };
}

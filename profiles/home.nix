{ pkgs, inputs, ... }: {
  home-manager.users.roz = {

    imports = [
      inputs.nix-index-database.hmModules.nix-index
    ];

    programs.home-manager.enable = true;

    home.username = "roz";

    home.packages = [
      (pkgs.discord.override { withOpenASAR = true; })
      (pkgs.nerdfonts.override { fonts = [ "Hack" ]; })
    ] ++ (with pkgs; [
      gnumake
      git-crypt
      ripgrep
      fzf
      fd
      jq
      imv
      mpv
      htop-vim
      killall
      hurl
      wget
      unar
      unzip
      p7zip
      zathura
      transmission_4

      clang
      cmake
      clang-tools
      glsl_analyzer
      go
      gopls
      golangci-lint
      richgo
      rustc
      cargo
      rust-analyzer
      rustfmt
      nixd
      nixpkgs-fmt
      lua-language-server
      nodejs-slim
      pyright
      nodePackages.typescript-language-server
      llm-ls

      via
      swappy
      thunderbird
      telegram-desktop
      slack
      libreoffice-fresh
      godot_4

      steam-run
      protontricks

      pavucontrol
      libnotify
      slurp
      grim
      wf-recorder
      wl-clipboard
    ]);

    home.stateVersion = "24.05";
  };
}

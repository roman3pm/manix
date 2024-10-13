{ pkgs, inputs, ... }:
{
  home-manager.users.roz = {

    imports = [ inputs.nix-index-database.hmModules.nix-index ];

    programs.home-manager.enable = true;

    home.username = "roz";

    home.packages =
      [
        (pkgs.discord.override { withOpenASAR = true; })
        (pkgs.nerdfonts.override { fonts = [ "Hack" ]; })
      ]
      ++ (with pkgs; [
        gnumake
        git-crypt
        ripgrep
        fzf
        fd
        jq
        imv
        mpv
        htop-vim
        wget
        unar
        unzip
        p7zip

        clang
        cmake
        clang-tools
        glsl_analyzer
        go
        gopls
        golangci-lint
        richgo
        zig
        zls
        rustc
        cargo
        rust-analyzer
        rustfmt
        nixd
        nixfmt-rfc-style
        lua-language-server
        nodejs-slim
        pyright
        nodePackages.typescript-language-server

        swappy
        thunderbird
        telegram-desktop
        slack
        teamspeak_client
        libreoffice-fresh
        transmission_4-gtk
        zathura
        godot_4
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

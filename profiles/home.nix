{ pkgs, inputs, ... }:
{
  home-manager.users.roz = {

    imports = [ inputs.nix-index-database.hmModules.nix-index ];

    programs.home-manager.enable = true;

    home.username = "roz";

    home.packages = with pkgs; [
      gnumake
      git-crypt
      ripgrep
      fzf
      fd
      jq
      htop-vim
      wget
      unar
      unzip
      p7zip
      wl-clipboard

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
      typescript-language-server
      kubectl

      swappy
      thunderbird
      telegram-desktop
      mattermost-desktop
      teamspeak3
      libreoffice-fresh
      transmission_4-gtk
      zathura
      godot_4
      protontricks
    ];

    home.stateVersion = "24.05";
  };
}

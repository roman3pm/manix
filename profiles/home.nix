{ pkgs, ... }:
{
  home-manager.users.roz = {

    programs.home-manager.enable = true;

    home.username = "roz";

    home.packages = with pkgs; [
      gnumake
      git-crypt
      inetutils
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
      ffmpeg

      clang
      cmake
      clang-tools
      glsl_analyzer
      go
      gopls
      delve
      golangci-lint
      richgo
      zig
      zls
      rustc
      cargo
      rust-analyzer
      rustfmt
      nixd
      nixfmt
      lua-language-server
      nodejs-slim
      typescript-language-server
      (python3.withPackages (
        python-pkgs: with python-pkgs; [
          python-lsp-server
          python-lsp-ruff
        ]
      ))
      kubectl

      swappy
      telegram-desktop
      vesktop
      mattermost-desktop
      thunderbird-latest
      libreoffice-fresh
    ];

    home.stateVersion = "24.05";
  };
}

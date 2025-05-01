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
      typescript-language-server
      (python3.withPackages (
        python-pkgs: with python-pkgs; [
          python-lsp-server
          python-lsp-ruff
        ]
      ))
      kubectl

      satty
      telegram-desktop
      mattermost-desktop
      thunderbird-latest
      libreoffice-fresh
    ];

    home.stateVersion = "24.05";
  };
}

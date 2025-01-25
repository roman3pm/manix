{ pkgs, inputs, ... }:
{
  home-manager.users.roz = {

    imports = [ inputs.nix-index-database.hmModules.nix-index ];

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
      pyright
      typescript-language-server
      kubectl

      swappy
      thunderbird
      libreoffice-fresh
    ];

    home.stateVersion = "24.05";
  };

  services.flatpak = {
    enable = true;
    packages = [
      "com.github.tchx84.Flatseal"
      "org.telegram.desktop"
      "com.mattermost.Desktop"
      "com.transmissionbt.Transmission"
    ];
  };
}

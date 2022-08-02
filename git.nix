{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "Roman Zakirzyanov";
    userEmail = "roman3pm@yandex.ru";
    extraConfig = {
      push.default = "current";
      pull.ff = "only";
      core.qoutePath = false;
      merge.confictStyle = "diff3";
      core.editor = "${pkgs.neovim}/bin/nvim";
    };
  };
}

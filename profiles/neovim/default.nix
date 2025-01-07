{ pkgs, lib, ... }:
{
  home-manager.users.roz = {
    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      withNodeJs = false;
      withRuby = false;
      withPython3 = false;
      plugins = with pkgs.vimPlugins; [
        plenary-nvim
        vscode-nvim
        indent-blankline-nvim
        lualine-nvim
        nvim-web-devicons
        nvim-bqf
        nvim-tree-lua
        telescope-nvim
        telescope-fzf-native-nvim
        telescope-ui-select-nvim
        gitsigns-nvim
        gen-nvim
        nvim-treesitter.withAllGrammars
        rest-nvim

        nvim-lspconfig
        nvim-cmp
        luasnip
        cmp_luasnip
        cmp-path
        cmp-buffer
        cmp-cmdline
        cmp-ai
        cmp-nvim-lsp
        cmp-nvim-lsp-signature-help
      ];
      extraLuaPackages = ps: [ ps.jsregexp ];
      extraConfig = ''
        lua << EOF
        ${lib.strings.fileContents ./init.lua}
        ${lib.strings.fileContents ./lsp.lua}
        EOF
      '';
    };

    xdg = {
      configFile = {
        "nvim/syntax/qf.vim".source = ./qf.vim;
      };
      mimeApps.defaultApplications = {
        "text/plain" = "nvim.desktop";
      };
    };

    home.sessionVariables = {
      EDITOR = "vim";
      VISUAL = "vim";
    };
  };
}

{ pkgs, lib, ... }: {
  home-manager.users.roz = {
    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      withNodeJs = false;
      withRuby = false;
      withPython3 = false;
      plugins = with pkgs.vimPlugins; [
        vim-suda
        fzf-vim
        plenary-nvim

        tokyonight-nvim
        indent-blankline-nvim
        lualine-nvim
        nvim-web-devicons
        nvim-bqf
        nvim-tree-lua
        nvim-autopairs
        telescope-nvim
        telescope-fzf-native-nvim
        telescope-ui-select-nvim
        gitsigns-nvim
        nvim-treesitter.withAllGrammars
        render-markdown
        gen-nvim

        nvim-lspconfig
        nvim-cmp
        luasnip
        cmp_luasnip
        cmp-path
        cmp-buffer
        cmp-cmdline
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
      desktopEntries = {
        nvim-alacritty = {
          name = "Neovim";
          genericName = "Text Editor";
          exec = "alacritty --title Neovim --class nvim -e nvim %F";
          icon = "nvim";
          terminal = false;
          mimeType = [ "text/plain" ];
        };
      };
      mimeApps = {
        defaultApplications = {
          "text/plain" = "nvim-alacritty.desktop";
        };
      };
    };

    home.sessionVariables = {
      EDITOR = "vim";
      VISUAL = "vim";
    };
  };
}

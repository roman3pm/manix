{ pkgs, lib, ... }: {
  home-manager.users.roz = {
    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      plugins = with pkgs.vimPlugins; [
        vim-suda
        fzf-vim
        plenary-nvim

        tokyonight-nvim
        indent-blankline-nvim
        lualine-nvim
        tabline-nvim
        nvim-web-devicons
        nvim-bqf
        nvim-tree-lua
        telescope-nvim
        telescope-fzf-native-nvim
        telescope-ui-select-nvim
        gitsigns-nvim
        (nvim-treesitter.withPlugins (plugins: with plugins; [
          nix
          cpp
          make
          cmake
          glsl
          go
          rust
          toml
          javascript
          html
          css
          json
          yaml
        ]))

        nvim-lspconfig
        nvim-cmp
        luasnip
        cmp_luasnip
        cmp-path
        cmp-buffer
        cmp-cmdline
        cmp-treesitter
        cmp-nvim-lsp
        lspkind-nvim
        lsp_signature-nvim
        gen-nvim
        llm-nvim
      ];
      extraLuaPackages = ps: [ ps.jsregexp ];
      extraConfig = ''
        lua << EOF
        local llm_ls_bin_path = "${pkgs.llm-ls}/bin/llm-ls"
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
  };
}

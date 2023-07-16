{ pkgs, lib, ... }: {
  home-manager.users.roz.programs.neovim = {
    enable = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      suda-vim
      fzf-vim
      plenary-nvim

      tokyonight-nvim
      indent-blankline-nvim
      nvim-autopairs
      lualine-nvim
      tabline-nvim
      nvim-web-devicons
      nvim-bqf
      nvim-tree-lua
      telescope-nvim
      telescope-fzy-native-nvim
      gitsigns-nvim
      nvim-treesitter-context
      (nvim-treesitter.withPlugins (plugins: with plugins; [
        nix
        lua
        scala
        java
        javascript
        yaml
        python
        go
        rust
        c
        cpp
      ]))

      nvim-lspconfig
      nvim-cmp
      luasnip
      cmp_luasnip
      cmp-path
      cmp-buffer
      cmp-cmdline
      cmp-treesitter
      cmp-nvim-lua
      cmp-nvim-lsp
      lspkind-nvim
      lsp_signature-nvim
      copilot-lua
    ];
    extraConfig = ''
      lua << EOF
      ${lib.strings.fileContents ./neovim/init.lua}
      ${lib.strings.fileContents ./neovim/lsp.lua}
      EOF
    '';
  };
}

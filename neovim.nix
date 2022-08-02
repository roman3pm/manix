{ pkgs, lib, ... }: {
  programs.neovim = {
    enable = true;
    vimAlias = true;
    withNodeJs = true;
    withPython3 = true;
    plugins = with pkgs.vimPlugins; [
      suda-vim
      fzf-vim
      plenary-nvim

      gitsigns-nvim
      diffview-nvim

      gruvbox-nvim
      nvim-treesitter
      indent-blankline-nvim
      nvim-autopairs
      nvim-cursorline
      lualine-nvim
      tabline-nvim
      lualine-lsp-progress
      nvim-web-devicons
      nvim-bqf
      nvim-tree-lua
      telescope-nvim
      telescope-fzy-native-nvim

      nvim-lspconfig
      nvim-metals
      nvim-dap
      nvim-cmp
      luasnip
      cmp_luasnip
      cmp-path
      cmp-buffer
      cmp-cmdline
      cmp-treesitter
      cmp-nvim-lua
      cmp-nvim-lsp
      lsp_signature-nvim
    ];
    extraConfig = ''
      lua << EOF
      ${lib.strings.fileContents ./neovim/init.lua}
      ${lib.strings.fileContents ./neovim/lsp.lua}
      EOF
    '';
  };
}

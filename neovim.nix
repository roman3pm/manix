{ pkgs, lib, ... }: {
  programs.neovim = {
    enable = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      gruvbox
      indentLine
      suda-vim
      vim-fugitive
      vim-unimpaired
      vim-flog
      vim-gitgutter
      vim-nix
      vim-json
      vim-javascript
      vim-jsx-pretty
      vim-airline
      vim-devicons
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      luasnip
      cmp_luasnip
      telescope-nvim
      telescope-fzy-native-nvim
    ];
    extraConfig = ''
      set path+=**
      set number
      set signcolumn=yes
      filetype plugin indent on
      set expandtab
      set tabstop=2
      set softtabstop=2
      set shiftwidth=2

      colorscheme gruvbox

      let g:airline_powerline_fonts = 1
      let g:airline#extensions#tabline#enabled = 1
      let g:airline#extensions#tabline#formatter = 'unique_tail'

      :lua << EOF
      ${lib.strings.fileContents ./neovim/init.lua}
      EOF
    '';
  };
}

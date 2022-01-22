{ pkgs, lib, ... }: {
  programs.neovim = {
    enable = true;
    vimAlias = true;
    withPython3 = true;
    withNodeJs = true;
    plugins = with pkgs.vimPlugins; [
      gruvbox
      vim-fugitive
      vim-unimpaired
      vim-flog
      vim-gitgutter
      vim-nix
      vim-json
      vim-airline
      vim-devicons
      nvim-cmp
      cmp-nvim-lsp
      vim-vsnip
      cmp-vsnip
      plenary-nvim
      nvim-metals
      indentLine
      telescope-nvim
      nvim-lspconfig
      telescope-fzy-native-nvim
    ];
    extraConfig = ''
      set path+=**
      set number
      set signcolumn=number
      colorscheme gruvbox

      let g:airline_powerline_fonts = 1
      let g:airline#extensions#tabline#enabled = 1
      let g:airline#extensions#tabline#formatter = 'unique_tail'

      :lua << EOF
      ${lib.strings.fileContents ./neovim/metals.lua}
      EOF
    '';
  };
}

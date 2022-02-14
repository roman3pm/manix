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
      set listchars=eol:↵
      set list
      set updatetime=100

      autocmd VimEnter * hi Normal ctermbg=none
      colorscheme gruvbox
      let g:gruvbox_transparent_bg=1
      let g:gruvbox_italic=1

      nnoremap <silent> [oh :call gruvbox#hls_show()<CR>
      nnoremap <silent> ]oh :call gruvbox#hls_hide()<CR>
      nnoremap <silent> coh :call gruvbox#hls_toggle()<CR>

      nnoremap * :let @/ = ""<CR>:call gruvbox#hls_show()<CR>*
      nnoremap / :let @/ = ""<CR>:call gruvbox#hls_show()<CR>/
      nnoremap ? :let @/ = ""<CR>:call gruvbox#hls_show()<CR>?

      let g:airline_powerline_fonts = 1
      let g:airline#extensions#tabline#enabled = 1
      let g:airline#extensions#tabline#formatter = 'unique_tail'

      :lua << EOF
      ${lib.strings.fileContents ./neovim/init.lua}
      EOF
    '';
  };
}

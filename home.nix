{ config, pkgs, ... }:
let
  colors = import ./colors.nix;
in {
  programs.home-manager.enable = true;

  home.username = "roz";
  home.homeDirectory = "/home/roz";

  wayland.windowManager.sway =
    let
      ws1 = "1:web";
      ws2 = "2:term";
      ws3 = "3:code";
      ws4 = "4:msg";
      ws5 = "5";
      ws6 = "6";
      ws7 = "7";
      ws8 = "8";
      ws9 = "9";
    in {
      enable = true;
      wrapperFeatures.gtk = true;
      config = {
        fonts = {
          names = [ "JetBrains Mono" ];
          size = 9.0;
        };
        gaps = {
          inner = 10;
          outer = 5;
        };
        terminal = "alacritty";
        modifier = "Mod4";
        bars = [{
          statusCommand = "${pkgs.i3status}/bin/i3status";
          command = "${pkgs.sway}/bin/swaybar";
          position = "bottom";
          fonts = {
            names = [ "JetBrains Mono" ];
            size = 9.0;
          };
          trayOutput = "*";
          colors = {
            background = "#${colors.bg1}";
            statusline = "#${colors.fg}";
            separator = "#${colors.fg}";
            focusedWorkspace = {
              border = "#${colors.bg2}";
              background = "#${colors.br_yellow}";
              text = "#${colors.bg}";
            };
            activeWorkspace = {
              border = "#${colors.bg2}";
              background = "#${colors.bg1}";
              text = "#${colors.fg}";
            };
            inactiveWorkspace = {
              border = "#${colors.bg2}";
              background = "#${colors.bg1}";
              text = "#${colors.fg}";
            };
            urgentWorkspace = {
              border = "#${colors.bg2}";
              background = "#${colors.red}";
              text = "#${colors.fg}";
            };
          };
        }];
        colors = {
          focused = {
            border = "#${colors.blue}";
            background = "#${colors.blue}";
            text = "#${colors.fg}";
            indicator = "#${colors.blue}";
            childBorder = "#${colors.blue}";
          };
          focusedInactive = {
            border = "#${colors.bg2}";
            background = "#${colors.bg2}";
            text = "#${colors.fg}";
            indicator = "#${colors.bg2}";
            childBorder = "#${colors.bg2}";
          };
          unfocused = {
            border = "#${colors.bg1}";
            background = "#${colors.bg1}";
            text = "#${colors.fg}";
            indicator = "#${colors.bg1}";
            childBorder = "#${colors.bg1}";
          };
          urgent = {
            border = "#${colors.red}";
            background = "#${colors.red}";
            text = "#${colors.fg}";
            indicator = "#${colors.red}";
            childBorder = "#${colors.red}";
          };
        };
        menu = "bemenu-run -m all --fn 'JetBrains Mono' --tf '#${colors.green}' --ff '#${colors.fg}' --nf '#${colors.fg}' --hf '#${colors.blue}' --no-exec | xargs swaymsg exec --";
        startup = [
          { command = "${pkgs.mako}/bin/mako"; }
          { command =
              let lockCmd = "'${pkgs.swaylock}/bin/swaylock -f -i ~/Downloads/gruvbox.png'";
              in ''
                ${pkgs.swayidle}/bin/swayidle -w \
                timeout 600 ${lockCmd} \
                timeout 1200 'swaymsg "output * dpms off"' \
                resume 'swaymsg "output * dpms on"' \
                before-sleep ${lockCmd}
              '';
          }
          { command = "${pkgs.google-chrome}/bin/google-chrome-stable"; }
          { command = "${pkgs.tdesktop}/bin/telegram-desktop"; }
          { command = "${pkgs.slack}/bin/slack"; }
        ];
        input = {
          "type:keyboard" = {
            xkb_layout = "us,ru";
            xkb_options = "grp:alt_shift_toggle";
          };
          "type:touchpad" = { tap = "enabled"; };
        };
        output = { "*".bg = "~/Downloads/gruvbox.png fill"; };
        keybindings =
          let
            mod = config.wayland.windowManager.sway.config.modifier;
            inherit (config.wayland.windowManager.sway.config) menu terminal;
          in {
            "${mod}+d" = "exec ${menu}";
            "${mod}+Return" = "exec ${terminal}";
            "${mod}+Shift+q" = "kill";

            "${mod}+Left" = "focus left";
            "${mod}+Down" = "focus down";
            "${mod}+Up" = "focus up";
            "${mod}+Right" = "focus right";

            "${mod}+Shift+Left" = "move left";
            "${mod}+Shift+Down" = "move down";
            "${mod}+Shift+Up" = "move up";
            "${mod}+Shift+Right" = "move right";

            "${mod}+Shift+Space" = "floating toggle";
            "${mod}+Space" = "focus mode_toggle";

            "${mod}+1" = "workspace ${ws1}";
            "${mod}+2" = "workspace ${ws2}";
            "${mod}+3" = "workspace ${ws3}";
            "${mod}+4" = "workspace ${ws4}";
            "${mod}+5" = "workspace ${ws5}";
            "${mod}+6" = "workspace ${ws6}";
            "${mod}+7" = "workspace ${ws7}";
            "${mod}+8" = "workspace ${ws8}";
            "${mod}+9" = "workspace ${ws9}";

            "${mod}+Shift+1" = "move container to workspace ${ws1}";
            "${mod}+Shift+2" = "move container to workspace ${ws2}";
            "${mod}+Shift+3" = "move container to workspace ${ws3}";
            "${mod}+Shift+4" = "move container to workspace ${ws4}";
            "${mod}+Shift+5" = "move container to workspace ${ws5}";
            "${mod}+Shift+6" = "move container to workspace ${ws6}";
            "${mod}+Shift+7" = "move container to workspace ${ws7}";
            "${mod}+Shift+8" = "move container to workspace ${ws8}";
            "${mod}+Shift+9" = "move container to workspace ${ws9}";

            "${mod}+h" = "split h";
            "${mod}+v" = "split v";
            "${mod}+f" = "fullscreen toggle";
            "${mod}+comma" = "layout stacking";
            "${mod}+period" = "layout tabbed";
            "${mod}+slash" = "layout toggle split";
            "${mod}+a" = "focus parent";
            "${mod}+s" = "focus child";

            "${mod}+Shift+c" = "reload";
            "${mod}+Shift+r" = "restart";
            "${mod}+Shift+v" = ''mode "system:  [r]eboot  [p]oweroff  [l]ogout"'';

            "${mod}+r" = "mode resize";

            "${mod}+p" = "exec ${pkgs.slurp}/bin/slurp | ${pkgs.grim}/bin/grim -g- Pictures/screenshot-$(date +%Y%m%d-%H%M).png";
            "${mod}+l" = "exec ${pkgs.swaylock}/bin/swaylock -i ~/Downloads/gruvbox.png";
            "${mod}+k" = "exec ${pkgs.mako}/bin/makoctl invoke";
            "${mod}+Shift+k" = "exec ${pkgs.mako}/bin/makoctl dismiss -a";

            "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
            "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
            "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
            "XF86AudioMicMute" = "exec pactl set-source-mute @DEFAULT_SOURCE@ toggle";

            "XF86MonBrightnessUp" = "exec brightnessctl s +10%";
            "XF86MonBrightnessDown" = "exec brightnessctl s 10%-";
          };
          modes = {
            "system:  [r]eboot  [p]oweroff  [l]ogout" = {
              r = "exec reboot";
              p = "exec poweroff";
              l = "exit";
              Return = "mode default";
              Escape = "mode default";
            };
            resize = {
              Left = "resize shrink width";
              Right = "resize grow width";
              Down = "resize shrink height";
              Up = "resize grow height";
              Return = "mode default";
              Escape = "mode default";
            };
          };
          assigns = {
            "${ws1}" = [{ class = "^Google-chrome$"; }];
            "${ws4}" = [
              { app_id = "^telegramdesktop$"; }
              { class  = "^Slack$"; }
            ];
          };
        };
      };

      fonts.fontconfig.enable = true;

      home.packages = with pkgs; [
        slurp
        grim
        imv
        mpv
        neofetch
        git
        jq

        jre8
        jdk8
        (sbt.override { jre = pkgs.jdk8; })
        bloop
        nodejs

        google-chrome
        firefox
        tdesktop
        slack
        thunderbird-wayland
        keepassxc

        swaylock
        swayidle
        wl-clipboard
        brightnessctl
        pavucontrol
        bemenu
        jetbrains-mono
        powerline-fonts
      ];

      xdg.configFile."nvim/coc-settings.json".source =
        pkgs.writeTextFile {
          name = "coc-settings.json";
          text = ''
            {
              "codeLens.enable": true,
              "metals": {
                "javaHome": "${pkgs.jdk8}",
                "statusBarEnabled": true,
                "enableIndentOnPaste": true
              },
              "coc.preferences": {
                "formatOnType": true,
                "formatOnSaveFiletypes": ["scala"]
              }
            }
          '';
      };
      programs.neovim = {
        enable = true;
        vimAlias = true;
        withPython3 = true;
        withNodeJs = true;
        plugins = with pkgs.vimPlugins; [ vim-nix vim-fugitive vim-unimpaired vim-flog vim-gitgutter vim-airline gruvbox coc-nvim coc-metals vimspector ];
        extraConfig = ''
          set number
          colorscheme gruvbox

          let g:airline#extensions#coc#enabled = 1
          let g:airline#extensions#coc#show_coc_status = 1
          let g:airline_powerline_fonts = 1
          let g:airline#extensions#tabline#enabled = 1
          let g:airline#extensions#tabline#formatter = 'unique_tail'

          " Help Vim recognize *.sbt and *.sc as Scala files
          au BufRead,BufNewFile *.sbt,*.sc set filetype=scala

          " Used to expand decorations in worksheets
          nmap <Leader>ws <Plug>(coc-metals-expand-decoration)

          " Toggle panel with Tree Views
          nnoremap <silent> <space>t :<C-u>CocCommand metals.tvp<CR>
          " Toggle Tree View 'metalsPackages'
          nnoremap <silent> <space>tp :<C-u>CocCommand metals.tvp metalsPackages<CR>
          " Toggle Tree View 'metalsCompile'
          nnoremap <silent> <space>tc :<C-u>CocCommand metals.tvp metalsCompile<CR>
          " Toggle Tree View 'metalsBuild'
          nnoremap <silent> <space>tb :<C-u>CocCommand metals.tvp metalsBuild<CR>
          " Reveal current current class (trait or object) in Tree View 'metalsPackages'
          nnoremap <silent> <space>tf :<C-u>CocCommand metals.revealInTreeView metalsPackages<CR>
          " Set internal encoding of vim, not needed on neovim, since coc.nvim using some
          " unicode characters in the file autoload/float.vim
          set encoding=utf-8

          " TextEdit might fail if hidden is not set.
          set hidden

          " Some servers have issues with backup files, see #649.
          set nobackup
          set nowritebackup

          " Give more space for displaying messages.
          set cmdheight=2

          " Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
          " delays and poor user experience.
          set updatetime=300

          " Don't pass messages to |ins-completion-menu|.
          set shortmess+=c

          " Always show the signcolumn, otherwise it would shift the text each time
          " diagnostics appear/become resolved.
          if has("nvim-0.5.0") || has("patch-8.1.1564")
          " Recently vim can merge signcolumn and number column into one
          set signcolumn=number
          else
          set signcolumn=yes
          endif

          " Use tab for trigger completion with characters ahead and navigate.
          " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
          " other plugin before putting this into your config.
          inoremap <silent><expr> <TAB>
            \ pumvisible() ? "\<C-n>" :
            \ <SID>check_back_space() ? "\<TAB>" :
            \ coc#refresh()
          inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

          function! s:check_back_space() abort
          let col = col('.') - 1
          return !col || getline('.')[col - 1]  =~# '\s'
          endfunction

          " Use <c-space> to trigger completion.
          if has('nvim')
          inoremap <silent><expr> <c-space> coc#refresh()
          else
          inoremap <silent><expr> <c-@> coc#refresh()
          endif

          " Make <CR> auto-select the first completion item and notify coc.nvim to
          " format on enter, <cr> could be remapped by other vim plugin
          inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                                    \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

          " Use `[g` and `]g` to navigate diagnostics
          " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
          nmap <silent> [g <Plug>(coc-diagnostic-prev)
          nmap <silent> ]g <Plug>(coc-diagnostic-next)

          " GoTo code navigation.
          nmap <silent> gd <Plug>(coc-definition)
          nmap <silent> gy <Plug>(coc-type-definition)
          nmap <silent> gi <Plug>(coc-implementation)
          nmap <silent> gr <Plug>(coc-references)

          " Use K to show documentation in preview window.
          nnoremap <silent> K :call <SID>show_documentation()<CR>

          function! s:show_documentation()
          if (index(['vim','help'], &filetype) >= 0)
          execute 'h '.expand('<cword>')
          elseif (coc#rpc#ready())
          call CocActionAsync('doHover')
          else
          execute '!' . &keywordprg . " " . expand('<cword>')
          endif
          endfunction

          " Highlight the symbol and its references when holding the cursor.
          autocmd CursorHold * silent call CocActionAsync('highlight')

          " Symbol renaming.
          nmap <leader>rn <Plug>(coc-rename)

          " Formatting selected code.
          xmap <leader>f  <Plug>(coc-format-selected)
          nmap <leader>f  <Plug>(coc-format-selected)

          augroup mygroup
          autocmd!
          " Setup formatexpr specified filetype(s).
          autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
          " Update signature help on jump placeholder.
          autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
          augroup end

          " Applying codeAction to the selected region.
          " Example: `<leader>aap` for current paragraph
          xmap <leader>a  <Plug>(coc-codeaction-selected)
          nmap <leader>a  <Plug>(coc-codeaction-selected)

          " Remap keys for applying codeAction to the current buffer.
          nmap <leader>ac  <Plug>(coc-codeaction)
          " Apply AutoFix to problem on the current line.
          nmap <leader>qf  <Plug>(coc-fix-current)

          " Run the Code Lens action on the current line.
          nmap <leader>cl  <Plug>(coc-codelens-action)

          " Map function and class text objects
          " NOTE: Requires 'textDocument.documentSymbol' support from the language server.
          xmap if <Plug>(coc-funcobj-i)
          omap if <Plug>(coc-funcobj-i)
          xmap af <Plug>(coc-funcobj-a)
          omap af <Plug>(coc-funcobj-a)
          xmap ic <Plug>(coc-classobj-i)
          omap ic <Plug>(coc-classobj-i)
          xmap ac <Plug>(coc-classobj-a)
          omap ac <Plug>(coc-classobj-a)

          " Remap <C-f> and <C-b> for scroll float windows/popups.
          if has('nvim-0.4.0') || has('patch-8.2.0750')
          nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
          nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
          inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
          inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
          vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
          vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
          endif

          " Use CTRL-S for selections ranges.
          " Requires 'textDocument/selectionRange' support of language server.
          nmap <silent> <C-s> <Plug>(coc-range-select)
          xmap <silent> <C-s> <Plug>(coc-range-select)

          " Add `:Format` command to format current buffer.
          command! -nargs=0 Format :call CocActionAsync('format')

          " Add `:Fold` command to fold current buffer.
          command! -nargs=? Fold :call     CocAction('fold', <f-args>)

          " Add `:OR` command for organize imports of the current buffer.
          command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

          " Add (Neo)Vim's native statusline support.
          " NOTE: Please see `:h coc-status` for integrations with external plugins that
          " provide custom statusline: lightline.vim, vim-airline.
          set statusline^=%{coc#status()}%{get(b:,'coc_current_function',\'\')}

          " Mappings for CoCList
          " Show all diagnostics.
          nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
          " Manage extensions.
          nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
          " Show commands.
          nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
          " Find symbol of current document.
          nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
          " Search workspace symbols.
          nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
          " Do default action for next item.
          nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
          " Do default action for previous item.
          nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
          " Resume latest coc list.
          nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
        '';
      };
      programs.alacritty = {
        enable = true;
        settings = {
          background_opacity = 0.97;
          colors = {
            primary = {
              background = "0x${colors.bg}";
              foreground = "0x${colors.fg}";
            };
            normal = {
              black   = "0x${colors.bg1}";
              red     = "0x${colors.red}";
              green   = "0x${colors.green}";
              yellow  = "0x${colors.yellow}";
              blue    = "0x${colors.blue}";
              magneta = "0x${colors.purple}";
              cyan    = "0x${colors.aqua}";
              white   = "0x${colors.fg}";
            };
            bright = {
              black   = "0x${colors.bg2}";
              red     = "0x${colors.br_red}";
              green   = "0x${colors.br_green}";
              yellow  = "0x${colors.br_yellow}";
              blue    = "0x${colors.br_blue}";
              magenta = "0x${colors.br_purple}";
              cyan    = "0x${colors.br_aqua}";
              white   = "0x${colors.fg0}";
            };
          };
          font = {
            normal = { family = "JetBrains Mono"; };
            bold   = { family = "JetBrains Mono"; style = "Bold"; };
            italic = { family = "JetBrains Mono"; stype = "Italic"; };
          };
        };
      };
      programs.mako = {
        enable = true;
        anchor = "bottom-right";
        font = "JetBrains Mono 9";
        backgroundColor = "#${colors.bg1}";
        borderColor = "#${colors.bg2}";
        textColor = "#${colors.fg}";
        borderRadius = 5;
      };

      services.mpd.enable = true;

      home.stateVersion = "21.05";
}

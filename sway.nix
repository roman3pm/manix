{ config, pkgs, lib, ... }:
let
  fonts = import ./fonts.nix;
  hostName = "roz-pc";
  ws1 = "1:web";
  ws2 = "2:term";
  ws3 = "3:code";
  ws4 = "4:chat";
  ws5 = "5:mail";
  ws6 = "6:game";
  ws7 = "7:other";
in {
  wayland.windowManager.sway =
    let
      terminalCmd = "${pkgs.alacritty}/bin/alacritty";
    in {
      enable = true;
      wrapperFeatures.gtk = true;
      extraSessionCommands = ''
        export MOZ_ENABLE_WAYLAND=1
        export XDG_CURRENT_DESKTOP=sway
        export BEMENU_BACKEND=wayland
        export SDL_VEDEODRIVER=wayland
        # needs qt5.qtwayland in systemPackages
        export QT_QPA_PLATFORM=wayland
        export QT_QPA_PLATFORMTHEME=gtk2
        export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
        # Fix for some Java AWT applications (e.g. Android Studio),
        # use this if they aren't displayed properly:
        export _JAVA_AWT_WM_NONREPARENTING=1
      '';
      config = {
        fonts = fonts.fontConfig;
        gaps = {
          inner = 6;
          outer = 3;
        };
        terminal = terminalCmd;
        modifier = "Mod4";
        focus = {
          followMouse = "no";
          mouseWarping = false;
        };
        bars = [];
        menu = ''
          ${pkgs.bemenu}/bin/bemenu-run -m all -H 30 --fn '${builtins.head fonts.fontConfig.names}' --no-exec | xargs swaymsg exec --
        '';
        startup = [
          { always = true; command = "${pkgs.corectrl}/bin/corectrl --minimize-systray"; }
          { always = true; command = "${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface cursor-theme 'Quintom_Snow'"; }
          { command = "${pkgs.mako}/bin/mako"; }
          { command =
            let lockCmd = "'${pkgs.swaylock}/bin/swaylock -f -i ~/.config/nixpkgs/wallpapers/2.jpg'";
            in ''
                ${pkgs.swayidle}/bin/swayidle -w \
                timeout 600 ${lockCmd} \
                timeout 1200 'swaymsg "output * dpms off"' \
                resume 'swaymsg "output * dpms on"' \
                before-sleep ${lockCmd}
            '';
          }
          { command = "${pkgs.gammastep}/bin/gammastep -l 55.75:37.80"; }
          { command = "sleep 2 && ${pkgs.discord}/bin/discord"; }
          { command = "sleep 2 && ${pkgs.slack}/bin/slack"; }
          { command = "sleep 2 && ${pkgs.tdesktop}/bin/telegram-desktop"; }
          { command = "${pkgs.bitwarden}/bin/bitwarden"; }
          { command = "sleep 2 && ${pkgs.thunderbird}/bin/thunderbird"; }
          { command = "sleep 2 && ${pkgs.firefox-wayland}/bin/firefox"; }
        ];
        input = {
          "type:keyboard" = {
            xkb_layout = "us,ru";
            xkb_options = "grp:shift_caps_toggle";
          };
          "type:touchpad" = { tap = "enabled"; };
          "type:pointer" = {
            accel_profile = "flat";
            pointer_accel = "0";
            scroll_method = "on_button_down";
            scroll_button = "274";
          };
        };
        output = {
          "*" = {
            bg = "~/.config/nixpkgs/wallpapers/2.jpg fill";
          };
          "DP-1" = {
            pos = "0 0";
            mode = "2560x1440@144Hz";
            adaptive_sync = "on";
          };
          "HDMI-A-1" = {
            pos = "2560 0";
            mode = "1920x1080@75Hz";
            transform = "270";
          };
        };
        bindkeysToCode = true;
        keybindings =
          let
            mod = config.wayland.windowManager.sway.config.modifier;
            inherit (config.wayland.windowManager.sway.config) menu terminal;
          in {
            "${mod}+d"            = "exec ${menu}";
            "${mod}+Return"       = "exec ${terminal}";
            "${mod}+Shift+Return" = "exec ${terminal} --class Alacritty_floating";
            "${mod}+Shift+q"      = "kill";

            "${mod}+Left"  = "focus left";
            "${mod}+Down"  = "focus down";
            "${mod}+Up"    = "focus up";
            "${mod}+Right" = "focus right";

            "${mod}+Shift+Left"  = "move left";
            "${mod}+Shift+Down"  = "move down";
            "${mod}+Shift+Up"    = "move up";
            "${mod}+Shift+Right" = "move right";

            "${mod}+Shift+Space" = "floating toggle";
            "${mod}+Space"       = "focus mode_toggle";

            "${mod}+1" = "workspace ${ws1}";
            "${mod}+2" = "workspace ${ws2}";
            "${mod}+3" = "workspace ${ws3}";
            "${mod}+4" = "workspace ${ws4}";
            "${mod}+5" = "workspace ${ws5}";
            "${mod}+6" = "workspace ${ws6}";
            "${mod}+7" = "workspace ${ws7}";

            "${mod}+Shift+1" = "move container to workspace ${ws1}";
            "${mod}+Shift+2" = "move container to workspace ${ws2}";
            "${mod}+Shift+3" = "move container to workspace ${ws3}";
            "${mod}+Shift+4" = "move container to workspace ${ws4}";
            "${mod}+Shift+5" = "move container to workspace ${ws5}";
            "${mod}+Shift+6" = "move container to workspace ${ws6}";
            "${mod}+Shift+7" = "move container to workspace ${ws7}";

            "${mod}+h"      = "split h";
            "${mod}+v"      = "split v";
            "${mod}+f"      = "fullscreen toggle";
            "${mod}+comma"  = "layout stacking";
            "${mod}+period" = "layout tabbed";
            "${mod}+slash"  = "layout toggle split";
            "${mod}+a"      = "focus parent";
            "${mod}+s"      = "focus child";

            "${mod}+Shift+c" = "reload";
            "${mod}+Shift+r" = "restart";
            "${mod}+Shift+v" = ''mode "system:  [r]eboot  [p]oweroff  [l]ogout"'';

            "${mod}+r" = "mode resize";

            "${mod}+p"       = "exec ${pkgs.slurp}/bin/slurp | ${pkgs.grim}/bin/grim -g- ~/Pictures/screenshot-$(date +%Y%m%d-%H%M).png";
            "${mod}+Shift+p" = "exec ${pkgs.slurp}/bin/slurp | ${pkgs.grim}/bin/grim -g - - | wl-copy";
            "${mod}+l"       = "exec ${pkgs.swaylock}/bin/swaylock -i ~/.config/nixpkgs/wallpapers/2.jpg";
            "${mod}+k"       = "exec ${pkgs.mako}/bin/makoctl invoke";
            "${mod}+Shift+k" = "exec ${pkgs.mako}/bin/makoctl dismiss -a";

            "XF86AudioMute"        = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
            "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
            "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
            "XF86AudioMicMute"     = "exec pactl set-source-mute @DEFAULT_SOURCE@ toggle";

            "XF86MonBrightnessUp"   = "exec brightnessctl s +10%";
            "XF86MonBrightnessDown" = "exec brightnessctl s 10%-";
          };
        modes = {
          "system:  [r]eboot  [p]oweroff  [l]ogout" = {
            r      = "exec reboot";
            p      = "exec poweroff";
            l      = "exit";
            Return = "mode default";
            Escape = "mode default";
          };
          resize = {
            Left   = "resize shrink width";
            Right  = "resize grow width";
            Down   = "resize shrink height";
            Up     = "resize grow height";
            Return = "mode default";
            Escape = "mode default";
          };
        };
        assigns = {
          "${ws1}"= [
            { app_id = "^firefox$"; }
          ];
          "${ws4}" = [
            { app_id = "^telegramdesktop$"; }
            { class  = "^Slack$"; }
            { class  = "^discord$"; }
          ];
          "${ws5}" = [
            { class = "^Bitwarden$"; }
            { app_id = "^thunderbird$"; }
          ];
          "${ws6}" = [
            { class = "^Steam$"; }
            { app_id = "^lutris$"; }
          ];
        };
        workspaceOutputAssign = lib.mkIf (hostName == "roz-pc") [
          { workspace = ws1; output = "DP-1"; }
          { workspace = ws2; output = "DP-1"; }
          { workspace = ws3; output = "DP-1"; }
          { workspace = ws4; output = "HDMI-A-1"; }
          { workspace = ws5; output = "HDMI-A-1"; }
          { workspace = ws6; output = "DP-1"; }
        ];
      };
      extraConfig = ''
        for_window [app_id="Alacritty_floating"] floating enable
        for_window [class="install4j.*"] floating enable
        for_window [class="Steam"] floating enable
        for_window [app_id="lutris"] floating enable
        for_window [class=".*\.exe"] floating enable
      '';
    };
 }

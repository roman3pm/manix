{ config, pkgs, lib, ... }:
let
  fonts = import ./fonts.nix;
  ws1 = "1:http";
  ws2 = "2:chat";
  ws3 = "3:code";
  ws4 = "4:mail";
  ws5 = "5:game";
in
{
  home-manager.users.roz.wayland.windowManager.sway =
    let
      terminal = "${pkgs.alacritty}/bin/alacritty";
      modifier = "Mod4";
      menu = ''
        ${pkgs.bemenu}/bin/bemenu-run -m all -H 31 --fn '${builtins.head fonts.fontConfig.names} 12' --no-exec | xargs swaymsg exec --
      '';
      lockCmd = ''
        ${pkgs.swaylock}/bin/swaylock -f \
        -i ${./wallpapers/mox.jpg} \
        --indicator-idle-visible \
        --indicator-thickness 6 \
        --text-color a9a9a9 \
        --ring-color bb00cc \
        --line-color 00000000 \
        --inside-color 00000088 \
        --separator-color 00000000 \
        --layout-bg-color 00000088 \
        --layout-text-color a9a9a9 \
      '';
      modeSystem = " system: [s]uspend [r]eboot [p]oweroff";
      modeResize = " resize";
    in
    {
      enable = true;
      wrapperFeatures.gtk = true;
      extraSessionCommands = ''
        export MOZ_ENABLE_WAYLAND=1
        export XDG_CURRENT_DESKTOP=sway
        export XDG_SESSION_TYPE=wayland
        export BEMENU_BACKEND=wayland
        export SDL_VEDEODRIVER=wayland
        # needs qt5.qtwayland in systemPackages
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
        # Fix for some Java AWT applications (e.g. Android Studio),
        # use this if they aren't displayed properly:
        export _JAVA_AWT_WM_NONREPARENTING=1
      '';
      config = {
        inherit terminal modifier menu;
        fonts = fonts.fontConfig;
        gaps = {
          inner = 8;
          outer = 2;
        };
        focus = {
          followMouse = "no";
          mouseWarping = false;
        };
        bars = [ ];
        startup = [
          { command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"; }
          { command = "${pkgs.corectrl}/bin/corectrl --minimize-systray"; }
          { command = "ssh-add < /dev/null"; }
          { command = "${pkgs.waybar}/bin/waybar"; }
          { command = "${pkgs.mako}/bin/mako"; }
          {
            command = ''
              ${pkgs.swayidle}/bin/swayidle -w \
              timeout 600 '${lockCmd}' \
              timeout 1200 'swaymsg "output * dpms off"' \
              resume 'swaymsg "output * dpms on"' \
              before-sleep '${lockCmd}'
            '';
          }
          { command = "sleep 1 && ${pkgs.bitwarden}/bin/bitwarden"; }
          { command = "sleep 1 && ${pkgs.discord}/bin/discord"; }
          { command = "sleep 1 && ${pkgs.slack}/bin/slack"; }
          { command = "sleep 1 && ${pkgs.telegram-desktop}/bin/telegram-desktop"; }
          { command = "sleep 1 && ${pkgs.thunderbird}/bin/thunderbird"; }
          { command = "sleep 1 && ${pkgs.firefox}/bin/firefox"; }
          { command = "sleep 1 && ${terminal} --class Alacritty_zellij -e zellij"; }
        ];
        input = {
          "type:keyboard" = {
            xkb_layout = "us,ru";
            xkb_options = "grp:lctrl_toggle,ctrl:nocaps";
          };
          "type:touchpad" = { tap = "enabled"; };
          "type:pointer" = {
            accel_profile = "flat";
            pointer_accel = "0";
          };
        };
        output = {
          "*" = {
            bg = "${./wallpapers/mox.jpg} fill";
          };
        } // lib.optionalAttrs (config.device == "roz-pc") {
          "DP-1" = {
            pos = "0 0";
            mode = "2560x1440@144Hz";
            adaptive_sync = "on";
          };
          "HDMI-A-1" = {
            pos = "2560 0";
            mode = "1920x1080@60Hz";
            transform = "270";
          };
        };
        bindkeysToCode = true;
        keybindings = {
          "${modifier}+d" = "exec ${menu}";
          "${modifier}+Return" = "exec ${terminal}";
          "${modifier}+Shift+Return" = "exec ${terminal} --class Alacritty_floating";
          "${modifier}+Shift+q" = "kill";

          "${modifier}+h" = "focus left";
          "${modifier}+j" = "focus down";
          "${modifier}+k" = "focus up";
          "${modifier}+l" = "focus right";

          "${modifier}+Shift+h" = "move left";
          "${modifier}+Shift+j" = "move down";
          "${modifier}+Shift+k" = "move up";
          "${modifier}+Shift+l" = "move right";

          "${modifier}+Shift+Space" = "floating toggle";
          "${modifier}+Space" = "focus mode_toggle";
          "${modifier}+Tab" = "focus next";
          "${modifier}+Shift+Tab" = "focus prev";

          "${modifier}+1" = "workspace ${ws1}";
          "${modifier}+2" = "workspace ${ws2}";
          "${modifier}+3" = "workspace ${ws3}";
          "${modifier}+4" = "workspace ${ws4}";
          "${modifier}+5" = "workspace ${ws5}";
          "${modifier}+6" = "workspace number 6";
          "${modifier}+7" = "workspace number 7";
          "${modifier}+8" = "workspace number 8";
          "${modifier}+9" = "workspace number 9";

          "${modifier}+Shift+1" = "move container to workspace ${ws1}";
          "${modifier}+Shift+2" = "move container to workspace ${ws2}";
          "${modifier}+Shift+3" = "move container to workspace ${ws3}";
          "${modifier}+Shift+4" = "move container to workspace ${ws4}";
          "${modifier}+Shift+5" = "move container to workspace ${ws5}";
          "${modifier}+Shift+6" = "move container to workspace number 6";
          "${modifier}+Shift+7" = "move container to workspace number 7";
          "${modifier}+Shift+8" = "move container to workspace number 8";
          "${modifier}+Shift+9" = "move container to workspace number 9";

          "${modifier}+b" = "split h";
          "${modifier}+v" = "split v";
          "${modifier}+f" = "fullscreen toggle";
          "${modifier}+comma" = "layout stacking";
          "${modifier}+period" = "layout tabbed";
          "${modifier}+slash" = "layout toggle split";

          "${modifier}+Shift+c" = "reload";
          "${modifier}+Shift+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -B 'Yes, exit sway' 'swaymsg exit'";
          "${modifier}+p" = "exec swaymsg output 'HDMI-A-1' toggle";

          "${modifier}+Shift+v" = "mode '${modeSystem}'";
          "${modifier}+Shift+r" = "mode '${modeResize}'";

          "${modifier}+s" = "exec ${pkgs.slurp}/bin/slurp | ${pkgs.grim}/bin/grim -g - $HOME/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png";
          "${modifier}+Shift+s" = "exec ${pkgs.slurp}/bin/slurp | ${pkgs.grim}/bin/grim -g - - | wl-copy -t image/png";
          "${modifier}+g" = "exec '${lockCmd}'";
          "${modifier}+i" = "exec ${pkgs.mako}/bin/makoctl invoke";
          "${modifier}+Shift+i" = "exec ${pkgs.mako}/bin/makoctl dismiss -a";

          "XF86AudioPlay" = "exec playerctl play-pause";
          "XF86AudioNext" = "exec playerctl next";
          "XF86AudioPrev" = "exec playerctl previous";

          "XF86AudioMute" = "exec pamixer --sink '${config.deviceSpecific.audio.sink}' -t";
          "XF86AudioRaiseVolume" = "exec pamixer --sink '${config.deviceSpecific.audio.sink}' -i 5";
          "XF86AudioLowerVolume" = "exec pamixer --sink '${config.deviceSpecific.audio.sink}' -d 5";
          "XF86AudioMicMute" = "exec pamixer --source '${config.deviceSpecific.audio.source}' -t";

          "XF86MonBrightnessUp" = "exec brightnessctl s +10%";
          "XF86MonBrightnessDown" = "exec brightnessctl s 10%-";
        };
        modes = {
          "${modeSystem}" = {
            s = "exec systemctl suspend";
            r = "exec systemctl reboot";
            p = "exec systemctl poweroff";
            Return = "mode default";
            Escape = "mode default";
          };
          "${modeResize}" = {
            h = "resize shrink width";
            l = "resize grow width";
            k = "resize shrink height";
            j = "resize grow height";
            Return = "mode default";
            Escape = "mode default";
          };
        };
        window = {
          titlebar = false;
        };
        floating = {
          criteria = [
            { app_id = "Alacritty_floating"; }
            { app_id = "lutris"; }
            { app_id = "pavucontrol"; }
            { app_id = "com.github.wwmm.easyeffects"; }
            { class = "steam"; }
            { class = "\.exe"; }
            { title = "^Choose Files$"; }
          ];
        };
        assigns = {
          "${ws1}" = [
            { app_id = "firefox"; }
          ];
          "${ws2}" = [
            { app_id = "org.telegram.desktop"; }
            { class = "Slack"; }
            { class = "discord"; }
          ];
          "${ws3}" = [
            { app_id = "Alacritty_zellij"; }
          ];
          "${ws4}" = [
            { class = "Bitwarden"; }
            { app_id = "thunderbird"; }
          ];
          "${ws5}" = [
            { class = "steam"; }
            { app_id = "lutris"; }
          ];
        };
      } // lib.optionalAttrs (config.device == "roz-pc") {
        workspaceOutputAssign = [
          { workspace = ws1; output = "DP-1"; }
          { workspace = ws2; output = "HDMI-A-1"; }
          { workspace = ws3; output = "DP-1"; }
          { workspace = ws4; output = "HDMI-A-1"; }
          { workspace = ws5; output = "DP-1"; }
        ];
      };
      extraConfig = ''
        for_window [title=" — Sharing Indicator$"] kill
        for_window [title="^Wine System Tray$"] kill 
      '';
    };
}

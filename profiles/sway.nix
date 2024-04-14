{ config, pkgs, lib, ... }:
let
  monitor1 = if config.device == "roz-laptop" then "eDP-1" else "DP-1";
  monitor2 = if config.device == "roz-laptop" then "HDMI-A-1" else "DP-2";
  xkbExtraOptions = if config.device == "roz-laptop" then ",altwin:swap_alt_win" else "";
in
{
  home-manager.users.roz = {
    home.packages = with pkgs; [
      bemenu
      slurp
      grim
      swaylock
      swayidle
      swaycwd
      wf-recorder
      wl-clipboard
      brightnessctl
      playerctl
      pamixer
      polkit_gnome
    ];
    wayland.windowManager.sway =
      let
        terminal = ''${pkgs.alacritty}/bin/alacritty --working-directory "''$(${pkgs.swaycwd}/bin/swaycwd)"'';
        modifier = "Mod4";
        menu = ''${pkgs.bemenu}/bin/bemenu-run -m all -H 35 --fn 'Hack Nerd Font 12' --no-exec | xargs swaymsg exec --'';
        lockCmd = ''
          ${pkgs.swaylock}/bin/swaylock -f \
          -i ${../wallpapers/1.jpg} \
          --indicator-thickness 6 \
          --text-color a9a9a9 \
          --ring-color bb00cc \
          --line-color 00000000 \
          --inside-color 00000088 \
          --separator-color 00000000 \
          --layout-bg-color 00000088 \
          --layout-text-color a9a9a9 \
        '';
        modeSystem = "system: [s]uspend [r]eboot [p]oweroff";
        modeResize = "resize";
      in
      {
        enable = true;
        wrapperFeatures.gtk = true;
        extraSessionCommands = ''
          export XDG_CURRENT_DESKTOP=sway
          export XDG_SESSION_TYPE=wayland
          export SDL_VIDEODRIVER=wayland
          export QT_QPA_PLATFORM=wayland
          export QT_QPA_PLATFORMTHEME=
          export NIXOS_OZONE_WL=1
          export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
        '';
        config = {
          inherit terminal modifier menu;
          output = {
            "*" = {
              bg = "${../wallpapers/1.jpg} fill";
            };
            "${monitor1}" = {
              mode = "2560x1440@240Hz";
              pos = if config.device == "roz-pc" then "1440 550" else "1440 1480";
            };
            "${monitor2}" = {
              mode = "2560x1440@144Hz";
              pos = "0 0";
              transform = "90";
            };
          };
          fonts = {
            names = [ "Hack Nerd Font" ];
            size = 10.0;
          };
          focus = {
            followMouse = "no";
          };
          bars = [ ];
          startup = [
            { command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"; }
            { command = "ssh-add < /dev/null"; }
            { command = "${pkgs.swaynotificationcenter}/bin/swaync"; }
            {
              command = ''
                ${pkgs.swayidle}/bin/swayidle -w \
                timeout 600 '${lockCmd}' \
                timeout 600 'swaymsg "output * dpms off"' \
                resume 'swaymsg "output * dpms on"' \
                before-sleep '${lockCmd}'
              '';
            }
          ];
          input = {
            "type:keyboard" = {
              xkb_layout = "us,ru";
              xkb_options = "grp:lctrl_toggle,ctrl:nocaps${xkbExtraOptions}";
            };
            "type:touchpad" = { tap = "enabled"; };
          } // lib.optionalAttrs (config.device == "roz-pc") {
            "type:pointer" = {
              accel_profile = "flat";
              pointer_accel = "0";
              scroll_method = "on_button_down";
              scroll_button = "274";
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

            "${modifier}+1" = "workspace number 1";
            "${modifier}+2" = "workspace number 2";
            "${modifier}+3" = "workspace number 3";
            "${modifier}+4" = "workspace number 4";
            "${modifier}+5" = "workspace number 5";
            "${modifier}+6" = "workspace number 6";
            "${modifier}+7" = "workspace number 7";
            "${modifier}+8" = "workspace number 8";
            "${modifier}+9" = "workspace number 9";

            "${modifier}+Shift+1" = "move container to workspace number 1";
            "${modifier}+Shift+2" = "move container to workspace number 2";
            "${modifier}+Shift+3" = "move container to workspace number 3";
            "${modifier}+Shift+4" = "move container to workspace number 4";
            "${modifier}+Shift+5" = "move container to workspace number 5";
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
            "${modifier}+p" = "exec swaymsg output '${monitor2}' toggle";

            "${modifier}+Shift+v" = "mode '${modeSystem}'";
            "${modifier}+Shift+r" = "mode '${modeResize}'";

            "${modifier}+s" = "exec ${pkgs.slurp}/bin/slurp | ${pkgs.grim}/bin/grim -g - - | ${pkgs.swappy}/bin/swappy -f -";
            "${modifier}+Shift+s" = "exec ${pkgs.slurp}/bin/slurp | ${pkgs.grim}/bin/grim -g - - | wl-copy -t image/png";
            "${modifier}+g" = "exec '${lockCmd}'";
            "${modifier}+i" = "exec ${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw";

            "XF86AudioPlay" = "exec playerctl play-pause";
            "XF86AudioNext" = "exec playerctl next";
            "XF86AudioPrev" = "exec playerctl previous";

            "XF86AudioMute" = "exec pamixer -t";
            "XF86AudioRaiseVolume" = "exec pamixer -i 5";
            "XF86AudioLowerVolume" = "exec pamixer -d 5";
            "XF86AudioMicMute" = "exec pamixer --default-source -t";

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
              { class = "steam"; }
              { class = "\.exe$"; }
            ];
          };
          assigns = {
            "1" = [
              { app_id = "firefox"; }
            ];
            "3" = [
              { app_id = "org.telegram.desktop"; }
              { app_id = "Slack"; }
              { app_id = "discord"; }
            ];
            "4" = [
              { app_id = "thunderbird"; }
            ];
            "5" = [
              { class = "steam"; }
              { app_id = "lutris"; }
            ];
          };
          workspaceOutputAssign = [
            { workspace = "1"; output = monitor1; }
            { workspace = "2"; output = monitor1; }
            { workspace = "3"; output = monitor2; }
          ];
        };
        extraConfig = ''
          for_window [title=" — Sharing Indicator$"] kill
          for_window [title="^Wine System Tray$"] kill 
        '';
      };
  };
}

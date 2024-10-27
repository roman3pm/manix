{
  config,
  pkgs,
  lib,
  ...
}:
let
  monitor1 = config.devices.monitor1;
  monitor2 = config.devices.monitor2;
in
{
  home-manager.users.roz = {
    wayland.windowManager.hyprland =
      let
        mod = "SUPER";
        terminal = ''${pkgs.alacritty}/bin/alacritty --working-directory "''$(${pkgs.hyprcwd}/bin/hyprcwd)"'';
        terminalFloat = "${pkgs.alacritty}/bin/alacritty --class Alacritty_float";
        menu = "${pkgs.fuzzel}/bin/fuzzel";
        pos2 = if config.hostName == "roz-pc" then "-1440x-800" else "-1440x-1480";
        xkbExtraOptions = if config.hostName == "roz-laptop" then ",altwin:swap_alt_win" else "";
      in
      {
        enable = true;
        settings = {
          monitor = [
            "${monitor1}, prefered, 0x0, 1, vrr, 2"
            "${monitor2}, prefered, ${pos2}, 1, transform, 3"
          ];
          exec-once = [
            "${pkgs.openssh}/bin/ssh-add < /dev/null"
            "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
          ];
          general = {
            gaps_in = 0;
            gaps_out = 0;
            layout = "master";
          };
          animations = {
            enabled = true;
            bezier = [ "myBezier, 0.05, 0.9, 0.1, 1.05" ];
            animation = [
              "windows, 1, 7, myBezier"
              "windowsOut, 1, 7, default, popin 80%"
              "border, 1, 10, default"
              "borderangle, 1, 8, default"
              "fade, 1, 7, default"
              "workspaces, 1, 6, default"
            ];
          };
          input =
            {
              kb_layout = "us,ru";
              kb_options = "grp:lctrl_toggle,ctrl:nocaps${xkbExtraOptions}";
            }
            // lib.optionalAttrs (config.hostName == "roz-pc") {
              accel_profile = "flat";
            };
          gestures = {
            workspace_swipe = true;
          };
          bind =
            [
              "${mod} SHIFT, Q, killactive,"
              "${mod} SHIFT, SPACE, togglefloating"
              "${mod}, F, fullscreen"
              "${mod}, left, movefocus, l"
              "${mod}, right, movefocus, r"
              "${mod}, up, movefocus, u"
              "${mod}, down, movefocus, d"
              "${mod}, tab, layoutmsg, cyclenext"
              "${mod}, slash, layoutmsg, orientationcycle left top"
              "${mod}, W, layoutmsg, swapwithmaster master"

              "${mod}, L, exec, loginctl lock-session"
              "${mod}, D, exec, ${menu}"
              "${mod}, RETURN, exec, ${terminal}"
              "${mod} SHIFT, RETURN, exec, ${terminalFloat}"
              "${mod}, S, exec, ${pkgs.slurp}/bin/slurp | ${pkgs.grim}/bin/grim -g - - | ${pkgs.swappy}/bin/swappy -f -"
              "${mod} SHIFT, S, exec, ${pkgs.slurp}/bin/slurp | ${pkgs.grim}/bin/grim -g - - | wl-copy -t image/png"
              "${mod}, I, exec, ${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw"
            ]
            ++ (builtins.concatLists (
              builtins.genList (
                i:
                let
                  ws = i + 1;
                in
                [
                  "${mod}, code:1${toString i}, workspace, ${toString ws}"
                  "${mod} SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
                ]
              ) 9
            ));
          bindel = [
            ", XF86AudioRaiseVolume, exec, ${pkgs.pamixer}/bin/pamixer -i 5"
            ", XF86AudioLowerVolume, exec, ${pkgs.pamixer}/bin/pamixer -d 5"
            ", XF86AudioMute, exec, ${pkgs.pamixer}/bin/pamixer -t"
            ", XF86AudioMicMute, exec, ${pkgs.pamixer}/bin/pamixer --default-source -t"
            ", XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl s +10%"
            ", XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl s 10%-"
          ];
          bindl = [
            ", XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
            ", XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next"
            ", XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous"
          ];
          bindm = [
            "${mod}, mouse:272, movewindow"
            "${mod}, mouse:273, resizewindow"
          ];
          windowrulev2 = [
            "float, class:(Alacritty_float)"

            "suppressevent maximize, class:.*"
            "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
          ];
        };
        extraConfig = ''
          bind = ${mod} SHIFT, R, submap, resize
          submap = resize
          binde = , right, resizeactive, 10 0
          binde = , left, resizeactive, -10 0
          binde = , up, resizeactive, 0 -10
          binde = , down, resizeactive, 0 10
          bind = , escape, submap, reset
          submap = reset

          bind = ${mod} SHIFT, V, submap, system: [s]uspend [r]eboot [p]oweroff
          submap = system: [s]uspend [r]eboot [p]oweroff
          binde = , S, exec, systemctl suspend
          binde = , R, exec, systemctl reboot
          binde = , P, exec, systemctl poweroff
          bind = , escape, submap, reset
          submap = reset
        '';
      };

    services.hyprpaper = {
      enable = true;
      settings = {
        preload = "${../wallpapers/1.jpg}";
        wallpaper = ", ${../wallpapers/1.jpg}";
      };
    };

    programs.hyprlock = {
      enable = true;
      settings = {
        background = {
          monitor = "";
          path = "${../wallpapers/1.jpg}";
          blur_passes = 2;
        };
        input-field = {
          monitor = "${monitor1}";
          size = "250, 50";
          outline_thickness = 1;
          dots_size = 0.25;
          dots_spacing = 0.25;
          dots_center = true;
          outer_color = "rgba(0, 0, 0, 0)";
          inner_color = "rgba(46, 46, 46, 0.4)";
          font_color = "rgba(255, 255, 255, 0.8)";
          font_family = "DejaVu Serif";
          fade_on_empty = false;
          placeholder_text = ''<i>Input Password...</i>'';
          hide_input = false;
          rounding = -1;
          check_color = "rgb(204, 136, 34)";
          fail_color = "rgb(204, 34, 34)";
          fail_timeout = 2000;
          fail_transition = 300;
          position = "0, -200";
          halign = "center";
          valign = "center";
        };
        label = [
          {
            monitor = "${monitor1}";
            text = ''cmd[update:100] echo "$(date +"%H:%M:%S")"'';
            color = "rgba(255, 255, 255, 0.8)";
            font_size = 88;
            font_family = "DejaVu Sans Mono";
            position = "0, 100";
            halign = "center";
            valign = "center";
          }
          {
            monitor = "${monitor1}";
            text = ''cmd[update:100] echo "$(date +"%A, %d %b %Y")"'';
            color = "rgba(255, 255, 255, 0.8)";
            font_size = 24;
            font_family = "DejaVu Sans Mono";
            position = "0, 0";
            halign = "center";
            valign = "center";
          }
          {
            monitor = "${monitor1}";
            text =
              let
                grepCmd = "grep -B 1 'main: yes' | grep 'active keymap' | awk '{print tolower(substr($3,1,2))}'";
              in
              ''cmd[update:100] echo " $(hyprctl devices | ${grepCmd})"'';
            color = "rgba(255, 255, 255, 0.8)";
            font_size = 12;
            font_family = "DejaVuSansM Nerd Font";
            position = "0, -250";
            halign = "center";
            valign = "center";
          }
        ];
      };
    };

    services.hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };
        listener = [
          {
            timeout = 10;
            on-timeout = "if pgrep -x hyprlock; then hyprctl dispatch dpms off; fi";
            on-resume = "hyprctl dispatch dpms on";
          }
          {
            timeout = 500;
            on-timeout = "loginctl lock-session";
          }
          {
            timeout = 510;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };

    home.sessionVariables.NIXOS_OZONE_WL = "1";
  };

  security.pam.services.hyprlock = { };
}

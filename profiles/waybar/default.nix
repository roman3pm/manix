{ config, pkgs, ... }:
let
  monitor1 = config.devices.monitor1;
  monitor2 = config.devices.monitor2;
  modules = {
    "hyprland/submap" = {
      format = "{}";
      tooltip = false;
    };
    "hyprland/workspaces" = {
      all-outputs = false;
      disable-scroll = false;
    };
    "hyprland/window" = {
      format = "{title}";
      max-length = 80;
      all-outputs = true;
    };
    "temperature#gpu" =
      {
        interval = 1;
        format = "GPU {temperatureC}°";
        tooltip = false;
      }
      // (
        if config.hostName == "roz-laptop" then
          { thermal-zone = 2; }
        else
          { hwmon-path = "/sys/class/hwmon/hwmon0/temp2_input"; }
      );
    "temperature#cpu" =
      {
        interval = 1;
        format = "CPU {temperatureC}°";
        tooltip = false;
      }
      // (
        if config.hostName == "roz-laptop" then
          { thermal-zone = 5; }
        else
          { hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input"; }
      );
    "battery" = {
      states = {
        critical = 15;
      };
      full-at = 90;
      format = "{icon} {capacity}%";
      format-charging = " {capacity}%";
      format-full = " {capacity}%";
      format-icons = [
        ""
        ""
        ""
        ""
        ""
      ];
      format-alt = "{icon} {time}";
    };
    "tray" = {
      icon-size = 20;
      spacing = 8;
    };
    "idle_inhibitor" = {
      format = "{icon} ";
      format-icons = {
        activated = "";
        deactivated = "";
      };
    };
    "pulseaudio" = {
      scroll-step = 5;
      format = "{icon} {volume}%";
      min-length = 6;
      format-bluetooth = "{icon} {volume}%";
      format-muted = " mute";
      format-icons = {
        default = [
          ""
          ""
          ""
        ];
      };
      on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
      on-click-right = "${pkgs.easyeffects}/bin/easyeffects";
      ignored-sinks = [ "Easy Effects Sink" ];
    };
    "hyprland/language" = {
      format-en = "🇺🇸en";
      format-ru = "🇷🇺ru";
    };
    "clock" = {
      interval = 1;
      format = "{:%H:%M:%S}";
      tooltip-format = "{:%A, %e %b %Y}";
    };
    "custom/notification" =
      let
        swayncCmd = "${pkgs.swaynotificationcenter}/bin/swaync-client";
      in
      {
        tooltip = false;
        format = "{icon} ";
        format-icons = {
          notification = "";
          none = "";
          dnd-notification = "";
          dnd-none = "";
        };
        return-type = "json";
        exec-if = "which ${swayncCmd}";
        exec = "${swayncCmd} -swb";
        on-click = "${swayncCmd} -t -sw";
        on-click-right = "${swayncCmd} -d -sw";
        escape = true;
      };
  };
in
{
  home-manager.users.roz.programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = ./style.css;
    settings = [
      (
        modules
        // {
          position = "top";
          output = monitor1;
          modules-left = [
            "hyprland/submap"
            "hyprland/workspaces"
          ];
          modules-center = [ "hyprland/window" ];
          modules-right = [
            "temperature#gpu"
            "temperature#cpu"
            "battery"
            "tray"
            "idle_inhibitor"
            "pulseaudio"
            "hyprland/language"
            "clock"
            "custom/notification"
          ];
        }
      )
      (
        modules
        // {
          position = "top";
          output = monitor2;
          modules-left = [ "hyprland/workspaces" ];
          modules-right = [
            "temperature#gpu"
            "temperature#cpu"
            "hyprland/language"
            "clock"
          ];
        }
      )
    ];
  };
}

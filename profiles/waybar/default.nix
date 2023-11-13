{ config, pkgs, lib, ... }:
let
  cpuHwmon = if config.device == "roz-laptop" then "hwmon5" else "hwmon2";
  modules = {
    "sway/mode" = {
      format = "{}";
      tooltip = false;
    };
    "sway/workspaces" = {
      all-outputs = false;
      disable-scroll = false;
      format = ''{icon}:{name}'';
      format-icons = {
        "1:http" = " ";
        "2:chat" = " ";
        "3:code" = " ";
        "4:mail" = "󰆎 ";
        "5:game" = " ";
        "6" = " ";
        "7" = " ";
        "8" = " ";
        "9" = " ";
        "10" = " ";
      };
    };
    "sway/window" = {
      format = "{}";
      max-length = 80;
      all-outputs = true;
      tooltip = false;
    };
    "temperature#gpu" = {
      interval = 1;
      hwmon-path = "/sys/class/hwmon/hwmon0/temp2_input";
      format = "GPU {temperatureC}°";
      tooltip = false;
    };
    "temperature#cpu" = {
      interval = 1;
      hwmon-path = "/sys/class/hwmon/${cpuHwmon}/temp1_input";
      format = "CPU {temperatureC}°";
      tooltip = false;
    };
    "battery" = {
      states = {
        critical = 15;
      };
      full-at = 90;
      format = "{icon} {capacity}%";
      format-charging = " {capacity}%";
      format-full = " {capacity}%";
      format-icons = [ " " " " " " " " " " ];
      format-alt = "{icon} {time}";
    };
    "tray" = {
      icon-size = 20;
      spacing = 5;
    };
    "idle_inhibitor" = {
      format = "{icon}";
      format-icons = {
        activated = "";
        deactivated = "";
      };
    };
    "pulseaudio" = {
      scroll-step = 5;
      format = "{icon}{volume}%";
      min-length = 6;
      format-bluetooth = "{icon}{volume}%";
      format-muted = " mute";
      format-icons = {
        default = [ " " " " ];
      };
      on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
      on-click-right = "${pkgs.easyeffects}/bin/easyeffects";
      ignored-sinks = [ "Easy Effects Sink" ];
    };
    "sway/language" = {
      format = "{flag}{short}";
      tooltip = false;
    };
    "clock" = {
      interval = 1;
      format = " {:%H:%M:%S}";
      tooltip-format = " {:%e %b %Y}";
    };
  };
in
{
  home-manager.users.roz.programs.waybar = {
    enable = true;
    style = ./style.css;
    settings = [
      (modules // {
        position = "top";
        modules-left = [
          "sway/mode"
          "sway/workspaces"
        ];
        modules-center = [
          "sway/window"
        ];
        modules-right = [
          "temperature#gpu"
          "temperature#cpu"
          "battery"
          "tray"
          "idle_inhibitor"
          "pulseaudio"
          "sway/language"
          "clock"
        ];
      } // lib.optionalAttrs (config.device == "roz-pc") {
        output = "DP-1";
      })
      (modules // {
        position = "top";
        output = "HDMI-A-1";
        modules-left = [
          "sway/workspaces"
        ];
        modules-right = [
          "temperature#gpu"
          "temperature#cpu"
          "sway/language"
          "clock"
        ];
      })
    ];
  };
}

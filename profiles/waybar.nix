{ config, pkgs, lib, ... }:
let
  inherit (lib.attrsets) nameValuePair;
  inherit (builtins) concatLists attrNames listToAttrs;

  sysconfig = (import <nixpkgs/nixos> {}).config;

  modules = {
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

    "clock#time" = {
      interval = 1;
      format = "{:%H:%M:%S}";
      tooltip = false;
    };

    "clock#date" = {
      format = " {:%e %b %Y}";
      tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
    };

    "cpu" = {
      interval = 1;
      format = " {usage}%";
      min-length = 5;
      tooltip = false;
    };

    "sway/language" = {
      format = " {long}";
      min-length = 14;
      tooltip = false;
    };

    "memory" = {
      interval = 1;
      format = " {used:0.1f}GiB";
    };

    "network" = {
      interval = 5;
      interface = if config.device == "roz-pc" then "enp34s0" else "wlp2s0";
      format-wifi = "直 {essid} ({signalStrength}%)";
      format-ethernet = " {ifname}";
      format-disconnected = "";
      tooltip = false;
    };

    "sway/mode" = {
      format = "{}";
      tooltip = false;
    };

    "sway/window" = {
      format = "{}";
      max-length = 80;
      all-outputs = true;
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
        "4:mail" = " ";
        "5:game" = " ";
        "6"      = " ";
        "7"      = " ";
        "8"      = " ";
        "9"      = " ";
        "10"     = " ";
      };
    };

    "idle_inhibitor" = {
      format = "{icon}";
      format-icons = {
        activated   = "(;0_0)";
        deactivated = "(;=_=)";
      };
    };

    "pulseaudio" = {
      scroll-step = 5;
      format = "{icon}{volume}%";
      min-length = 6;
      format-bluetooth = "{icon}{volume}%";
      format-muted = " mute";
      format-icons = {
        default = [" " " "];
      };
      on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
      on-click-right = "${pkgs.easyeffects}/bin/easyeffects";
      ignored-sinks = ["Easy Effects Sink"];
    };

    "temperature#cpu" = {
      interval = 1;
      hwmon-path = "/sys/class/hwmon/hwmon2/temp3_input";
      format = " {temperatureC}°C";
      tooltip = false;
    };

    "temperature#gpu" = {
      interval = 1;
      hwmon-path = "/sys/class/hwmon/hwmon0/temp2_input";
      format = " {temperatureC}°C";
      tooltip = false;
    };

    "tray" = {
      icon-size = 20;
      spacing = 5;
    };

  };
in {
  home-manager.users.roz.programs.waybar = {
    enable = true;
    style = ./waybar/style.css;
    settings = [
      (modules // {
        position = "top";
        modules-left = [
          "sway/mode"
          "sway/workspaces"
          "sway/window"
        ];
        modules-right = [
          "temperature#gpu"
          "temperature#cpu"
          "cpu"
          "memory"
          "network"
          "pulseaudio"
          "battery"
          "sway/language"
          "tray"
          "idle_inhibitor"
          "clock#date"
          "clock#time"
        ];
      } // lib.optionalAttrs(config.device == "roz-pc") {
        output = "DP-1";
      })
      (modules // {
        position = "top";
        output = "HDMI-A-1";
        modules-left = [
          "sway/workspaces"
          "sway/window"
        ];
        modules-right = [
          "temperature#gpu"
          "temperature#cpu"
          "cpu"
          "clock#date"
          "clock#time"
        ];
      })
    ];
  };
}


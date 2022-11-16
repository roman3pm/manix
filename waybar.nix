{ config, pkgs, lib, ... }:
let
  inherit (lib.attrsets) nameValuePair;
  inherit (builtins) concatLists attrNames listToAttrs;

  sysconfig = (import <nixpkgs/nixos> {}).config;

  ws1 = "1:web";
  ws2 = "2:term";
  ws3 = "3:code";
  ws4 = "4:chat";
  ws5 = "5:mail";
  ws6 = "6:game";
  ws7 = "7:other";

  modules = {
    "battery" = {
      states = {
        critical = 15;
      };
      full-at = 90;
      format = "{icon} {capacity}%";
      format-charging = " {capacity}%";
      format-plugged = " {capacity}%";
      format-icons = [ " " " " " " " " " " ];
      format-alt = "{icon} {time}";
      on-click = "";
    };

    "clock#time" = {
      interval = 1;
      format = "{:%H:%M:%S}";
      tooltip = false;
      on-click = "";
    };

    "clock#date" = {
      format = " {:%e %b %Y}";
      tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      on-click = "";
    };

    "cpu" = {
      interval = 1;
      tooltip = false;
      format = " {usage}%";
      on-click = "";
    };

    "sway/language" = {
      format = " {long}";
      min-length = 14;
      tooltip = false;
      on-click = "";
    };

    "memory" = {
      interval = 1;
      format = " {used:0.1f}GiB";
      on-click = "";
    };

    "network" = {
      interval = 5;
      interface = "enp34s0";
      format-wifi = "直 {essid} ({signalStrength}%)";
      format-ethernet = " {ifname}";
      format-disconnected = " ";
      tooltip = false;
      on-click = "";
    };

    "sway/mode" = {
      format = " {}";
      tooltip = false;
      on-click = "";
    };

    "sway/window" = {
      format = "{}";
      max-length = 50;
      all-outputs = true;
      tooltip = false;
      on-click = "";
    };

    "sway/workspaces" = {
      all-outputs = false;
      disable-scroll = false;
      format = ''{icon}:{name}'';
      format-icons = {
        "${ws1}" = " ";
        "${ws2}" = " ";
        "${ws3}" = " ";
        "${ws4}" = " ";
        "${ws5}" = " ";
        "${ws6}" = " ";
        "${ws7}" = " ";
      };
      on-click = "";
    };

    "idle_inhibitor" = {
      format = "{icon}";
      format-icons = {
        activated = " ";
        deactivated = " ";
      };
      on-click = "";
    };

    "pulseaudio" = {
      scroll-step = 5;
      format = "{icon}{volume}%";
      format-bluetooth = "{icon}{volume}%";
      format-muted = " mute";
      format-icons = {
        default = [" " " "];
      };
      on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
    };

    "temperature#cpu" = {
      interval = 1;
      hwmon-path = "/sys/class/hwmon/hwmon2/temp3_input";
      format = " {temperatureC}°C";
      tooltip = false;
      on-click = "";
    };

    "temperature#gpu" = {
      interval = 1;
      hwmon-path = "/sys/class/hwmon/hwmon0/temp2_input";
      format = " {temperatureC}°C";
      tooltip = false;
      on-click = "";
    };

    "tray" = {
      icon-size = 20;
      spacing =   5;
      on-click = "";
    };

  };
in {
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = ./waybar/style.css;
    settings = [
      (modules // {
        position = "top";
        output = "DP-1";
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


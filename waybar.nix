{ config, pkgs, lib, ... }:
let
  inherit (lib.attrsets) nameValuePair;
  inherit (builtins) concatLists attrNames listToAttrs;

  sysconfig = (import <nixpkgs/nixos> {}).config;
  colors = import ./colors.nix;

  ws1 = "1:web";
  ws2 = "2:term";
  ws3 = "3:code";
  ws4 = "4:chat";
  ws5 = "5:mail";
  ws6 = "6:game";
  ws7 = "7:other";

  arrowNames = (attrNames colors) ++ [ "start" "end" "time"];
  getArrowModule = (p: n:
    let name = p + n;
    in nameValuePair "${name}" {
      format = "";
      tooltip = false;
    }
  );
  arrowModules = map (getArrowModule "custom/arrow_") arrowNames;

  modules = listToAttrs arrowModules // {
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
      tooltip = false;
      format = " {usage}%";
    };

    "sway/language" = {
      format = " {long}";
      min-length = 14;
      tooltip = false;
    };

    "memory" = {
      interval = 1;
      format = " {used:0.1f}GiB";
    };

    "network" = {
      interval = 5;
      interface = "enp34s0";
      format-wifi = "直 {essid} ({signalStrength}%)";
      format-ethernet = " {ifname}";
      format-disconnected = " ";
      tooltip = false;
    };

    "sway/mode" = {
      format = " {}";
      tooltip = false;
    };

    "sway/window" = {
      format = "{}";
      max-length = 50;
      all-outputs = true;
      tooltip = false;
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
    };

    "idle_inhibitor" = {
      format = "{icon}";
      format-icons = {
        activated = "";
        deactivated = "";
      };
    };

    "pulseaudio" = {
      scroll-step = 1;
      format = "{icon} {volume}%";
      format-bluetooth = "{icon} {volume}%";
      format-muted = " ";
      format-icons = {
        headphones = " ";
        handsfree = " ";
        headset = " ";
        phone = " ";
        portable = " ";
        car = " ";
        default = [" " " "];
      };
      on-click = "pavucontrol";
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
      format = " {temperatureC}°C";
      tooltip = false;
    };

    "custom/alsa" = {
      exec = "amixer get Master | sed -nre 's/.*\\[off\\].*/ muted/p; s/.*\\[(.*%)\\].*/ \\1/p'";
      on-click = "amixer set Master toggle; pkill -x -RTMIN+11 waybar";
      on-scroll-up = "amixer set Master 1+; pkill -x -RTMIN+11 waybar";
      on-scroll-down = "amixer set Master 1-; pkill -x -RTMIN+11 waybar";
      signal = 11;
      interval = 10;
      tooltip = false;
    };

    "tray" = {
      icon-size = 20;
      spacing =   5;
    };

    "custom/arrow_workspaces" = {
      format = "";
      tooltip = false;
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
        output = "DP-3";
        modules-left = [
          "sway/mode"
          "sway/workspaces"
          "custom/arrow_workspaces"
          "sway/window"
        ];
        modules-right = [
          "idle_inhibitor"
          "custom/arrow_start"
          "temperature#cpu"
          "custom/arrow_purple"
          "temperature#gpu"
          "custom/arrow_aqua"
          "memory"
          "custom/arrow_br_aqua"
          "cpu"
          "custom/arrow_br_green"
          "network"
          "custom/arrow_green"
          "custom/alsa"
          #"pulseaudio"
          "custom/arrow_yellow"
          "battery"
          "custom/arrow_br_yellow"
          "sway/language"
          "custom/arrow_br_orange"
          "custom/arrow_end"
          "tray"
          "clock#date"
          "custom/arrow_time"
          "clock#time"
        ];
      })
      (modules // {
        position = "top";
        output = "HDMI-A-1";
        modules-left = [
          "sway/workspaces"
          "custom/arrow_workspaces"
          "sway/window"
        ];
        modules-right = [
          "custom/arrow_start"
          "temperature#cpu"
          "custom/arrow_purple"
          "temperature#gpu"
          "custom/arrow_aqua"
          "custom/arrow_br_aqua"
          "cpu"
          "custom/arrow_br_green"
          "custom/arrow_green"
          "custom/arrow_yellow"
          "custom/arrow_br_yellow"
          "custom/arrow_br_orange"
          "custom/arrow_end"
          "clock#date"
          "custom/arrow_time"
          "clock#time"
        ];
      })
    ];
  };
}


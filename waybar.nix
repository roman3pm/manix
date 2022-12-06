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
      format = " {usage}%";
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

    "custom/openrazer" = {
      exec = pkgs.writeShellScript "openrazer" ''
        SERIAL=$(polychromatic-cli -l | grep -o -E '[A-Z0-9]{15}')
        if [[ $SERIAL == UNKWN* ]]; then echo ""; else echo " Razer"; fi
      '';
      on-click = "${pkgs.polychromatic}/bin/polychromatic-controller";
      on-click-right = "systemctl --user restart openrazer-daemon.service";
      restart-interval = 3;
      tooltip = false;
    };
  };
in {
  programs.waybar = {
    enable = true;
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
          "custom/openrazer"
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


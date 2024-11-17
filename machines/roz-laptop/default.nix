{ inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    inputs.self.nixosRoles.desktop
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-6th-gen
  ];

  devices = {
    interface = "wlp2s0";
    monitor1 = "eDP-1";
    monitor2 = "HDMI-A-1";
  };

  systemd.services.trackpad-reconnect = {
    description = "Reconnecting a dead trackpad";
    wantedBy = [ "suspend.target" ];
    after = [ "suspend.target" ];
    script = ''
      printf none > /sys/bus/serio/devices/serio1/drvctl
      sleep 1
      printf reconnect > /sys/bus/serio/devices/serio1/drvctl
    '';
    serviceConfig.Type = "oneshot";
  };
}

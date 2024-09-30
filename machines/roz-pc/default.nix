{ inputs, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    inputs.self.nixosRoles.desktop
    inputs.self.nixosProfiles.ollama
    inputs.self.nixosProfiles.steam
  ];

  devices = {
    interface = "enp34s0";
    monitor1 = "DP-1";
    monitor2 = "DP-2";
  };

  boot = {
    initrd.kernelModules = [ "amdgpu" ];
  };

  services.udev.packages = [
    (pkgs.writeTextFile {
      name = "via_udev";
      text = ''
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0666", TAG+="uaccess", TAG+="udev-acl"
      '';
      destination = "/etc/udev/rules.d/92-viia.rules";
    })
  ];
}

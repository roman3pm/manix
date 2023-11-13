{ inputs, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    inputs.self.nixosRoles.desktop
  ];

  boot = {
    initrd.kernelModules = [ "amdgpu" ];
    kernelParams = [ "amdgpu.ppfeaturemask=0xfff7ffff" "amdgpu.freesync_video=1" ];
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

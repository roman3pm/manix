{
  config,
  lib,
  modulesPath,
  ...
}:
let
  broadcom_sta = config.boot.kernelPackages.callPackage ./broadcom_sta.nix { };
in
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usbhid"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [
    "kvm-amd"
    "wl"
  ];
  boot.extraModulePackages = [ broadcom_sta ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/a2809e77-c25a-4e67-9f3a-fc755636f183";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/67F0-5772";
    fsType = "vfat";
    options = [
      "dmask=0077"
      "fmask=0077"
    ];
  };

  fileSystems."/hdd" = {
    device = "/dev/disk/by-uuid/63223e48-1b0f-4937-ac2b-37407de1e1ee";
    fsType = "ext4";
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 8 * 1024;
    }
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}

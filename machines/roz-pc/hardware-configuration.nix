{
  config,
  lib,
  modulesPath,
  ...
}:
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
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/a2809e77-c25a-4e67-9f3a-fc755636f183";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/8430-BE64";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  fileSystems."/data" = {
    device = "/dev/disk/by-uuid/9569bad0-9da7-435e-9400-9bc8e7a30e51";
    fsType = "ext4";
    options = [
      "nofail"
      "users"
    ];
  };

  fileSystems."/hdd" = {
    device = "/dev/disk/by-uuid/63223e48-1b0f-4937-ac2b-37407de1e1ee";
    fsType = "ext4";
    options = [
      "nofail"
      "users"
    ];
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 8 * 1024;
    }
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}

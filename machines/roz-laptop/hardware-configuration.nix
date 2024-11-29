{
  lib,
  modulesPath,
  ...
}:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "nvme"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/ba6b8727-ce49-465a-966d-35147c55341f";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."luks-b281982b-41b9-4df6-b019-47b8e94cd47a".device = "/dev/disk/by-uuid/b281982b-41b9-4df6-b019-47b8e94cd47a";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/331A-05B6";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
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

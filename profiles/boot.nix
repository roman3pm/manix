{ config, ... }:
{
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    plymouth.enable = true;
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ];
    kernelModules = [
      "v4l2loopback"
      "hid-apple"
    ];
    extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback.out ];
    extraModprobeConfig = ''
      options v4l2loopback exclusive_caps=1 card_label="Virtual Camera"
      options hid_apple fnmode=2
    '';
  };
}

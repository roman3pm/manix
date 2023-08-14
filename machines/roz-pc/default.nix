{ inputs, pkgs, ... }: {
  imports = with inputs.self.nixosModules; with inputs.self.nixosProfiles; [
    ./hardware-configuration.nix

    devices

    sway
    waybar
    terminal
    neovim
    git
    firefox
    utils
  ];

  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelParams = [ "amdgpu.ppfeaturemask=0xfff7ffff" ];

  services.udev.packages = [
    (pkgs.writeTextFile {
      name = "via_udev";
      text = ''
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0666", TAG+="uaccess", TAG+="udev-acl"
      '';
      destination = "/etc/udev/rules.d/92-viia.rules";
    })
  ];

  deviceSpecific = {
    audio = {
      sink = "alsa_output.usb-Burr-Brown_from_TI_USB_Audio_CODEC-00.analog-stereo-output";
      source = "alsa_input.usb-Burr-Brown_from_TI_USB_Audio_CODEC-00.analog-stereo-input";
    };
  };
}

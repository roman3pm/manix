{ inputs, pkgs, ... }: {
  imports = with inputs.self.nixosModules; with inputs.self.nixosProfiles; [
    ./hardware-configuration.nix

    devices

    sway
    waybar
    terminal
    neovim
    git
    mako
    mangohud
  ];

  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelParams = [ "amdgpu.ppfeaturemask=0xffffffff" ];

  environment.sessionVariables = {
    AMD_VULKAN_ICD = "RADV";
    VK_ICD_FILENAMES = ''
      /run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json:\
      /run/opengl-driver-32/share/vulkan/icd.d/radeon_icd.i686.json\
    '';
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

  deviceSpecific = {
    audio = {
      sink = "alsa_output.usb-Burr-Brown_from_TI_USB_Audio_CODEC-00.analog-stereo-output";
      source = "alsa_input.usb-Burr-Brown_from_TI_USB_Audio_CODEC-00.analog-stereo-input";
    };
  };
}

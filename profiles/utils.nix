{ pkgs, ... }:
{
  home-manager.users.roz = {
    programs.mangohud = {
      enable = true;
      settings = {
        no_display = true;
        cpu_temp = true;
        cpu_stats = true;
        cpu_mhz = true;
        ram = true;
        vram = true;
        gpu_temp = true;
        gpu_power = true;
        gpu_stats = true;
        gpu_core_clock = true;
        engine_version = true;
        vulkan_driver = true;
        fps_limit = "240,0";
      };
    };

    home.packages = [ pkgs.vkbasalt ];
    xdg.configFile."vkBasalt/vkBasalt.conf".text = ''
      effects = cas
      toggleKey = Home
      enableOnLaunch = True
      casSharpness = 0.2
    '';
  };
}

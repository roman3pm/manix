{ pkgs, lib, ... }: {
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
      vsync = 0;
      gl_vsync = -1;
      fps_limit = "140,0";
    };
  };
}

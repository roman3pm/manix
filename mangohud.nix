{ pkgs, lib, ... }: {
  programs.mangohud = {
    enable = true;
    settings = {
      no_display = true;
      cpu_temp = true;
      cpu_stats = true;
      gpu_temp = true;
      gpu_power = true;
      gpu_stats = true;
      gpu_core_clock = true;
      force_amdgpu_hwmon = true;
      fps_limit = "0,142";
    };
  };
}

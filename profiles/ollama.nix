{ pkgs, ... }:
{
  environment.variables = {
    HCC_AMDGPU_TARGET = "gfx1030";
    HSA_OVERRIDE_GFX_VERSION = "10.3.0";
  };
  services.ollama = {
    enable = true;
    acceleration = "rocm";
  };
  home-manager.users.roz = {
    home.packages = with pkgs; [
      alpaca
      lmstudio
    ];
  };
}

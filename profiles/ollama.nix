{ pkgs, ... }:
{
  services.ollama = {
    enable = true;
    acceleration = "rocm";
    rocmOverrideGfx = "10.3.0";
  };
  home-manager.users.roz = {
    home.packages = with pkgs; [
      alpaca
      lmstudio
    ];
  };
}

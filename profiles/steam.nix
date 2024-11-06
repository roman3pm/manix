{ pkgs, ... }:
{
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };
  programs.gamescope = {
    args = [
      "--xwayland-count 2"
      "--hdr-enabled"
      "--hdr-sdr-content-nits 250"
      "--hdr-itm-enable"
      "--hdr-itm-target-nits 600"
      "--force-grab-cursor"
      "--prefer-output DP-1"
      "--adaptive-sync"
    ];
    env = {
      STEAM_MULTIPLE_XWAYLANDS = "1";
      DXVK_HDR = "1";
      ENABLE_GAMESCOPE_WSI = "1";
    };
  };
  environment.systemPackages = [ pkgs.gamescope-wsi ];
}

{ pkgs, ... }: {
  programs.steam.gamescopeSession.enable = true;
  programs.gamescope = {
    args = [
      "--hdr-enabled"
      "--hdr-sdr-content-nits 250"
      "--hdr-itm-enable"
      "--hdr-itm-target-nits 600"
      "--prefer-output DP-1"
      "--immediate-flips"
    ];
    env = {
      DXVK_HDR = "1";
      ENABLE_GAMESCOPE_WSI = "1";
    };
  };
  environment.systemPackages = [ pkgs.gamescope-wsi ];
}

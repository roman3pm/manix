{
  chaotic.hdr.enable = true;
  programs.gamescope = {
    args = [
      "--hdr-sdr-content-nits 250"
      "--hdr-itm-enable"
      "--hdr-itm-target-nits 600"
      "--prefer-output DP-1"
      "--immediate-flips"
    ];
  };
}

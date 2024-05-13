inputs: system: final: prev: {

  stable = import inputs.nixpkgs-stable {
    inherit system;
    config.allowUnfree = true;
  };

  waybar = final.stable.waybar;

  lf = prev.lf.overrideAttrs (old: {
    postInstall = old.postInstall + "cp -R etc $out";
  });

}

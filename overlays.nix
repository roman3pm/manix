inputs: system: final: prev: rec {

  stable = import inputs.nixpkgs-stable {
    inherit system;
    config.allowUnfree = true;
  };

  lf = prev.lf.overrideAttrs (oldAttrs: rec {
    postInstall = oldAttrs.postInstall + "cp -R etc $out";
  });

}

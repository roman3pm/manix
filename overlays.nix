inputs: system: final: prev: rec {

  master = import inputs.nixpkgs-master {
    inherit system;
    config.allowUnfree = true;
  };

  lf = prev.lf.overrideAttrs (oldAttrs: rec {
    postInstall = oldAttrs.postInstall + "cp -R etc $out";
  });

}

inputs: system: final: prev: {

  stable = import inputs.nixpkgs-stable {
    inherit system;
    config.allowUnfree = true;
  };

  lf = prev.lf.overrideAttrs (old: {
    postInstall = old.postInstall + "cp -R etc $out";
  });

  glsl_analyzer = prev.callPackage ./glsl_analyzer { };

}

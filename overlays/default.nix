inputs: system: final: prev:
let
  gen-nvim = prev.vimUtils.buildVimPlugin {
    name = "gen-nvim";
    src = inputs.gen-nvim;
  };
in
{

  lf = prev.lf.overrideAttrs (old: {
    postInstall = old.postInstall + "cp -R etc $out";
  });

  vimPlugins = prev.vimPlugins // {
    inherit gen-nvim;
  };

  hyprcwd = prev.callPackage ./hyprcwd { };

}

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

  mutter = prev.mutter.overrideAttrs (old: {
    src = prev.fetchFromGitLab {
      domain = "gitlab.gnome.org";
      owner = "vanvugt";
      repo = "mutter";
      rev = "triple-buffering-v4-47";
      hash = "sha256-JaqJvbuIAFDKJ3y/8j/7hZ+/Eqru+Mm1d3EvjfmCcug=";
    };
    preConfigure =
      let
        gvdb = final.fetchFromGitLab {
          domain = "gitlab.gnome.org";
          owner = "GNOME";
          repo = "gvdb";
          rev = "2b42fc75f09dbe1cd1057580b5782b08f2dcb400";
          hash = "sha256-CIdEwRbtxWCwgTb5HYHrixXi+G+qeE1APRaUeka3NWk=";
        };
      in
      ''
        cp -a "${gvdb}" ./subprojects/gvdb
      '';
  });

}

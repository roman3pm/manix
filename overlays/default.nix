inputs: system: final: prev:
let
  gen-nvim = prev.vimUtils.buildVimPlugin {
    name = "gen-nvim";
    src = inputs.gen-nvim;
  };
in
{
  vimPlugins = prev.vimPlugins // {
    inherit gen-nvim;
  };
}

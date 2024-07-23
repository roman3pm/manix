{ inputs, ... }: {
  imports = [ inputs.aagl.nixosModules.default ];
  nix.settings = inputs.aagl.nixConfig;
  programs.sleepy-launcher.enable = true;
}

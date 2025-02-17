{ inputs, ... }:
{
  imports = with inputs.self.nixosProfiles; [
    ./base.nix
    obs
    ollama
    steam
    utils
  ];
}

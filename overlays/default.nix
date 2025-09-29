inputs: system: final: prev:
let
in
{
  mattermost-desktop = inputs.nixpkgs-mattermost.legacyPackages.${system}.mattermost-desktop;
}

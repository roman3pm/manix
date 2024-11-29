{ inputs, ... }:
{
  imports = with inputs.self.nixosProfiles; [
    home
    ui
    terminal
    git
    neovim
    browser
    easyeffects
    obs
    utils
  ];
}

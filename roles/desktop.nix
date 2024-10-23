{ inputs, ... }:
{
  imports = with inputs.self.nixosProfiles; [
    home
    hypr
    ui
    waybar
    fuzzel
    swaync
    terminal
    git
    neovim
    browser
    easyeffects
    obs
    utils
  ];
}

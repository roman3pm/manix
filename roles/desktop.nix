{ inputs, ... }:
{
  imports = with inputs.self.nixosProfiles; [
    home
    hyprland
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

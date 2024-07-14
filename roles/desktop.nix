{ inputs, ... }: {
  imports = with inputs.self.nixosProfiles; [
    home
    sway
    ui
    waybar
    wofi
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

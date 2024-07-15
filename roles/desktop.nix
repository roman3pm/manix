{ inputs, ... }: {
  imports = with inputs.self.nixosProfiles; [
    home
    sway
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

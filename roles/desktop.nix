{ inputs, ... }: {
  imports = with inputs.self.nixosProfiles; [
    sway
    ui
    waybar
    swaync
    terminal
    git
    neovim
    firefox
    easyeffects
    obs
    utils
  ];
}

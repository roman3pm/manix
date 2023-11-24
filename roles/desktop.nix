{ inputs, ... }: {
  imports = with inputs.self.nixosProfiles; [
    sway
    ui
    waybar
    terminal
    git
    neovim
    firefox
    easyeffects
    obs
    utils
  ];
}

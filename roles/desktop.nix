{ inputs, ... }: {
  imports = with inputs.self.nixosProfiles; [
    sway
    waybar
    terminal
    git
    neovim
    firefox
    obs
    utils
  ];
}

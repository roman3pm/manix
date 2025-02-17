{ inputs, ... }:
{
  imports = with inputs.self.nixosProfiles; [
    age
    boot
    browser
    docker
    easyeffects
    flatpak
    git
    hardware
    home
    locale
    neovim
    networking
    programs
    settings
    system
    terminal
    ui
    users
  ];
}

{ inputs, ... }:
{
  imports = with inputs.self.nixosProfiles; [
    age
    boot
    browser
    easyeffects
    git
    hardware
    home
    locale
    neovim
    networking
    programs
    security
    services
    settings
    system
    terminal
    ui
    users
    virtualisation
  ];
}

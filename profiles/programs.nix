{
  programs = {
    fish.enable = true;
    dconf.enable = true;
    ssh.startAgent = true;
    gnupg.agent.enable = true;
    nix-index-database.comma.enable = true;
  };

  services = {
    openssh = {
      enable = true;
      settings.PermitRootLogin = "no";
    };
    dbus.enable = true;
    v2raya.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
    };
    mpd.enable = true;
    udisks2.enable = true;
    printing.enable = true;
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };
}

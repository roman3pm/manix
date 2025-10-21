{ pkgs, ... }:
{
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
    printing = {
      enable = true;
      drivers = [ pkgs.hplipWithPlugin ];
    };
  };
}

{ pkgs, ... }:
{
  users = {
    groups.plugdev = { };
    users.roz = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "storage"
        "networkmanager"
        "input"
        "video"
        "audio"
        "docker"
        "plugdev"
      ];
      shell = pkgs.fish;
    };
  };
}

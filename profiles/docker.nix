{
  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      live-restore = false;
      default-address-pools = [
        {
          base = "172.27.0.0/16";
          size = 24;
        }
      ];
    };
  };
}

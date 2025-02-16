{ pkgs, config, ... }:
let
  crypt = import ../secrets/crypt.nix;
in
{
  networking = {
    hostName = config.hostName;
    networkmanager.enable = true;
    wg-quick.interfaces = {
      wg0 =
        let
          listenPort = 51820;
        in
        {
          inherit listenPort;
          autostart = false;
          preUp = "${pkgs.nmap}/bin/nping --udp --count 1 --data-length 16 --source-port ${builtins.toString listenPort} --dest-port ${builtins.toString crypt.wg0.port} ${crypt.wg0.host}";
          address = [
            "10.9.40.123/16"
            "fd42:42:42:42::287b/104"
          ];
          dns = [ "10.9.0.1" ];
          privateKeyFile = config.age.secrets."secrets/wg0-privateKey".path;
          peers = [ crypt.wg0.peer ];
        };
    };
  };

  services.openvpn.servers = {
    ds = {
      autoStart = false;
      config = ''config /home/roz/.secret/DS.ovpn'';
      updateResolvConf = true;
    };
  };
}

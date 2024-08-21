{ pkgs, ... }:
{
  networking = {
    firewall = {
      extraCommands = ''
        ${pkgs.iptables}/bin/iptables -t mangle -I POSTROUTING -o enp34s0 -p tcp -m multiport --dports 80,443 -m connbytes --connbytes-dir=original --connbytes-mode=packets --connbytes 1:6 -m mark ! --mark 0x40000000/0x40000000 -j NFQUEUE --queue-num 200 --queue-bypass
        ${pkgs.iptables}/bin/ip6tables -t mangle -I POSTROUTING -o enp34s0 -p tcp -m multiport --dports 80,443 -m connbytes --connbytes-dir=original --connbytes-mode=packets --connbytes 1:6 -m mark ! --mark 0x40000000/0x40000000 -j NFQUEUE --queue-num 200 --queue-bypass
      '';
    };
  };
  systemd = {
    services = {
      zapret = {
        description = "DPI bypass multi platform";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.zapret}/bin/nfqws --daemon --pidfile=/run/nfqws.pid --dpi-desync=fake,split2 --dpi-desync-ttl=2 --dpi-desync-ttl6=3 --dpi-desync-split-pos=1 --dpi-desync-fooling=md5sig --qnum=200";
          ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
          ExecStop = "${pkgs.coreutils}/bin/kill -INT $MAINPID";
          PIDFile = "/run/nfqws.pid";
          Restart = "always";
          RestartSec = "5s";
        };
      };
    };
  };
}

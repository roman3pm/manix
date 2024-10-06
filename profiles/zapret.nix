{ pkgs, config, ... }:
{
  networking = {
    firewall = {
      extraCommands = ''
        ${pkgs.iptables}/bin/iptables -t mangle -I POSTROUTING -o ${config.devices.interface} -p tcp -m multiport --dports 80,443 -m connbytes --connbytes-dir=original --connbytes-mode=packets --connbytes 1:6 -m mark ! --mark 0x40000000/0x40000000 -j NFQUEUE --queue-num 200 --queue-bypass
        ${pkgs.iptables}/bin/ip6tables -t mangle -I POSTROUTING -o ${config.devices.interface} -p tcp -m multiport --dports 80,443 -m connbytes --connbytes-dir=original --connbytes-mode=packets --connbytes 1:6 -m mark ! --mark 0x40000000/0x40000000 -j NFQUEUE --queue-num 200 --queue-bypass
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
          ExecStart = "${pkgs.zapret}/bin/nfqws --daemon --pidfile=/run/nfqws.pid --dpi-desync=split2 --dpi-desync-split-pos=1 --wssize 1:6 --qnum=200";
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

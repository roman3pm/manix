{ pkgs, ... }:
let
  files = pkgs.fetchFromGitHub {
    owner = "Flowseal";
    repo = "zapret-discord-youtube";
    rev = "1.8.5";
    sparseCheckout = [
      "bin"
      "lists"
    ];
    hash = "sha256-qXuM79HsN4grpjbduY1wSsZDQvWT8Csla4QAhxyil0U=";
  };
  BIN = "${files}/bin/";
  LISTS = "${files}/lists/";
  GameFilter = "12";
in
{
  networking.firewall.extraCommands = ''
    ip46tables -t mangle -I POSTROUTING -p tcp -m multiport --dports 80,443,2053,2083,2087,2096,8443,${GameFilter} -m connbytes --connbytes-dir=original --connbytes-mode=packets --connbytes 1:6 -m mark ! --mark 0x40000000/0x40000000 -j NFQUEUE --queue-num 200 --queue-bypass
    ip46tables -t mangle -A POSTROUTING -p udp -m multiport --dports 443,19294:19344,50000:50100,${GameFilter} -m mark ! --mark 0x40000000/0x40000000 -j NFQUEUE --queue-num 200 --queue-bypass
  '';
  systemd.services.zapret = {
    enable = true;
    description = "DPI bypass service";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];

    serviceConfig = {
      ExecStart = ''
        ${pkgs.zapret}/bin/nfqws --pidfile=/run/nfqws.pid --qnum=200 \
          --filter-udp=443 --hostlist="${LISTS}list-general.txt" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic="${BIN}quic_initial_www_google_com.bin" --new \
          --filter-udp=19294-19344,50000-50100 --filter-l7=discord,stun --dpi-desync=fake --dpi-desync-repeats=6 --new \
          --filter-tcp=80 --hostlist="${LISTS}list-general.txt" --dpi-desync=fake,multisplit --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --new \
          --filter-tcp=2053,2083,2087,2096,8443 --hostlist-domains=discord.media --dpi-desync=multisplit --dpi-desync-split-pos=2,sniext+1 --dpi-desync-split-seqovl=679 --dpi-desync-split-seqovl-pattern="${BIN}tls_clienthello_www_google_com.bin" --new \
          --filter-tcp=443 --hostlist="${LISTS}list-general.txt" --dpi-desync=multisplit --dpi-desync-split-pos=2,sniext+1 --dpi-desync-split-seqovl=679 --dpi-desync-split-seqovl-pattern="${BIN}tls_clienthello_www_google_com.bin" --new \
          --filter-udp=443 --ipset="${LISTS}ipset-all.txt.backup" --dpi-desync=fake --dpi-desync-repeats=6 --dpi-desync-fake-quic="${BIN}quic_initial_www_google_com.bin" --new \
          --filter-tcp=80 --ipset="${LISTS}ipset-all.txt.backup" --dpi-desync=fake,multisplit --dpi-desync-autottl=2 --dpi-desync-fooling=md5sig --new \
          --filter-tcp=443,${GameFilter} --ipset="${LISTS}ipset-all.txt.backup" --dpi-desync=syndata --new \
          --filter-udp=${GameFilter} --ipset="${LISTS}ipset-all.txt.backup" --dpi-desync=fake --dpi-desync-autottl=2 --dpi-desync-repeats=12 --dpi-desync-any-protocol=1 --dpi-desync-fake-unknown-udp="${BIN}quic_initial_www_google_com.bin" --dpi-desync-cutoff=n2
      '';
      Type = "simple";
      PIDFile = "/run/nfqws.pid";
      Restart = "always";
      RuntimeMaxSec = "1h";
    };
  };
}

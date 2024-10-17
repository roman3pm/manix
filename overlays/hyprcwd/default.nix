{ stdenv, fetchFromGitHub }:
stdenv.mkDerivation rec {
  pname = "hyprcwd";
  version = "unstable-2023-03-14";

  src = fetchFromGitHub {
    owner = "vilari-mickopf";
    repo = "${pname}";
    rev = "4a199972b11372c1bf5079b13e7130055e6c8453";
    sha256 = "sha256-jQCO+3MYVqvkqypS143TcAqrWiTduYn+70sZTpDRv8k=";
  };

  makeFlags = [ "PREFIX=$(out)" ];
}

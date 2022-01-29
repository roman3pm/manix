{ lib, stdenv, fetchFromGitHub, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  name = "gruvbox-material-gtk";

  src = fetchFromGitHub {
    owner = "TheGreatMcPain";
    repo = "gruvbox-material-gtk";
    rev = "cc255d43322ad646bb35924accb0778d5e959626";
    sha256 = "sha256-1O34p9iZelqRFBloOSZkxV0Z/7Jffciptpj3fwXPHbc=";
  };

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  installPhase = ''
    mkdir -p $out/share
    cp -r themes $out/share
  '';

  meta = with lib; {
    description = "Gruvbox-Material-Dark theme for GTK based desktop environments";
    homepage = "https://github.com/TheGreatMcPain/gruvbox-material-gtk";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.roman3pm ];
  };
}

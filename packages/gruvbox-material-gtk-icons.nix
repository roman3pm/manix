{ lib, stdenv, fetchFromGitHub, gtk3, breeze-icons, hicolor-icon-theme }:

stdenv.mkDerivation rec {
  name = "gruvbox-material-gtk-icons";

  src = fetchFromGitHub {
    owner = "TheGreatMcPain";
    repo = "gruvbox-material-gtk";
    rev = "cc255d43322ad646bb35924accb0778d5e959626";
    sha256 = "sha256-1O34p9iZelqRFBloOSZkxV0Z/7Jffciptpj3fwXPHbc=";
  };

  buildInputs = [ gtk3 ];

  propagatedBuildInputs = [ breeze-icons hicolor-icon-theme ];

  installPhase = ''
    mkdir -p $out/share
    cp -r icons $out/share
    gtk-update-icon-cache $out/share/icons/Gruvbox-Material-Dark
  '';

  dontDropIconThemeCache = true;

  meta = with lib; {
    description = "Gruvbox-Material-Dark icons for GTK based desktop environments";
    homepage = "https://github.com/TheGreatMcPain/gruvbox-material-gtk";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.roman3pm ];
  };
}

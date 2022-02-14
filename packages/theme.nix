{ pkgs, stdenv, writeText, ... }:
let
  colors = import ../colors.nix;
in
  with pkgs; stdenv.mkDerivation rec {
    name = "oomox-theme";
    src = fetchFromGitHub {
      owner = "themix-project";
      repo = "oomox";
      rev = "1.14";
      sha256 = "0zk2q0z0n64kl6my60vkq11gp4mc442jxqcwbi4kl108242izpjv";
      fetchSubmodules = true;
    };
    dontBuild = true;
    nativeBuildInputs = [ glib libxml2 bc ];
    buildInputs = [ gnome3.gnome-themes-extra gdk-pixbuf librsvg pkgs.sassc pkgs.inkscape pkgs.optipng ];
    propagatedUserEnvPkgs = [ gtk-engine-murrine ];
    installPhase = ''
      # icon theme
      mkdir -p $out/share/icons/suruplus_aspromauros
      pushd plugins/icons_suruplus_aspromauros
      patchShebangs .
      export SURUPLUS_GRADIENT_ENABLED=True
      export SURUPLUS_GRADIENT1=${colors.fg}
      export SURUPLUS_GRADIENT2=${colors.green}
      ./change_color.sh -o suruplus_aspromauros -d $out/share/icons/suruplus_aspromauros -c ${colors.fg}
      popd
      # gtk theme
      mkdir -p $out/share/themes/oomox
      pushd plugins/theme_oomox
      patchShebangs .
      echo "
      BG=${colors.bg}
      FG=${colors.fg}
      HDR_BG=${colors.bg}
      HDR_FG=${colors.fg}
      TXT_BG=${colors.bg}
      TXT_FG=${colors.fg}
      SEL_BG=${colors.blue}
      SEL_FG=${colors.fg}
      BTN_BG=${colors.bg1}
      BTN_FG=${colors.fg}
      HDR_BTN_BG=${colors.bg1}
      HDR_BTN_FG=${colors.fg}
      SPACING=4
      ROUNDNESS=4
      GRADIENT=0.0
      GTK3_GENERATE_DARK=True
      " > $out/oomox.colors
      HOME=$out ./change_color.sh -o oomox -m all -t $out/share/themes $out/oomox.colors
      popd
    '';
  }


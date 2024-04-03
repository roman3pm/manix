{ stdenv, fetchgit, zigpkgs, gitMinimal, autoPatchelfHook }:
stdenv.mkDerivation rec {
  pname = "glsl_analyzer";
  version = "1.4.4";

  src = fetchgit {
    url = "https://github.com/nolanderc/glsl_analyzer.git";
    rev = "v${version}";
    hash = "sha256-7Td5cTn4K/HJz5BHEmWdrX+YdRcPSSSOCPvYRPD3g0g=";
    leaveDotGit = true;
  };

  nativeBuildInputs = [
    zigpkgs.master-2023-12-06
    gitMinimal
    autoPatchelfHook
  ];

  env.ZIG_GLOBAL_CACHE_DIR = "$(mktemp -d)";

  installPhase = ''
    zig build install -Doptimize=ReleaseSafe --prefix $out
  '';
}

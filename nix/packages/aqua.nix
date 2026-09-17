{
  lib,
  stdenvNoCC,
  fetchurl,
}:

let
  version = "2.62.3";
in
stdenvNoCC.mkDerivation {
  pname = "aqua";
  inherit version;

  src = fetchurl {
    url = "https://github.com/aquaproj/aqua/releases/download/v${version}/aqua_darwin_arm64.tar.gz";
    hash = "sha256-5qWDHdErXVcXFqqLgdeZq7CSeKm4O3Ue2T50xoe5yd8=";
  };

  sourceRoot = ".";

  installPhase = ''
    install -Dm755 aqua $out/bin/aqua
  '';

  meta = {
    description = "Declarative CLI version manager";
    homepage = "https://github.com/aquaproj/aqua";
    license = lib.licenses.mit;
    mainProgram = "aqua";
    platforms = [ "aarch64-darwin" ];
  };
}

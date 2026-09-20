{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation rec {
  pname = "apm";
  version = "0.31.0";

  src = fetchurl {
    url = "https://github.com/microsoft/apm/releases/download/v${version}/apm-darwin-arm64.tar.gz";
    hash = "sha256-O5hbpzVbPNkl/ThPQ699LUWRJUQx3yj10BY/FtOhPoE=";
  };

  dontFixup = true;

  installPhase = ''
    mkdir -p $out/lib/apm $out/bin
    cp -R . $out/lib/apm/
    ln -s $out/lib/apm/apm $out/bin/apm
  '';

  meta = {
    description = "Agent Package Manager";
    homepage = "https://github.com/microsoft/apm";
    license = lib.licenses.mit;
    mainProgram = "apm";
    platforms = [ "aarch64-darwin" ];
  };
}
